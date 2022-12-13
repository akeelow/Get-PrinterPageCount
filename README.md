# Get-PrinterPageCount
## .SYNOPSIS
Counts the number of printed pages.

## .DESCRIPTION
 This script is designed to count the number of pages printed by printers over the last 30 days. The script uses the Get-WinEvent commandlet to retrieve information from the Microsoft-Windows-PrintService/Operational event log. Using the Property parameter, you can specify which parameter (such as user name or printer name) to use to group the results. The script then summarizes the number of pages printed with each printer or user and returns a list of those results.

## .PARAMETER Property
Specifies the property to use to group the results. The default is PrinterName.

## .INPUTS
The script does not accept any input.    

## .OUTPUTS
The script returns a list of the number of pages printed with each printer or user.

## .EXAMPLE
    PS> .\Get-PrinterPageCount.ps1
## .EXAMPLE
    PS> .\Get-PrinterPageCount.ps1 -Property UserName
## .EXAMPLE
    PS> .\Get-PrinterPageCount.ps1 -Property PrinterName
