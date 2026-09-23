[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$SubnetName,

    [Parameter(Mandatory)]
    [string]$AddressPrefix,

    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$vnet = Get-AzVirtualNetwork -Name $Az104.VnetName -ResourceGroupName $Az104.ResourceGroupName

$existing = $vnet.Subnets | Where-Object { $_.Name -eq $SubnetName }
if ($existing) {
    Write-Host "Subnet '$SubnetName' existiert bereits; keine Aenderung vorgenommen." -ForegroundColor Yellow
}
elseif ($PSCmdlet.ShouldProcess($SubnetName, "Add subnet to $($Az104.VnetName)")) {
    Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $AddressPrefix -VirtualNetwork $vnet | Out-Null
    Set-AzVirtualNetwork -VirtualNetwork $vnet | Out-Null
    $vnet = Get-AzVirtualNetwork -Name $Az104.VnetName -ResourceGroupName $Az104.ResourceGroupName
}

$vnet.Subnets | Select-Object Name, AddressPrefix
