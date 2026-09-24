# Azure CLI-Variante

Dieselbe AZ-104-Übungsumgebung wie im Hauptteil des Repos, hier als Azure-CLI/Bash-Skripte statt Az-PowerShell. Gedacht als Ergänzung, nicht als Ersatz: AZ-104 prüft beide Werkzeuge, und der direkte Vergleich (siehe Tabelle unten) zeigt, wie sich dieselben Konzepte über verschiedene Tools hinweg übertragen.

## Einmal vorbereiten

1. Azure CLI installieren: https://learn.microsoft.com/cli/azure/install-azure-cli
2. Kopiere `config.sh` zu `config.local.sh` und trage deine echte Subscription-ID ein (`az account show --query id --output tsv`, sobald du eingeloggt bist). `config.local.sh` gehört wie `config.local.ps1` in `.gitignore` und wird nie eingecheckt.
3. Skripte ausführbar machen: `chmod +x *.sh`
4. Anmelden: `./00-connect-and-context.sh config.local.sh`

Alle Skripte akzeptieren die Config-Datei als **letztes** positionelles Argument; ohne Angabe wird `config.sh` (Platzhalter-Vorlage) geladen.

## Empfohlene Reihenfolge

```bash
./01-resource-group.sh config.local.sh
./02-networking.sh config.local.sh

# Optional weiterer Subnet
./02b-add-subnet.sh snet-mgmt 10.10.2.0/24 config.local.sh

./03-storage.sh config.local.sh

# Optional RBAC
./04-identity-rbac.sh <Entra-Objekt-ID> Reader config.local.sh

# Optional VM (fragt Admin-Passwort interaktiv ab, ohne öffentliche IP)
./05-virtual-machine.sh config.local.sh

# Optional Monitoring
./06-monitoring.sh config.local.sh

# Optional Public IP (eigenständig, nicht mit der VM verbunden)
./07-public-ip.sh pip-test-01 Static Standard config.local.sh

# Optional NSG-Regeln (legt die NSG bei Bedarf an)
./08-nsg-rule.sh AllowHttp 410 80 10.10.1.4 Inbound Allow Tcp Internet config.local.sh
./08-nsg-rule.sh AllowSsh  400 22 10.10.1.4 Inbound Allow Tcp Internet config.local.sh

# Aufräumen
./99-cleanup-lab.sh config.local.sh
```

`99-cleanup-lab.sh` fragt zur Bestätigung nach dem exakten Resource-Group-Namen (Entsprechung zum `ConfirmImpact = High` im PowerShell-Original).

## Bekannte Einschränkungen gegenüber der PowerShell-Variante

- **Kein `-WhatIf`-Äquivalent.** Die PowerShell-Skripte unterstützen durchgängig eine risikofreie Vorschau; für einzelne, imperative `az`-Befehle gibt es das nicht. Eine echte Vorschau wäre nur über ARM/Bicep-Templates mit `az deployment group what-if` möglich — das wäre ein Architekturwechsel, kein reines Übersetzen.
- **Positionale statt benannte Parameter.** `-SubnetName "snet-mgmt"` wird zu einem festen Argument an fester Position (`./02b-add-subnet.sh snet-mgmt ...`). Reihenfolge ist hier entscheidend.
- **JSON statt Objekte.** Rückgaben sind Text (JSON), gefiltert per `--query` (JMESPath) statt direkter Objekt-Eigenschaften wie in PowerShell.

## Werkzeug-Vergleich (Auszug)

| Konzept | Az PowerShell | Azure CLI |
|---|---|---|
| Login | `Connect-AzAccount` | `az login` |
| Idempotenz-Check | `Get-AzResourceGroup -ErrorAction SilentlyContinue` | `az group show ... &>/dev/null` |
| Tags | Hashtable `-Tag $Az104Tags` | `--tags key1=val1 key2=val2` |
| Config laden | `. $ConfigPath` | `source config.local.sh` |
| Vorschau | `-WhatIf` | kein Äquivalent für Einzelbefehle |

## Lernbezug

Deckt dieselben AZ-104-Kernbereiche ab wie die PowerShell-Variante (siehe Haupt-README): Identität/RBAC, Governance/Tags, Storage, Netzwerke, VMs, Netzwerksicherheit (NSG), Monitoring — hier eben mit dem zweiten in der Prüfung relevanten Werkzeug umgesetzt.
