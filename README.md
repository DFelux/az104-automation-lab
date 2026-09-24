# az104-automation-lab

Idempotente PowerShell/Az-Skripte für eine AZ-104-Übungsumgebung in Azure – Resource Group, VNet, Storage, RBAC, VM (ohne öffentliche IP), NSG-Regeln und Monitoring. Mit `-WhatIf`-Unterstützung, Tagging und dokumentiertem Troubleshooting realer Azure-/PowerShell-Probleme.

Diese Sammlung ist ein sicherer Ausgangspunkt fuer eine persoenliche AZ-104-Lernumgebung. Die Skripte sind absichtlich modular und wiederholbar: bereits vorhandene Ressourcen werden normalerweise nicht veraendert.

## Architektur

```mermaid
graph TD
    RG["Resource Group<br/>rg-az104-lab-gwc<br/>(germanywestcentral)"]
    RG --> VNET["VNet<br/>vnet-az104-lab-gwc<br/>10.10.0.0/16"]
    VNET --> SNET["Subnet<br/>snet-workload<br/>10.10.1.0/24"]
    VNET --> SNET2["Subnet (optional)<br/>via 02b-add-subnet.ps1<br/>z.B. snet-mgmt"]
    RG --> ST["Storage Account<br/>staz104labgwc001"]
    RG --> VM["VM (optional)<br/>vm-az104-lab-01<br/>keine öffentliche IP"]
    SNET --> VM
    RG --> NSG["NSG (optional)<br/>via 08-nsg-rule.ps1<br/>z.B. AllowHttp, AllowSsh"]
    NSG -. manuelle Zuweisung .-> SNET
    RG --> LAW["Log Analytics Workspace<br/>(optional)"]
    RG -. RBAC-Zuweisung .-> PRINCIPAL["Entra-Prinzipal<br/>(optional)"]
    RG -.-> PIP["Public IP (optional, eigenständig)<br/>via 07-public-ip.ps1<br/>nicht mit VM verbunden"]
```

Alle Ressourcen liegen in derselben Resource Group und tragen ein einheitliches Tag-Set (`Project`, `Environment`, `Owner`, `Purpose`, `ManagedBy`). Die VM erhält bewusst keine öffentliche IP-Adresse; Zugriff erfolgt ausschließlich innerhalb des VNets bzw. optional per RBAC-Rollenzuweisung auf Ressourcengruppen-Ebene. Die Public-IP-Erstellung (`07-public-ip.ps1`) ist bewusst eigenständig gehalten und wird nicht automatisch an die VM angehängt – sie dient separaten Übungen (z.B. Bastion, Load Balancer, NAT Gateway). Die NSG (`08-nsg-rule.ps1`) wird bei Bedarf angelegt und mit Regeln befüllt, aber bewusst nicht automatisch einem Subnet oder einer NIC zugewiesen – das bleibt ein separater, einzeln zu übender Schritt.

## Einmal vorbereiten

1. Installiere das Az-Modul: `Install-Module Az -Scope CurrentUser`
2. Kopiere `config.ps1` zu `config.local.ps1` und trage dort deine echte Subscription-ID ein (z.B. per `(Get-AzContext).Subscription.Id`). `config.local.ps1` ist in `.gitignore` eingetragen und wird nie eingecheckt – `config.ps1` bleibt eine Vorlage ohne persoenliche Werte.
3. Melde dich an und waehle die Subscription: `.\00-connect-and-context.ps1 -ConfigPath .\config.local.ps1`

Alle Skripte akzeptieren `-ConfigPath`; ohne Angabe wird die eingecheckte `config.ps1`-Vorlage geladen (mit Platzhalter-Subscription-ID, das wird fehlschlagen). Fuer den taeglichen Gebrauch also immer `-ConfigPath .\config.local.ps1` mitgeben, oder ganz oben im eigenen `config.local.ps1` alles so eintragen, wie du es brauchst.

## Empfohlene Reihenfolge

1. `.\01-resource-group.ps1 -ConfigPath .\config.local.ps1`
2. `.\02-networking.ps1 -ConfigPath .\config.local.ps1`
   - Optional weitere Subnets: `.\02b-add-subnet.ps1 -ConfigPath .\config.local.ps1 -SubnetName "snet-mgmt" -AddressPrefix "10.10.2.0/24"`
3. `.\03-storage.ps1 -ConfigPath .\config.local.ps1`
4. Optional RBAC: `.\04-identity-rbac.ps1 -ConfigPath .\config.local.ps1 -PrincipalObjectId '<Entra-Objekt-ID>' -Role Reader`
5. Optional VM: `.\05-virtual-machine.ps1 -ConfigPath .\config.local.ps1 -LocalAdminCredential (Get-Credential)`
6. Optional Monitoring: `.\06-monitoring.ps1 -ConfigPath .\config.local.ps1`
7. Optional Public IP (eigenständig, z.B. für Bastion/Load Balancer-Übungen): `.\07-public-ip.ps1 -ConfigPath .\config.local.ps1 -PublicIpName "pip-test-01"`
8. Optional NSG-Regeln (legt die NSG bei Bedarf an und fügt Regeln idempotent hinzu):
   ```powershell
   .\08-nsg-rule.ps1 -ConfigPath .\config.local.ps1 -NsgName "nsg-az104-lab-gwc" `
       -RuleName "AllowHttp" -Priority 410 -DestinationPortRange 80 -DestinationAddressPrefix "10.10.1.4"

   .\08-nsg-rule.ps1 -ConfigPath .\config.local.ps1 -NsgName "nsg-az104-lab-gwc" `
       -RuleName "AllowSsh" -Priority 400 -DestinationPortRange 22 -DestinationAddressPrefix "10.10.1.4"
   ```
   Hinweis: `-SourceAddressPrefix "Internet"` ist der Default. Für eine echte SSH-Regel (Port 22) sollte die Quelle in der Praxis auf die eigene öffentliche IP oder Azure Bastion eingeschränkt werden statt auf `Internet` offen zu bleiben – im isolierten Lab ohne Public IP an der VM ist das Risiko gering, aber es lohnt sich, den Unterschied bewusst zu üben.

Vorschau ohne Aenderungen: jedes Erstellungsskript mit `-WhatIf` aufrufen. Die VM erhaelt absichtlich **keine oeffentliche IP-Adresse**. Das vermeidet eine versehentlich direkt aus dem Internet erreichbare Lern-VM.

## Kosten und Aufraeumen

Azure berechnet manche Ressourcen auch dann weiter, wenn du sie nicht verwendest. Nach der Uebung loescht `.\99-cleanup-lab.ps1` die gesamte Ressourcengruppe inklusive aller enthaltenen Ressourcen. Fuehre es bewusst aus; es fragt wegen der hohen Auswirkung nochmals nach.

## Troubleshooting (real aufgetretene Probleme)

**"Resource ... was disallowed by Azure: The selected region is currently not accepting new customers" (403)**
Manche Subscription-Typen (u.a. Free-Trial/Sponsorship) sind fuer bestimmte Regionen gesperrt. `westeurope` war betroffen, `germanywestcentral` funktionierte. Bei diesem Fehler in `config.local.ps1` einfach eine andere Region eintragen und die Ressourcengruppe neu aufbauen (`.\99-cleanup-lab.ps1` → `.\01-resource-group.ps1` → ...).

**Az-Module scheinen nach einem Neustart "verschwunden"**
Windows PowerShell 5.1 (`Documents\WindowsPowerShell\Modules`) und PowerShell 7 (`Documents\PowerShell\Modules`) nutzen getrennte Modul-Pfade (`$env:PSModulePath`). Wenn eine Installation in der einen Shell erfolgte und das Skript spaeter in der anderen Shell laeuft, wirken die Module "fehlend", obwohl sie nur im falschen Pfad-Kontext nicht sichtbar sind. Schneller Check: `Get-Module -ListAvailable -Name Az.* | Measure-Object` sollte rund 90 Module zeigen; eine deutlich kleinere Zahl weist auf eine unvollstaendige Installation im aktuellen Shell-Kontext hin.

## Lernbezug

Die Dateien decken die Kernbereiche von AZ-104 ab: Identitaet/RBAC, Governance durch Tags und Ressourcengruppen, Storage, virtuelle Netzwerke, VMs, Netzwerksicherheit (NSG) sowie Monitoring. Fuer Themen wie Azure Policy, Backup, Load Balancer und Entra-Gruppen dienen sie als Ausgangspunkt und koennen nach derselben Struktur erweitert werden.
