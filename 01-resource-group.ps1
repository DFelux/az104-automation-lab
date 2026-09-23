[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$resourceGroup = Get-AzResourceGroup -Name $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $resourceGroup -and $PSCmdlet.ShouldProcess($Az104.ResourceGroupName, "Create resource group")) {
    $resourceGroup = New-AzResourceGroup -Name $Az104.ResourceGroupName -Location $Az104.Location -Tag $Az104Tags
}
elseif ($resourceGroup) {
    Update-AzTag -ResourceId $resourceGroup.ResourceId -Tag $Az104Tags -Operation Merge | Out-Null
}

$resourceGroup
