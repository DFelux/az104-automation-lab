#!/usr/bin/env bash
set -euo pipefail

# Nutzung: ./08-nsg-rule.sh <RuleName> <Priority> <DestPort> <DestAddressPrefix> [Direction] [Access] [Protocol] [SourceAddressPrefix] [config.local.sh]
RULE_NAME="${1:?RuleName fehlt, z.B. AllowHttp}"
PRIORITY="${2:?Priority fehlt, z.B. 410}"
DEST_PORT="${3:?DestinationPortRange fehlt, z.B. 80}"
DEST_PREFIX="${4:?DestinationAddressPrefix fehlt, z.B. 10.10.1.4}"
DIRECTION="${5:-Inbound}"
ACCESS="${6:-Allow}"
PROTOCOL="${7:-Tcp}"
SOURCE_PREFIX="${8:-Internet}"
CONFIG_PATH="${9:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

# NSG idempotent anlegen
if az network nsg show --name "$NSG_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "NSG '$NSG_NAME' existiert bereits." >&2
else
    az network nsg create \
        --name "$NSG_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --location "$LOCATION" \
        --tags "${TAGS[@]}"
    echo "NSG '$NSG_NAME' erstellt." >&2
fi

# Regel idempotent hinzufuegen
if az network nsg rule show --name "$RULE_NAME" --nsg-name "$NSG_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "Regel '$RULE_NAME' existiert bereits in '$NSG_NAME'; keine Aenderung vorgenommen." >&2
else
    az network nsg rule create \
        --name "$RULE_NAME" \
        --nsg-name "$NSG_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --priority "$PRIORITY" \
        --direction "$DIRECTION" \
        --access "$ACCESS" \
        --protocol "$PROTOCOL" \
        --source-address-prefixes "$SOURCE_PREFIX" \
        --source-port-ranges "*" \
        --destination-address-prefixes "$DEST_PREFIX" \
        --destination-port-ranges "$DEST_PORT" \
        --description "Erstellt via 08-nsg-rule.sh"
fi

az network nsg rule list --nsg-name "$NSG_NAME" --resource-group "$RESOURCE_GROUP_NAME" \
    --query "[].{Name:name, Access:access, Direction:direction, Priority:priority, Protocol:protocol, Port:destinationPortRange}" \
    --output table
