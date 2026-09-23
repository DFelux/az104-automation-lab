[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$PublicIpName,

    [ValidateSet("Static", "Dynamic")]
    [string]$AllocationMethod = "Static",

    [ValidateSet("Standard", "Basic")]
    [string]$Sku = "Standard",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$pip = Get-AzPublicIpAddress -Name $PublicIpName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if ($pip) {
    Write-Host "Public IP '$PublicIpName' existiert bereits; keine Aenderung vorgenommen." -ForegroundColor Yellow
}
elseif ($PSCmdlet.ShouldProcess($PublicIpName, "Create public IP ($Sku, $AllocationMethod)")) {
    $pip = New-AzPublicIpAddress -Name $PublicIpName -ResourceGroupName $Az104.ResourceGroupName `
        -Location $Az104.Location -AllocationMethod $AllocationMethod -Sku $Sku -Tag $Az104Tags
    Write-Host "Hinweis: Diese IP ist eigenstaendig und standardmaessig an nichts angehaengt." -ForegroundColor Cyan
    Write-Host "Die Lab-VM bleibt bewusst ohne oeffentliche IP (siehe README)." -ForegroundColor Cyan
}

$pip
