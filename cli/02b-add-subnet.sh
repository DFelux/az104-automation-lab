#!/usr/bin/env bash
set -euo pipefail

# Nutzung: ./02b-add-subnet.sh <SubnetName> <AddressPrefix> [config.local.sh]
SUBNET_NAME_NEW="${1:?SubnetName fehlt, z.B. snet-mgmt}"
SUBNET_PREFIX_NEW="${2:?AddressPrefix fehlt, z.B. 10.10.2.0/24}"
CONFIG_PATH="${3:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

if az network vnet subnet show \
    --name "$SUBNET_NAME_NEW" \
    --vnet-name "$VNET_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "Subnet '$SUBNET_NAME_NEW' existiert bereits; keine Aenderung vorgenommen." >&2
else
    az network vnet subnet create \
        --name "$SUBNET_NAME_NEW" \
        --vnet-name "$VNET_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --address-prefixes "$SUBNET_PREFIX_NEW"
fi

az network vnet subnet list \
    --vnet-name "$VNET_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --query "[].{Name:name, Prefix:addressPrefix}" \
    --output table
