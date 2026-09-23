Markdown
# ☁️ AZ-104 Automation Lab (Azure & PowerShell)

![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)
![AZ-104](https://img.shields.io/badge/Cert-AZ--104-blue?style=for-the-badge)

Idempotente **PowerShell/Az-Module-Skripte** zum automatisierten, modularen Aufbau einer vollwertigen und sicheren **AZ-104 Übungsumgebung** in Microsoft Azure. 

Dieses Repository dient als praxisnahe Lernumgebung und demonstriert saubere Workflows nach **Infrastructure-as-Code (IaC)** Prinzipien, **Security-by-Design** sowie automatisierte Governance-Standards.

---

## 🏗️ Architektur-Überblick

```text
[ Resource Group: rg-az104-lab ]
 ├── 🔒 Storage Account (Soft-Delete, Min-TLS 1.2)
 ├── 🌐 Virtual Network (VNet & Subnet mit NSG)
 ├── 💻 Virtual Machine (No Public IP / Secure Access)
 ├── 🔑 Identity & RBAC (Role Assignments / Least Privilege)
 └── 📊 Log Analytics Workspace (Azure Monitor)
🎯 Abgedeckte AZ-104 Domänen & Features
Identity & Governance: Granulare RBAC-Zuweisungen (04-identity-rbac.ps1), automatisiertes Resource Tagging und strukturierte Ressourcengruppen-Verwaltung.

Storage Accounts: Programmatische Erstellung von Azure Storage inkl. Security Best Practices wie erzwungenem TLS 1.2 (03-storage.ps1).

Compute & Networking: VNet-, Subnet- und VM-Provisionierung. Security-by-Design: Die VM erhält absichtlich keine öffentliche IP-Adresse (02-networking.ps1, 05-virtual-machine.ps1), um den Zugriff im Enterprise-Umfeld über VPN, Bastion oder Jump-Hosts zu simulieren.

Monitoring: Erstellung und Konfiguration eines zentralen Log Analytics Workspaces für Diagnosedaten und Log-Analyse (06-monitoring.ps1).

⚙️ Vorbereitung & Sicherheit
Az-Modul installieren:

PowerShell
Install-Module Az -Scope CurrentUser
Lokale Konfiguration anlegen:
Kopiere die Vorlage config.ps1 zu config.local.ps1 und trage dort deine echte Subscription-ID ein (z. B. ermittelbar über (Get-AzContext).Subscription.Id).

PowerShell
Copy-Item .\config.ps1 .\config.local.ps1
🔒 Security Note: config.local.ps1 ist in .gitignore eingetragen und wird nicht im Repository eingecheckt. Das verhindert das versehentliche Veröffentlichen von vertraulichen Parametern oder Subscription-IDs.

🚀 Ausführung & Deployment-Reihenfolge
Die Skripte sind modular aufgebaut und idempotent: Bereits vorhandene Ressourcen werden erkannt und nicht überschrieben. Alle Erstellungsskripte unterstützen den Parameter -WhatIf zur gefahrlosen Vorschau von Änderungen.

1. Authentifizierung
PowerShell
.\00-connect-and-context.ps1 -ConfigPath .\config.local.ps1
2. Infrastruktur-Aufbau
PowerShell
# 1. Ressourcengruppe
.\01-resource-group.ps1 -ConfigPath .\config.local.ps1

# 2. Netzwerkinfrastruktur (VNet, Subnet, NSG)
.\02-networking.ps1 -ConfigPath .\config.local.ps1

# 3. Storage Account
.\03-storage.ps1 -ConfigPath .\config.local.ps1

# 4. RBAC Rollenzuweisung (Optional)
.\04-identity-rbac.ps1 -ConfigPath .\config.local.ps1 -PrincipalObjectId '<Entra-Objekt-ID>' -Role Reader

# 5. Virtual Machine ohne öffentliche IP (Optional)
.\05-virtual-machine.ps1 -ConfigPath .\config.local.ps1 -LocalAdminCredential (Get-Credential)

# 6. Monitoring & Log Analytics (Optional)
.\06-monitoring.ps1 -ConfigPath .\config.local.ps1
3. Kostenkontrolle & Clean-up
Azure berechnet manche Ressourcen auch im Leerlauf. Nach Abschluss der Übungen löscht das Aufräumpskript die komplette Ressourcengruppe inklusive aller enthaltenen Komponenten:

PowerShell
.\99-cleanup-lab.ps1 -ConfigPath .\config.local.ps1
🛠️ Real-World Troubleshooting & Learnings
Im Rahmen der Test-Deployments aufgetretene Hürden und deren operative Behebung:

Error 403 / Regional Quota Restriction (westeurope):

Problem: Bestimmte Subscription-Typen (z. B. Free-Trial oder Sponsorship) sperren Neuzuweisungen in stark ausgelasteten Regionen wie westeurope.

Lösung: Konfiguration in config.local.ps1 flexibel auf germanywestcentral angepasst und die Ressourcengruppe neu aufgebaut.

Fehlende Az-Module nach Shell-Wechsel:

Problem: Windows PowerShell 5.1 (Documents\WindowsPowerShell\Modules) und PowerShell 7 (Documents\PowerShell\Modules) nutzen getrennte Modul-Pfade ($env:PSModulePath). Nach einem Wechsel der Shell-Umgebung schien das Az-Modul zu fehlen.

Lösung: Überprüfung der verfügbaren Module im aktuellen Kontext mittels Get-Module -ListAvailable -Name Az.* | Measure-Object.
