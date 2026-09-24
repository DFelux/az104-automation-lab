#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-$(dirname "$0")/config.sh}"
# shellcheck source=/dev/null
source "$CONFIG_PATH"

# Entsprechung zu ConfirmImpact=High: explizite zweite Bestaetigung noetig
echo "ACHTUNG: Dies loescht die gesamte Resource Group '$RESOURCE_GROUP_NAME' samt allen enthaltenen Ressourcen."
read -r -p "Zum Bestaetigen exakt den Resource-Group-Namen eingeben: " CONFIRM
if [[ "$CONFIRM" != "$RESOURCE_GROUP_NAME" ]]; then
    echo "Abgebrochen - Eingabe stimmte nicht ueberein." >&2
    exit 1
fi

az group delete --name "$RESOURCE_GROUP_NAME" --yes
echo "Resource Group '$RESOURCE_GROUP_NAME' geloescht."
