<#
  .SYNOPSIS
    Counts the number of printed pages.

  .DESCRIPTION
    This script is designed to count the number of pages printed by printers over the last 30 days. The script uses the Get-WinEvent commandlet to retrieve information from the Microsoft-Windows-PrintService/Operational event log. Using the Property parameter, you can specify which parameter (such as user name or printer name) to use to group the results. The script then summarizes the number of pages printed with each printer or user and returns a list of those results.

  .PARAMETER Property
    Specifies the property to use to group the results. The default is PrinterName.

  .INPUTS
    The script does not accept any input.    

  .OUTPUTS
    The script returns a list of the number of pages printed with each printer or user.

  .EXAMPLE
    PS> .\Get-PrinterPageCount.ps1

  .EXAMPLE
    PS> .\Get-PrinterPageCount.ps1 -Property UserName

  .EXAMPLE
    PS> .\Get-PrinterPageCount.ps1 -Property PrinterName
#>

param (
    [ValidateSet("PrinterName", "UserName")]
    [string]$Property = "PrinterName"
)

$Results = @()

# Get the Microsoft-Windows-PrintService/Operational log events related to printing for the last 30 days.
$PrintLogs = Get-WinEvent -FilterHashTable @{
    LogName   = "Microsoft-Windows-PrintService/Operational"; 
    ID        = 307; 
    StartTime = (Get-Date -OutVariable Now).AddDays(-30) 
} | Select-Object -Property TimeCreated,
@{label = 'UserName'; expression = { $_.properties[2].value } },
@{label = 'PrinterName'; expression = { $_.properties[4].value } },
@{label = 'Pages'; expression = { $_.properties[7].value } }

# Get a list of unique Property values (e.g. PrinterName or UserName) and summarize the number of pages printed with each printer or user.
$QweryItems = $PrintLogs | Select-Object -Property $Property -Unique

foreach ($QweryItem in $QweryItems) {

    # Get the number of pages printed with each printer or user.
    $Pages = $PrintLogs | Where-Object $Property -eq $QweryItem.$Property | Measure-Object -Property Pages -sum
   
    $Results += [PSCustomObject] @{
        $Property = $QweryItem.$Property;
        PageCount = $Pages.Sum
    }
}

Return $Results