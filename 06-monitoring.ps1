[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$workspaceName = "law-$($Az104.Project)-$($Az104.Environment)-weu"
$workspace = Get-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $workspace -and $PSCmdlet.ShouldProcess($workspaceName, "Create Log Analytics workspace")) {
    $workspace = New-AzOperationalInsightsWorkspace -Location $Az104.Location -Name $workspaceName `
        -Sku PerGB2018 -ResourceGroupName $Az104.ResourceGroupName -Tag $Az104Tags
}
$workspace
