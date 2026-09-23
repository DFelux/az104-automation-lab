[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$PrincipalObjectId,

    [ValidateSet("Reader", "Contributor", "Virtual Machine Contributor")]
    [string]$Role = "Reader",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$scope = "/subscriptions/$($Az104.SubscriptionId)/resourceGroups/$($Az104.ResourceGroupName)"
$existing = Get-AzRoleAssignment -ObjectId $PrincipalObjectId -Scope $scope -RoleDefinitionName $Role -ErrorAction SilentlyContinue
if (-not $existing -and $PSCmdlet.ShouldProcess($PrincipalObjectId, "Assign '$Role' at $scope")) {
    New-AzRoleAssignment -ObjectId $PrincipalObjectId -RoleDefinitionName $Role -Scope $scope
}
elseif ($existing) {
    Write-Host "Die Rollenbindung existiert bereits." -ForegroundColor Yellow
}
