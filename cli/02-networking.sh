#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

if az network vnet show --name "$VNET_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "VNet '$VNET_NAME' existiert bereits; keine Aenderung vorgenommen." >&2
else
    echo "Erstelle VNet '$VNET_NAME' mit Subnet '$SUBNET_NAME'..."
    az network vnet create \
        --name "$VNET_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --address-prefixes "$VNET_PREFIX" \
        --subnet-name "$SUBNET_NAME" \
        --subnet-prefixes "$SUBNET_PREFIX" \
        --tags "${TAGS[@]}"
fi

az network vnet subnet list \
    --vnet-name "$VNET_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --query "[].{Name:name, Prefix:addressPrefix}" \
    --output table
