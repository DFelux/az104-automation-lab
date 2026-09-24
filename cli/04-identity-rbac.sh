#!/usr/bin/env bash
set -euo pipefail

# Nutzung: ./04-identity-rbac.sh <PrincipalObjectId> [Role] [config.local.sh]
PRINCIPAL_OBJECT_ID="${1:?PrincipalObjectId fehlt, z.B. (az ad signed-in-user show --query id -o tsv)}"
ROLE="${2:-Reader}"
CONFIG_PATH="${3:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME"

EXISTING=$(az role assignment list \
    --assignee "$PRINCIPAL_OBJECT_ID" \
    --role "$ROLE" \
    --scope "$SCOPE" \
    --query "[0].id" --output tsv)

if [[ -n "$EXISTING" ]]; then
    echo "RBAC-Zuweisung '$ROLE' fuer '$PRINCIPAL_OBJECT_ID' existiert bereits; keine Aenderung vorgenommen." >&2
else
    az role assignment create \
        --assignee "$PRINCIPAL_OBJECT_ID" \
        --role "$ROLE" \
        --scope "$SCOPE"
fi

az role assignment list --assignee "$PRINCIPAL_OBJECT_ID" --scope "$SCOPE" \
    --query "[].{Role:roleDefinitionName, Scope:scope}" --output table
