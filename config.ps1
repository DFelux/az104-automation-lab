# Gemeinsame Einstellungen fuer die AZ-104-Uebungen.
#
# WICHTIG: Diese Datei ist eine OEFFENTLICHE VORLAGE und enthaelt keine echten Werte.
# Kopiere sie einmalig nach config.local.ps1 und trage dort deine echte Subscription-ID
# sowie ggf. andere persoenliche Werte ein. config.local.ps1 ist in .gitignore eingetragen
# und wird niemals committet.
#
# Die Skripte (00-99) laden per Default weiterhin "config.ps1" ueber -ConfigPath.
# Wenn config.local.ps1 existiert, nutze stattdessen:
#   .\01-resource-group.ps1 -ConfigPath .\config.local.ps1

$Az104 = @{
    SubscriptionId       = "<DEINE-SUBSCRIPTION-ID>"   # z.B. per: (Get-AzContext).Subscription.Id
    Location             = "germanywestcentral"
    Environment          = "lab"
    Project              = "az104"
    ResourceGroupName    = "rg-az104-lab-gwc"
    VnetName             = "vnet-az104-lab-gwc"
    VnetAddressPrefix    = "10.10.0.0/16"
    WorkloadSubnetName   = "snet-workload"
    WorkloadSubnetPrefix = "10.10.1.0/24"
    StorageAccountName   = "staz104labgwc001" # weltweit eindeutig, nur Kleinbuchstaben/Ziffern
    VmName               = "vm-az104-lab-01"
    VmSize               = "Standard_B2s"
}

$Az104Tags = @{
    Project     = $Az104.Project
    Environment = $Az104.Environment
    Owner       = "DF"
    Purpose     = "AZ-104 learning lab"
    ManagedBy   = "PowerShell"
}
