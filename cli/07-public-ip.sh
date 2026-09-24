#!/usr/bin/env bash
set -euo pipefail

# Nutzung: ./07-public-ip.sh <PublicIpName> [AllocationMethod] [Sku] [config.local.sh]
PIP_NAME="${1:?PublicIpName fehlt}"
ALLOCATION="${2:-Static}"
SKU="${3:-Standard}"
CONFIG_PATH="${4:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

if az network public-ip show --name "$PIP_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "Public IP '$PIP_NAME' existiert bereits; keine Aenderung vorgenommen." >&2
else
    az network public-ip create \
        --name "$PIP_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --allocation-method "$ALLOCATION" \
        --sku "$SKU" \
        --tags "${TAGS[@]}"
    echo "Hinweis: Diese IP ist eigenstaendig und standardmaessig an nichts angehaengt." >&2
    echo "Die Lab-VM bleibt bewusst ohne oeffentliche IP (siehe README)." >&2
fi

az network public-ip show --name "$PIP_NAME" --resource-group "$RESOURCE_GROUP_NAME" \
    --query "{Name:name, IpAddress:ipAddress, Sku:sku.name, Allocation:publicIPAllocationMethod}" \
    --output table
