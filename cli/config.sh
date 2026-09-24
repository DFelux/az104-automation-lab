#!/usr/bin/env bash
# Vorlage - kopiere nach config.local.sh und trage echte Werte ein.
# config.local.sh gehoert in .gitignore, genau wie config.local.ps1 im PowerShell-Zweig.

SUBSCRIPTION_ID="<DEINE-SUBSCRIPTION-ID>"
LOCATION="germanywestcentral"
RESOURCE_GROUP_NAME="rg-az104-lab-gwc"

VNET_NAME="vnet-az104-lab-gwc"
VNET_PREFIX="10.10.0.0/16"
SUBNET_NAME="snet-workload"
SUBNET_PREFIX="10.10.1.0/24"

STORAGE_ACCOUNT_NAME="staz104labgwc001"

VM_NAME="vm-az104-lab-01"
VM_SIZE="Standard_B2s"
VM_IMAGE="Win2022Datacenter"
VM_ADMIN_USERNAME="azureadmin"

LAW_NAME="law-az104-lab-gwc"
NSG_NAME="nsg-az104-lab-gwc"

TAGS=(
    "Project=az104"
    "Environment=lab"
    "Owner=DF"
    "Purpose=AZ-104 learning lab"
    "ManagedBy=AzureCLI"
)

az account set --subscription "$SUBSCRIPTION_ID"
