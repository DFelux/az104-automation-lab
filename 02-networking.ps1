[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$vnet = Get-AzVirtualNetwork -Name $Az104.VnetName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $vnet) {
    $subnet = New-AzVirtualNetworkSubnetConfig -Name $Az104.WorkloadSubnetName -AddressPrefix $Az104.WorkloadSubnetPrefix
    if ($PSCmdlet.ShouldProcess($Az104.VnetName, "Create virtual network")) {
        $vnet = New-AzVirtualNetwork -Name $Az104.VnetName -ResourceGroupName $Az104.ResourceGroupName `
            -Location $Az104.Location -AddressPrefix $Az104.VnetAddressPrefix -Subnet $subnet -Tag $Az104Tags
    }
}
else {
    Write-Host "VNet existiert bereits; keine Adressbereiche werden veraendert." -ForegroundColor Yellow
}

$vnet
