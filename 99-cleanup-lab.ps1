[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$rg = Get-AzResourceGroup -Name $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    Write-Host "Die Ressourcengruppe wurde nicht gefunden." -ForegroundColor Yellow
    return
}

if ($PSCmdlet.ShouldProcess($Az104.ResourceGroupName, "Permanently delete the resource group and all contained resources")) {
    Remove-AzResourceGroup -Name $Az104.ResourceGroupName -Force
}
