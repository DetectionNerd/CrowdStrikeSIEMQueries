# 🛡️ CrowdStrike SIEM Queries
A collection of SIEM detection, hunting, and reporting queries for searching through logs on CrowdStrike NG-SIEM. Includes searches for logs from CrowdStrike Falcon EDR, Duo, Microsoft 365, Umbrella, Mimecast and other commonly integrated log sources. 

This repository is designed mostly for the author to keep a journal of queries/scripts, but may help security analysts, incident responders, and threat hunters accelerate investigations and improve detection coverage.

**References:** 
- Cool Query Friday on reddit.com/r/crowdstrike
- github.com/crowdstrike

---

## 📖 Repository Structure

Queries are organized by log source for easy navigation:

| Log Source | Folder |
|-----------|--------|
| Quick References for CQL | [`/007-Quick-References-For-CQL`](./007-Quick-References-For-CQL) |
| Threat Hunting | [`/ThreatHunting`](./ThreatHunting) |
| Cross-Domain Searches | [`/CrossDomainSearches`](./CrossDomainSearches) |
| CrowdStrike Logscale Collector Config. Files | [`/CrowdStrikeLogscaleCollectorConfigurationFiles`](./CrowdStrikeLogscaleCollectorConfigurationFiles) |
| CrowdStrike Falcon | [`/CrowdStrike-Falcon`](./CrowdStrike-Falcon) |
| Duo Security | [`/Duo`](./Duo) |
| Entra ID | [`/EntraID`](./EntraID) |
| Microsoft 365 (Teams, OneDrive, SharePoint) | [`/M365`](./M365) |
| Cisco Umbrella | [`/Umbrella`](./Umbrella) |
| Mimecast | [`/Mimecast`](./Mimecast) |
| Windows Event Logs (via on-prem LogScale collector) | [`/WinEventLogs`](./WinEventLogs) |

---

## 🔍 Quick Links to Query Collections

### ### 🦅 CrowdStrike Falcon Queries
👉 [View Falcon Queries](./CrowdStrike-Falcon)

Includes:
- Endpoint Detection & Response (EDR) queries  
- Sensor health & coverage
- OS Version/Build Audit
- Falcon Platform Activity  


---

### 🔐 Duo Security Queries
👉 [View Duo Queries](./Duo)

Includes:
- High-risk login behavior
- Device Change Fraud 

---

### 🧭 Cisco Umbrella Queries  
👉 [View Umbrella Queries](./Umbrella)

Includes:
- High-risk domain lookups  
- Command & control (C2) indicators  
- Proxy activity anomalies  

---

### 📨 Mimecast Queries  
👉 [View Mimecast Queries](./Mimecast)

Includes:
- Phishing indicators  
- Suspicious email senders  
- Malware detections  
- Targeted threat protection logs  

---

### 🏢 Microsoft 365 Queries  
👉 [View M365 Queries](./M365)

Subfolders include:  
- [`Teams`](./M365/Teams)  
- [`OneDrive`](./M365/OneDrive)  
- [`SharePoint`](./M365/SharePoint)  

Covers:
- File access anomalies  
- Suspicious sharing links


```md
