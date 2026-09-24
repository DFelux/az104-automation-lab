#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

if az storage account show --name "$STORAGE_ACCOUNT_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "Storage Account '$STORAGE_ACCOUNT_NAME' existiert bereits; keine Aenderung vorgenommen." >&2
else
    echo "Erstelle Storage Account '$STORAGE_ACCOUNT_NAME'..."
    az storage account create \
        --name "$STORAGE_ACCOUNT_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --sku Standard_LRS \
        --kind StorageV2 \
        --access-tier Hot \
        --min-tls-version TLS1_2 \
        --allow-blob-public-access false \
        --tags "${TAGS[@]}"
fi

az storage account show --name "$STORAGE_ACCOUNT_NAME" --resource-group "$RESOURCE_GROUP_NAME" \
    --query "{Name:name, Location:primaryLocation, Sku:sku.name, ProvisioningState:provisioningState}" \
    --output table
