#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

if az vm show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP_NAME" &>/dev/null; then
    echo "VM '$VM_NAME' existiert bereits; keine Aenderung vorgenommen." >&2
    exit 0
fi

# Passwort wird interaktiv abgefragt, nie in config.sh gespeichert - Entsprechung zu Get-Credential
read -r -s -p "Lokales Admin-Passwort fuer $VM_NAME: " VM_ADMIN_PASSWORD
echo

echo "Erstelle VM '$VM_NAME' OHNE oeffentliche IP-Adresse..."
az vm create \
    --name "$VM_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --size "$VM_SIZE" \
    --image "$VM_IMAGE" \
    --admin-username "$VM_ADMIN_USERNAME" \
    --admin-password "$VM_ADMIN_PASSWORD" \
    --vnet-name "$VNET_NAME" \
    --subnet "$SUBNET_NAME" \
    --public-ip-address "" \
    --tags "${TAGS[@]}"

unset VM_ADMIN_PASSWORD

az vm show --name "$VM_NAME" --resource-group "$RESOURCE_GROUP_NAME" -d \
    --query "{Name:name, PowerState:powerState, PublicIps:publicIps}" \
    --output table
