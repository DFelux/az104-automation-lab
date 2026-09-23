[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    throw "Das Az-PowerShell-Modul fehlt. Installiere es einmalig mit: Install-Module Az -Scope CurrentUser"
}

Connect-AzAccount | Out-Null
Set-AzContext -SubscriptionId $Az104.SubscriptionId | Out-Null

$context = Get-AzContext
Write-Host "Verbunden mit Subscription '$($context.Subscription.Name)' ($($context.Subscription.Id))." -ForegroundColor Green
