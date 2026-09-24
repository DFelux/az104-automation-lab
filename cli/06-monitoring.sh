#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

if az monitor log-analytics workspace show --workspace-name "$LAW_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "Log Analytics Workspace '$LAW_NAME' existiert bereits; keine Aenderung vorgenommen." >&2
else
    az monitor log-analytics workspace create \
        --workspace-name "$LAW_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --tags "${TAGS[@]}"
fi

az monitor log-analytics workspace show --workspace-name "$LAW_NAME" --resource-group "$RESOURCE_GROUP_NAME" \
    --query "{Name:name, Location:location, RetentionDays:retentionInDays}" \
    --output table
