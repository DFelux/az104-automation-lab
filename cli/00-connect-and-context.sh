#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"

# Az-CLI-Installationspruefung (Entsprechung zur Az.Accounts-Modulpruefung in PowerShell)
if ! command -v az &>/dev/null; then
    echo "Azure CLI fehlt. Installationsanleitung: https://learn.microsoft.com/cli/azure/install-azure-cli" >&2
    exit 1
fi

# Nur einloggen, wenn noch keine gueltige Session besteht
if ! az account show &>/dev/null; then
    az login
fi

# shellcheck source=/dev/null
source "$CONFIG_PATH"

SUB_NAME=$(az account show --query "name" --output tsv)
SUB_ID=$(az account show --query "id" --output tsv)
echo "Verbunden mit Subscription: $SUB_NAME ($SUB_ID)"
