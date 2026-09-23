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
