#!/usr/bin/env bash
set -euo pipefail

# Nutzung: ./01-resource-group.sh [config.local.sh]
CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

# Idempotenz-Check: existiert die RG schon?
if az group show --name "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "Resource Group '$RESOURCE_GROUP_NAME' existiert bereits; Tags werden aktualisiert."
    az group update --name "$RESOURCE_GROUP_NAME" --tags "${TAGS[@]}"
else
    echo "Erstelle Resource Group '$RESOURCE_GROUP_NAME' in '$LOCATION'..."
    az group create \
        --name "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --tags "${TAGS[@]}"
fi

az group show --name "$RESOURCE_GROUP_NAME" \
    --query "{Name:name, Location:location, ProvisioningState:properties.provisioningState}" \
    --output table
