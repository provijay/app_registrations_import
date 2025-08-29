# Azure Services SLA & Multi-Region DR Assessment

## 1. Introduction
This document serves as a central reference point for understanding the availability, resiliency, and disaster recovery (DR) posture of all Azure services currently in use (or planned to be used) by our business units.

Modern enterprises rely heavily on cloud services to deliver mission-critical applications. However, each Azure service comes with its own Service Level Agreement (SLA) and resiliency capabilities. At the same time, our business units define their own SLA expectations, often in terms of availability, Recovery Point Objective (RPO), and Recovery Time Objective (RTO).

The purpose of this document is to:

✅ List all relevant Azure services and identify which ones are used by our business units.

✅ Capture business unit SLA requirements (availability, RPO, RTO) for each service.

✅ Compare business expectations with Microsoft’s published SLAs for these services.

✅ Identify gaps or risks where business requirements exceed Microsoft’s guarantees.

✅ Provide recommendations for multi-region deployment, failover strategies, or architecture adjustments to meet enterprise resiliency needs.

✅ Serve as a decision framework for aligning technology capabilities with business continuity requirements.

This document will evolve over time as:

New Azure services are onboarded.

Microsoft updates SLAs or introduces new resiliency options.

Business SLA requirements change due to compliance, risk appetite, or strategic shifts.

Ultimately, the goal is to ensure that our cloud service availability and disaster recovery strategy align with business expectations and compliance obligations.
---

## 2. Business Units Covered
- **BU1 – Finance**
- **BU2 – Operations**
- **BU3 – Sales & Marketing**
- **BU4 – HR & Internal IT**
- *(Add more as required)*

---

## 3. Azure Services Inventory
> Tick (`✔`) which services are used by each business unit.  
# Azure Services Inventory
> Tick (`✔`) the services implemented in the organisation.  

| Azure Service                        | Implemented | Notes |
|-------------------------------------|------------|-------|
| **Compute**                          |            |       |
| Azure Virtual Machines               | ☐          | Core compute workloads |
| Azure App Service                     | ☐          | Web apps |
| Azure Kubernetes Service (AKS)       | ☐          | Containerized apps |
| Azure Functions                       | ☐          | Event-driven workloads |
| Azure Container Instances             | ☐          | Short-lived containers |
| Azure Container Apps                  | ☐          | Managed container apps |
| Azure Service Fabric                  | ☐          | Microservices platform |
| **Storage**                           |            |       |
| Azure Blob Storage                     | ☐          | Object storage |
| Azure Disk Storage                     | ☐          | Persistent disk for VMs |
| Azure File Storage                     | ☐          | SMB file shares |
| Azure Queue Storage                    | ☐          | Messaging queue |
| Azure Table Storage                    | ☐          | NoSQL key-value store |
| Azure Data Lake Storage Gen2           | ☐          | Big data analytics storage |
| Azure NetApp Files                     | ☐          | Enterprise file storage |
| **Networking**                         |            |       |
| Azure Virtual Network                  | ☐          | Network backbone |
| Azure Load Balancer                     | ☐          | L4 traffic balancing |
| Azure Application Gateway (WAF)       | ☐          | L7 traffic & security |
| Azure VPN Gateway                      | ☐          | Connectivity |
| Azure ExpressRoute                     | ☐          | Private connectivity |
| Azure Front Door                        | ☐          | Global load balancing |
| Azure Traffic Manager                  | ☐          | DNS-based routing |
| Azure DNS                              | ☐          | Domain management |
| Azure Bastion                           | ☐          | Secure RDP/SSH |
| Azure Firewall                          | ☐          | Network security |
| Azure DDoS Protection                   | ☐          | DDoS mitigation |
| Azure Private Link                      | ☐          | Private endpoint connectivity |
| Azure Route Server                      | ☐          | Dynamic routing |
| **Security & Identity**                 |            |       |
| Azure Active Directory (AAD)           | ☐          | Identity & access |
| Azure AD B2C                            | ☐          | Consumer identity |
| Azure AD B2B                            | ☐          | External partners |
| Azure AD Domain Services                | ☐          | Domain-join support |
| Azure Key Vault                          | ☐          | Secrets, keys, certs |
| Azure Security Center / Defender        | ☐          | Threat detection |
| Azure Sentinel                           | ☐          | SIEM & analytics |
| **Databases**                           |            |       |
| Azure SQL Database                       | ☐          | Relational database |
| Azure SQL Managed Instance               | ☐          | Managed instance SQL |
| Azure SQL Hyperscale                     | ☐          | High-volume SQL |
| Azure Cosmos DB                          | ☐          | Multi-model NoSQL DB |
| Azure Database for MySQL                 | ☐          | Managed MySQL DB |
| Azure Database for PostgreSQL            | ☐          | Managed PostgreSQL DB |
| Azure Database for MariaDB               | ☐          | Managed MariaDB DB |
| Azure Synapse Analytics                  | ☐          | Data warehouse & BI |
| Azure Cache for Redis                     | ☐          | In-memory caching |
| **Integration & Messaging**              |            |       |
| Azure Logic Apps                          | ☐          | Workflow automation |
| Azure Service Bus                          | ☐          | Messaging |
| Azure Event Grid                           | ☐          | Event routing |
| Azure Event Hubs                           | ☐          | Telemetry ingestion |
| Azure Notification Hubs                     | ☐          | Push notifications |
| Azure API Management                        | ☐          | API gateway |
| Azure SignalR Service                        | ☐          | Real-time messaging |
| Azure Communication Services                 | ☐          | Chat/voice/video APIs |
| Azure IoT Hub                                | ☐          | IoT device management |
| Azure IoT Central                             | ☐          | IoT SaaS platform |
| Azure Digital Twins                            | ☐          | Digital modeling |
| Azure Time Series Insights                     | ☐          | Time series analytics |
| **Analytics & AI**                              |            |       |
| Azure Machine Learning                           | ☐          | Model training & deployment |
| Azure Cognitive Services                          | ☐          | Prebuilt AI APIs |
| Azure Databricks                                  | ☐          | Big data analytics & AI |
| Azure HDInsight                                   | ☐          | Hadoop / Spark |
| Azure Data Factory                                | ☐          | ETL workflows |
| Azure Stream Analytics                             | ☐          | Real-time analytics |
| **DevOps & Monitoring**                             |            |       |
| Azure DevOps                                      | ☐          | CI/CD & repos |
| Azure DevTest Labs                                 | ☐          | Testing environments |
| Azure App Configuration                            | ☐          | App settings |
| Azure Monitor / Application Insights / Log Analytics | ☐      | Observability |
| Azure Automation                                   | ☐          | Process automation |
| Azure Policy / Blueprints                           | ☐          | Governance & compliance |
| Azure Resource Manager / Resource Graph             | ☐          | Resource management |
| **Backup & Disaster Recovery**                       |            |       |
| Azure Backup                                       | ☐          | Backup service |
| Azure Site Recovery                                | ☐          | Multi-region DR |
| **Hybrid & Multicloud**                             |            |       |
| Azure Arc                                         | ☐          | Hybrid resource management |
| Azure Stack HCI / Hub / Edge                       | ☐          | On-prem integration |
| Azure VMware Solution                               | ☐          | VMware workloads in Azure |
| **Other / Misc**                                    |            |       |
| Power BI Embedded                                   | ☐          | BI dashboards |
| (Continue adding additional Azure services…)       | ☐          |       |



---

## 4. SLA Requirements from Business Units
Each BU defines its **Availability SLA**, **RPO**, and **RTO** expectations.  

#### Example – Finance BU
# Azure Services SLA / RPO / RTO Inventory
> Track SLA, RPO, RTO, and criticality for each Azure service.

# Azure Services Inventory & SLA/RPO/RTO Overview

| Azure Service                        | Microsoft SLA (%) | Business SLA (%) | RPO Requirement | RTO Requirement | Criticality | Notes |
|--------------------------------------|-------------------|------------------|-----------------|-----------------|-------------|-------|
| **Compute**                          |                   |                  |                 |                 |             |       |
| Azure Virtual Machines               | 99.95%            |                  | 1 hr            | 4 hrs           | High        | Core compute workloads |
| Azure App Service                    | 99.95%            |                  | 30 min          | 2 hrs           | High        | Web apps |
| Azure Kubernetes Service (AKS)       | 99.95%            |                  | 30 min          | 2 hrs           | High        | Containerized apps |
| Azure Functions                      | 99.95%            |                  | 15 min          | 30 min          | High        | Event-driven workloads |
| Azure Container Instances            | 99.9%             |                  | 30 min          | 1 hr            | Medium      | Short-lived containers |
| Azure Container Apps                 | 99.9%             |                  | 30 min          | 1 hr            | Medium      | Managed container apps |
| Azure Service Fabric                 | 99.9%             |                  | 1 hr            | 2 hrs           | Medium      | Microservices platform |
| **Storage**                          |                   |                  |                 |                 |             |       |
| Azure Blob Storage                   | 99.9%             |                  | 30 min          | 2 hrs           | High        | Object storage |
| Azure Disk Storage                   | 99.9%             |                  | 1 hr            | 4 hrs           | High        | Persistent disk for VMs |
| Azure File Storage                   | 99.9%             |                  | 30 min          | 2 hrs           | Medium      | SMB file shares |
| Azure Queue Storage                  | 99.9%             |                  | 30 min          | 2 hrs           | Medium      | Messaging queue |
| Azure Table Storage                  | 99.9%             |                  | 1 hr            | 4 hrs           | Medium      | NoSQL key-value store |
| Azure Data Lake Storage Gen2         | 99.9%             |                  | 1 hr            | 2 hrs           | Medium      | Big data analytics storage |
| Azure NetApp Files                   | 99.9%             |                  | 30 min          | 2 hrs           | High        | Enterprise file storage |
| **Networking**                       |                   |                  |                 |                 |             |       |
| Azure Virtual Network                | 99.99%            |                  | N/A             | N/A             | High        | Network backbone |
| Azure Load Balancer                  | 99.99%            |                  | N/A             | 15 min          | High        | L4 traffic balancing |
| Azure Application Gateway (WAF)     | 99.95%            |                  | N/A             | 15 min          | High        | L7 traffic & security |
| Azure VPN Gateway                    | 99.9%             |                  | N/A             | 30 min          | Medium      | Connectivity |
| Azure ExpressRoute                   | 99.95%            |                  | N/A             | 15 min          | High        | Private connectivity |
| Azure Front Door                     | 99.99%            |                  | N/A             | 15 min          | High        | Global load balancing |
| Azure Traffic Manager                | 99.99%            |                  | N/A             | 15 min          | Medium      | DNS-based routing |
| Azure DNS                            | 99.99%            |                  | N/A             | 15 min          | High        | Domain management |
| Azure Bastion                        | 99.95%            |                  | N/A             | 30 min          | Medium      | Secure RDP/SSH |
| Azure Firewall                       | 99.95%            |                  | N/A             | 15 min          | High        | Network security |
| Azure DDoS Protection                | 99.99%            |                  | N/A             | 15 min          | High        | DDoS mitigation |
| Azure Private Link                   | 99.95%            |                  | N/A             | 15 min          | High        | Private endpoint connectivity |
| Azure Route Server                   | 99.95%            |                  | N/A             | 15 min          | Medium      | Dynamic routing |
| **Security & Identity**              |                   |                  |                 |                 |             |       |
| Azure Active Directory (AAD)         | 99.99%            |                  | N/A             | 15 min          | High        | Identity & access |
| Azure AD B2C                         | 99.95%            |                  | N/A             | 30 min          | Medium      | Consumer identity |
| Azure AD B2B                         | 99.95%            |                  | N/A             | 30 min          | Medium      | External partners |
| Azure AD Domain Services             | 99.95%            |                  | N/A             | 30 min          | Medium      | Domain-join support |
| Azure Key Vault                      | 99.99%            |                  | 5 min           | 15 min          | High        | Secrets, keys, certs |
| Azure Security Center / Defender     | 99.95%            |                  | N/A             | 15 min          | High        | Threat detection |
| Azure Sentinel                       | 99.95%            |                  | N/A             | 15 min          | High        | SIEM & analytics |
| **Databases**                        |                   |                  |                 |                 |             |       |
| Azure SQL Database                   | 99.99%            |                  | 15 min          | 1 hr            | High        | Relational database |
| Azure SQL Managed Instance           | 99.99%            |                  | 15 min          | 1 hr            | High        | Managed instance SQL |
| Azure SQL Hyperscale                 | 99.99%            |                  | 15 min          | 1 hr            | High        | High-volume SQL |
| Azure Cosmos DB                      | 99.99%            |                  | 15 min          | 1 hr            | High        | Multi-model NoSQL DB |
| Azure Database for MySQL             | 99.99%            |                  | 15 min          | 1 hr            | Medium      | Managed MySQL DB |
| Azure Database for PostgreSQL        | 99.99%            |                  | 15 min          | 1 hr            | Medium      | Managed PostgreSQL DB |
| Azure Database for MariaDB           | 99.99%            |                  | 15 min          | 1 hr            | Medium      | Managed MariaDB DB |
| Azure Synapse Analytics              | 99.95%            |                  | 30 min          | 2 hrs           | High        | Data warehouse & BI |
| Azure Cache for Redis                | 99.95%            |                  | 5 min           | 15 min          | High        | In-memory caching |
| **Integration & Messaging**          |                   |                  |                 |                 |             |       |
| Azure Logic Apps                     | 99.9%             |                  | 15 min          | 30 min          | High        | Workflow automation |
| Azure Service Bus                    | 99.9%             |                  | 15 min          | 30 min          | High        | Messaging |
| Azure Event Grid                     | 99.9%             |                  | 15 min          | 30 min          | High        | Event routing |
| Azure Event Hubs                     | 99.9%             |                  | 15 min          | 30 min          | High        | Telemetry ingestion |
| Azure Notification Hubs              | 99.9%             |                  | 15 min          | 30 min          | Medium      | Push notifications |
| Azure API Management                 | 99.9%             |                  | 15 min          | 30 min          | High        | API gateway |
| Azure SignalR Service                | 99.9%             |                  | 15 min          | 30 min          | Medium      | Real-time messaging |
| Azure Communication Services         | 99.9%             |                  | 15 min          | 30 min          | Medium      | Chat/voice/video APIs |
| Azure IoT Hub                        | 99.9%             |                  | 15 min          | 30 min          | High        | IoT device management |
| Azure IoT Central                    | 99.9%             |                  | 15 min          | 30 min          | Medium      | IoT SaaS platform |
| Azure Digital Twins                  | 99.9%             |                  | 15 min          | 30 min          | Medium      | Digital modeling |
| Azure Time Series Insights           | 99.9%             |                  | 15 min          | 30 min          | Medium      | Time series analytics |
| **Analytics & AI**                   |                   |                  |                 |                 |             |       |
| Azure Machine Learning               | 99.9%             |                  | 15 min          | 30 min          | High        | Model training & deployment |
| Azure Cognitive Services             | 99.9%             |                  | 15 min          | 30 min          | High        | Prebuilt AI APIs |
| Azure Databricks                     | 99.9%             |                  | 15 min          | 30 min          | High        | Big data analytics & AI |
| Azure HDInsight                      | 99.9%             |                  | 15 min          | 30 min          | Medium      | Hadoop / Spark |
| Azure Data Factory                   | 99.9%             |                  | 15 min          | 30 min          | High        | ETL workflows |
| Azure Stream Analytics               | 99.
::contentReference[oaicite:0]{index=0}
 


*(Repeat for each BU)*  

---

## 5. Microsoft SLA Reference (Fine Print)

### 5.1 Core Compute & Storage
- **Azure Virtual Machines**  
  - 99.99% with 2+ instances across Availability Zones  
  - 99.95% with Availability Sets or Dedicated Hosts  
  - 99.9% for single-instance VMs with Premium SSD/Ultra Disk  
  - 99.5% with Standard SSD; 95% with Standard HDD  

- **Azure Storage**  
  - LRS/ZRS: 99.9% availability  
  - GRS: 99.9% write, 99.9% read  
  - RA-GRS: 99.9% write, 99.99% read  

### 5.2 Databases & Analytics
- **Azure SQL Database**  
  - 99.995% with Business Critical/Premium + Zone Redundant  
  - 99.99% for General Purpose / Premium / Hyperscale (≥2 replicas)  
  - 99.95% Hyperscale (1 replica) / 99.9% (0 replicas)  
  - Business continuity SLA: **RPO ≤ 5s**, **RTO ≤ 30s** (geo-replication)  

- **Azure Database for MySQL/PostgreSQL**  
  - 99.99% connectivity SLA  

- **Azure Synapse Analytics**  
  - 99.9% availability for client operations  

### 5.3 App Services
- **Azure App Service**  
  - 99.95% for paid tiers (no SLA for Free/Shared)  

- **Azure Functions**  
  - 99.95% when running in App Service Plan; no SLA in Consumption tier  

### 5.4 Networking & Security
- **Azure Application Gateway (with WAF)**  
  - 99.95% with ≥2 medium/large instances, autoscaling or zone redundancy enabled  
  - No SLA for single-instance deployments  

- **Azure Front Door (Standard/Premium)**  
  - 99.99% availability, measured via global HTTP probes  

- **Azure Web Application Firewall (WAF)**  
  - SLA inherited from underlying service (App Gateway / Front Door)  

- **Azure Load Balancer (Standard)**  
  - 99.99% when serving 2+ healthy VMs  
  - No SLA for Basic SKU  

- **Azure VPN Gateway**  
  - 99.95% availability  

- **Azure Traffic Manager**  
  - 99.99% DNS query response SLA  

- **Azure DNS**  
  - 100% valid DNS response guarantee  

- **Azure Key Vault**  
  - 99.9% transaction SLA  

### 5.5 Integration & Messaging
- **Azure API Management**  
  - 99.95% for multi-region deployment  
  - 99.9% for single-region deployment  

- **Azure Service Bus**  
  - 99.9% for Basic/Standard tiers  
  - 99.95% for Premium tier  

---

## 6. Gap Analysis

| Service                                 | Business SLA (%) | Microsoft SLA (%) | Gap (%) | Risk    | Notes |
|----------------------------------------|-----------------|------------------|---------|---------|-------|
| **Compute**                             |                 |                  |         |         |       |
| Azure Virtual Machines                  |                 | 99.95%           |         |         | Core compute workloads; consider AZ deployment for higher availability |
| Azure App Service                        |                 | 99.95%           |         |         | Web apps |
| Azure Kubernetes Service (AKS)          |                 | 99.95%           |         |         | Containerized apps; check node redundancy |
| Azure Functions                          |                 | 99.95%           |         |         | Event-driven workloads |
| Azure Container Instances                |                 | 99.9%            |         |         | Short-lived containers |
| Azure Container Apps                     |                 | 99.9%            |         |         | Managed container apps |
| Azure Service Fabric                     |                 | 99.9%            |         |         | Microservices platform |
| **Storage**                              |                 |                  |         |         |       |
| Azure Blob Storage                        |                 | 99.9%            |         |         | Object storage; consider GRS/RA-GRS for DR |
| Azure Disk Storage                        |                 | 99.9%            |         |         | Persistent disk for VMs |
| Azure File Storage                        |                 | 99.9%            |         |         | SMB file shares |
| Azure Queue Storage                       |                 | 99.9%            |         |         | Messaging queue |
| Azure Table Storage                       |                 | 99.9%            |         |         | NoSQL key-value store |
| Azure Data Lake Storage Gen2              |                 | 99.9%            |         |         | Big data analytics storage |
| Azure NetApp Files                        |                 | 99.9%            |         |         | Enterprise file storage |
| **Networking**                            |                 |                  |         |         |       |
| Azure Virtual Network                     |                 | 99.99%           |         |         | Network backbone |
| Azure Load Balancer                        |                 | 99.99%           |         |         | L4 traffic balancing |
| Azure Application Gateway (WAF)           |                 | 99.95%           |         |         | L7 traffic & security; ensure ≥2 instances |
| Azure VPN Gateway                          |                 | 99.9%            |         |         | Connectivity |
| Azure ExpressRoute                         |                 | 99.95%           |         |         | Private connectivity |
| Azure Front Door                            |                 | 99.99%           |         |         | Global load balancing |
| Azure Traffic Manager                      |                 | 99.99%           |         |         | DNS-based routing |
| Azure DNS                                  |                 | 99.99%           |         |         | Domain management |
| Azure Bastion                               |                 | 99.95%           |         |         | Secure RDP/SSH |
| Azure Firewall                              |                 | 99.95%           |         |         | Network security |
| Azure DDoS Protection                       |                 | 99.99%           |         |         | DDoS mitigation |
| Azure Private Link                          |                 | 99.95%           |         |         | Private endpoint connectivity |
| Azure Route Server                          |                 | 99.95%           |         |         | Dynamic routing |
| **Security & Identity**                     |                 |                  |         |         |       |
| Azure Active Directory (AAD)               |                 | 99.99%           |         |         | Identity & access |
| Azure AD B2C                                |                 | 99.95%           |         |         | Consumer identity |
| Azure AD B2B                                |                 | 99.95%           |         |         | External partners |
| Azure AD Domain Services                    |                 | 99.95%           |         |         | Domain-join support |
| Azure Key Vault                             |                 | 99.99%           |         |         | Secrets, keys, certs |
| Azure Security Center / Defender           |                 | 99.95%           |         |         | Threat detection |
| Azure Sentinel                              |                 | 99.95%           |         |         | SIEM & analytics |
| **Databases**                               |                 |                  |         |         |       |
| Azure SQL Database                           |                 | 99.99%           |         |         | Relational database |
| Azure SQL Managed Instance                   |                 | 99.99%           |         |         | Managed instance SQL |
| Azure SQL Hyperscale                         |                 | 99.99%           |         |         | High-volume SQL |
| Azure Cosmos DB                              |                 | 99.99%           |         |         | Multi-model NoSQL DB |
| Azure Database for MySQL                     |                 | 99.99%           |         |         | Managed MySQL DB |
| Azure Database for PostgreSQL                |                 | 99.99%           |         |         | Managed PostgreSQL DB |
| Azure Database for MariaDB                   |                 | 99.99%           |         |         | Managed MariaDB DB |
| Azure Synapse Analytics                      |                 | 99.95%           |         |         | Data warehouse & BI |
| Azure Cache for Redis                        |                 | 99.95%           |         |         | In-memory caching |
| **Integration & Messaging**                  |                 |                  |         |         |       |
| Azure Logic Apps                             |                 | 99.9%            |         |         | Workflow automation |
| Azure Service Bus                             |                 | 99.9%            |         |         | Messaging |
| Azure Event Grid                              |                 | 99.9%            |         |         | Event routing |
| Azure Event Hubs                              |                 | 99.9%            |         |         | Telemetry ingestion |
| Azure API Management                          |                 | 99.9%            |         |         | API gateway |
| Azure IoT Hub                                 |                 | 99.9%            |         |         | IoT device management |
| Azure Machine Learning                        |                 | 99.9%            |         |         | Model training & deployment |
| Azure Cognitive Services                       |                 | 99.9%            |         |         | Prebuilt AI APIs |
| Azure Databricks                               |                 | 99.9%            |         |         | Big data analytics & AI |
| Azure Backup                                   |                 | 99.9%            |         |         | Backup service |
| Azure Site Recovery                            |                 | 99.9%            |         |         | Multi-region DR |

---

## 7. Opportunities for Multi-Region DR
- **Azure SQL Database**: Use **Auto-failover groups** with geo-replication  
- **Azure VMs**: Deploy **Azure Site Recovery (ASR)** to paired region  
- **Azure Storage**: Enable **GRS or RA-GRS** for resilience  
- **App Service**: Deploy across multiple regions with **Traffic Manager/Front Door**  
- **Key Vault**: Use **Geo-redundant vaults** for critical secrets  

---

## 8. Decision Framework for Multi-Region DR
| Criteria                 | Question | Action |
|--------------------------|----------|--------|
| SLA Gap                  | Does business SLA > MS SLA? | If Yes → Multi-region needed |
| RPO/RTO Requirements     | Are RPO/RTO tighter than Azure guarantees? | If Yes → Design DR strategy |
| Business Criticality     | Is the service mission-critical (finance, customer-facing, compliance)? | If Yes → Multi-region recommended |
| Cost vs. Risk            | Is multi-region cost justified by risk reduction? | If Yes → Proceed; else accept risk |

---

## 9. Findings & Recommendations
- **Key Gaps**: (placeholder)  
- **High Risk Services**: (placeholder)  
- **Multi-Region DR Candidates**: (placeholder)  
- **Final Recommendations**: (placeholder)  

---

## 10. Decision Flow for SLA & Multi-Region Strategy
- **Key Gaps**: (placeholder)  
- **High Risk Services**: (placeholder)  
- **Multi-Region DR Candidates**: (placeholder)  
- **Final Recommendations**: (placeholder)  

---

## SLA Strategy by Azure Service
# Azure SLA Strategy Recommendations

| Azure Service                        | SLA Strategy Recommendation                                                                 |
|--------------------------------------|---------------------------------------------------------------------------------------------|
| **Compute**                          |                                                                                             |
| Azure Virtual Machines (VMs)         | Use **Availability Sets** or **Availability Zones** for resilience. For higher SLA → pair with **paired-region failover**. |
| Azure App Service                     | Use **App Service Environment (ASE)** or **Availability Zones** for ≥99.95%. For active-active, use **Front Door**. |
| Azure Kubernetes Service (AKS)       | Deploy node pools across **Availability Zones**. Use **multi-region clusters** if SLA >99.95%. |
| Azure Functions                       | Use **Premium Plan** with **zone redundancy** for higher SLA. Consider **multi-region deployment**. |
| Azure Container Instances / Apps      | Use **zone redundancy** where supported. For critical workloads, pair with **Front Door** or **Traffic Manager**. |
| Azure Service Fabric                  | Deploy across **multiple nodes and zones**. Ensure **backup and failover policies**. |
| **Storage**                           |                                                                                             |
| Azure Blob / File / Queue / Table Storage | Use **Zone-Redundant Storage (ZRS)** for intra-region resiliency; **Geo-Redundant (GRS / RA-GRS)** for cross-region DR. |
| Azure Disk Storage                    | Use **Premium SSD with ZRS**. For VM disks in critical apps, combine with VM **Availability Zones**. |
| Azure Data Lake Storage Gen2          | Use **RA-GRS** for mission-critical analytics workloads. |
| Azure NetApp Files                    | Deploy in **dual-zone** or **multi-zone redundancy** for high availability. |
| **Networking**                        |                                                                                             |
| Azure Virtual Network                 | Design with **hub-spoke topology**. Use **VPN/ExpressRoute redundancy**. |
| Azure Load Balancer                   | Use **Standard SKU** for zone-resilient L4 traffic balancing. |
| Azure Application Gateway (WAF)      | Deploy in **zonal configuration**. For global failover, pair with **Azure Front Door**. |
| Azure VPN Gateway                     | Use **active-active configuration** across zones for higher SLA. |
| Azure ExpressRoute                    | Use **dual circuits** in different physical paths for resiliency. |
| Azure Front Door                       | Global active-active by default. Recommended for **mission-critical web workloads**. |
| Azure Traffic Manager                  | DNS-based geo-routing. Suitable for **multi-region failover** (higher RTO vs Front Door). |
| Azure DNS                              | Use **zone redundancy** and multiple name servers across regions. |
| Azure Bastion                           | Deploy across **multiple zones**. Consider pairing with **VPN gateway** for backup access. |
| Azure Firewall                          | Use **HA deployment across availability zones**. |
| Azure DDoS Protection                   | Enabled by default on standard SKU. Monitor **attack metrics** and plan **regional failover**. |
| Azure Private Link                      | Use **multi-region endpoints** for critical workloads. |
| Azure Route Server                      | Deploy across zones for dynamic routing redundancy. |
| **Security & Identity**                 |                                                                                             |
| Azure Active Directory (AAD)           | Leverage **multi-tenant architecture**; enable **Azure AD Connect HA**. |
| Azure Key Vault                          | Use **Premium tier with zone redundancy**. Consider **geo-replication** for critical secrets. |
| Azure Security Center / Defender        | Use **multi-region deployment** for monitoring critical resources. |
| Azure Sentinel                           | Deploy **across multiple regions** for analytics continuity. |
| **Databases**                           |                                                                                             |
| Azure SQL Database                       | Use **Zone Redundant (ZRS)** for ≥99.95%. Use **Auto-failover groups** for geo-redundancy. |
| Azure SQL Managed Instance               | Same as Azure SQL DB; ensure **regional failover group** configured. |
| Azure SQL Hyperscale                     | Use **Auto-failover groups** and **zone redundancy**. |
| Azure Cosmos DB                          | Enable **multi-region writes** for 99.999% SLA. |
| Azure Database for MySQL / PostgreSQL / MariaDB | Deploy in **Zone Redundant Configuration**. Use **geo-replication** for cross-region DR. |
| Azure Synapse Analytics                  | Use **RA-GRS storage** for data; ensure **multi-region integration runtime** for failover. |
| Azure Cache for Redis                     | Use **Premium tier with geo-replication**. Deploy across **Availability Zones**. |
| **Integration & Messaging**              |                                                                                             |
| Azure Logic Apps                          | Deploy **across multiple regions** for critical workflows. |
| Azure Service Bus                          | Use **Premium tier with availability zones**. |
| Azure Event Grid                           | Enable **geo-distribution** for events. |
| Azure Event Hubs                           | Deploy **across zones** or **regions** for high-throughput ingestion. |
| Azure API Management                        | Deploy in **multi-region** for SLA >99.95%. |
| Azure IoT Hub                                | Use **multi-region disaster recovery** and **device failover**. |
| **Analytics & AI**                         |                                                                                             |
| Azure Machine Learning                       | Use **multi-zone or multi-region compute clusters** for critical model training. |
| Azure Cognitive Services                     | Deploy **regionally redundant endpoints** for SLA improvement. |
| Azure Databricks                              | Use **workspace in multiple regions** or **RA-GRS storage**. |
| Azure HDInsight                               | Use **multi-region clusters** for resilience. |
| Azure Data Factory                             | Use **integration runtime across multiple regions**. |
| Azure Stream Analytics                          | Use **redundant streaming units**; consider **multi-region job deployment**. |
| **Backup & Disaster Recovery**                |                                                                                             |
| Azure Backup                                    | Store backup in **RA-GRS** for cross-region DR. |
| Azure Site Recovery                             | Deploy **multi-region failover** for mission-critical workloads. |
| **Hybrid & Multicloud**                          |                                                                                             |
| Azure Arc                                       | Use **multiple connected regions** for HA. |
| Azure Stack HCI / Hub / Edge                     | Use **clustered HA nodes**; consider **Azure Site Recovery** integration. |
| Azure VMware Solution                           | Deploy **across multiple zones or regions** for critical workloads. |
| **Other / Misc**                                 |                                                                                             |
| Power BI Embedded                               | Use **multi-region capacity nodes** for high availability dashboards. |

---


```mermaid
flowchart TD
    A["Start: Identify Azure Service Used"] --> B["Gather Business SLA Requirement"]
    B --> C["Check Microsoft SLA for Service"]
    C --> D{"Does MS SLA Meet Business SLA?"}
    
    D -- Yes --> E["Document SLA Match ✅"]
    D -- No --> F["Identify SLA Gap ❌"]
    
    F --> G["Capture Business RPO & RTO Requirements"]
    G --> H{"Is RPO/RTO Achievable in Single Region?"}
    
    H -- Yes --> I["Mitigate with Azure Native Features: ZRS / Availability Zones"]
    H -- No --> J["Consider Multi-Region Deployment 🌍"]
    
    J --> K["Design with Geo-Redundancy: RA-GRS, Paired Regions, Traffic Manager, Front Door"]
    I --> L["Document Recommendation & Risk"]
    K --> L
    L --> M["End: Finalize Findings & Next Steps"]


```mermaid

