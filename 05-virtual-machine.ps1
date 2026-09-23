[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [pscredential]$LocalAdminCredential,

    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

$existing = Get-AzVM -Name $Az104.VmName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "VM existiert bereits; keine Aenderung vorgenommen." -ForegroundColor Yellow
    return $existing
}

$vnet = Get-AzVirtualNetwork -Name $Az104.VnetName -ResourceGroupName $Az104.ResourceGroupName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $Az104.WorkloadSubnetName -VirtualNetwork $vnet
$nicName = "nic-$($Az104.VmName)"
$nic = Get-AzNetworkInterface -Name $nicName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $nic -and $PSCmdlet.ShouldProcess($nicName, "Create network interface")) {
    $nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $Az104.ResourceGroupName -Location $Az104.Location -SubnetId $subnet.Id
}

$vmConfig = New-AzVMConfig -VMName $Az104.VmName -VMSize $Az104.VmSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $Az104.VmName -Credential $LocalAdminCredential -ProvisionVMAgent -EnableAutoUpdate |
    Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2022-datacenter-azure-edition -Version latest |
    Add-AzVMNetworkInterface -Id $nic.Id

if ($PSCmdlet.ShouldProcess($Az104.VmName, "Create VM without public IP")) {
    New-AzVM -ResourceGroupName $Az104.ResourceGroupName -Location $Az104.Location -VM $vmConfig -Tag $Az104Tags
}
