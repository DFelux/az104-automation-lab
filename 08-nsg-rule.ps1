[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$NsgName,

    [string]$RuleName = "AllowHttp",
    [int]$Priority = 410,

    [ValidateSet("Inbound", "Outbound")]
    [string]$Direction = "Inbound",

    [ValidateSet("Allow", "Deny")]
    [string]$Access = "Allow",

    [ValidateSet("Tcp", "Udp", "*")]
    [string]$Protocol = "Tcp",

    [string]$SourceAddressPrefix = "Internet",
    [string]$SourcePortRange = "*",

    [string]$DestinationAddressPrefix = "10.10.1.4",
    [string]$DestinationPortRange = "80",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "config.ps1")
)

$ErrorActionPreference = "Stop"
. $ConfigPath

# NSG idempotent anlegen
$nsg = Get-AzNetworkSecurityGroup -Name $NsgName -ResourceGroupName $Az104.ResourceGroupName -ErrorAction SilentlyContinue
if (-not $nsg) {
    if ($PSCmdlet.ShouldProcess($NsgName, "Create NSG")) {
        $nsg = New-AzNetworkSecurityGroup -Name $NsgName -ResourceGroupName $Az104.ResourceGroupName `
            -Location $Az104.Location -Tag $Az104Tags
        Write-Host "NSG '$NsgName' erstellt." -ForegroundColor Green
    }
}
else {
    Write-Host "NSG '$NsgName' existiert bereits." -ForegroundColor Yellow
}

# Regel idempotent hinzufuegen
$existingRule = $nsg.SecurityRules | Where-Object { $_.Name -eq $RuleName }
if ($existingRule) {
    Write-Host "Regel '$RuleName' existiert bereits in '$NsgName'; keine Aenderung vorgenommen." -ForegroundColor Yellow
}
elseif ($PSCmdlet.ShouldProcess($RuleName, "Add security rule to $NsgName")) {
    Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $RuleName `
        -Description "Erstellt via 08-nsg-rule.ps1" `
        -Access $Access -Protocol $Protocol -Direction $Direction -Priority $Priority `
        -SourceAddressPrefix $SourceAddressPrefix -SourcePortRange $SourcePortRange `
        -DestinationAddressPrefix $DestinationAddressPrefix -DestinationPortRange $DestinationPortRange | Out-Null
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg | Out-Null
    $nsg = Get-AzNetworkSecurityGroup -Name $NsgName -ResourceGroupName $Az104.ResourceGroupName
}

$nsg.SecurityRules | Select-Object Name, Access, Direction, Priority, Protocol, DestinationPortRange, DestinationAddressPrefix
