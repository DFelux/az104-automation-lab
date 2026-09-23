[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$storage = Get-AzStorageAccount -Name $Az104.StorageAccountName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $storage -and $PSCmdlet.ShouldProcess($Az104.StorageAccountName, "Create storage account")) {
    $storage = New-AzStorageAccount -ResourceGroupName $Az104.ResourceGroupName -Name $Az104.StorageAccountName `
        -Location $Az104.Location -SkuName Standard_LRS -Kind StorageV2 -AccessTier Hot -MinimumTlsVersion TLS1_2 `
        -AllowBlobPublicAccess $false -Tag $Az104Tags
}

# Beispiel fuer einen Blob-Container mit Entra-ID-basierter Anmeldung:
# New-AzStorageContainer -Name "training" -Context $storage.Context
$storage
