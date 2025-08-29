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
> Tick (`✔`) the services used in the organisation.  

| Azure Service                        | Used in Organisation | Notes |
|-------------------------------------|--------------------|-------|
| **Compute**                          |                    |       |
| Azure Virtual Machines               | ✔                  | Core compute workloads |
| Azure App Service                     | ☐                  | Web apps |
| Azure Kubernetes Service (AKS)       | ☐                  | Containerized apps |
| Azure Functions                       | ☐                  | Event-driven workloads |
| Azure Container Instances             | ☐                  | Short-lived containers |
| Azure Container Apps                  | ☐                  | Managed container apps |
| Azure Service Fabric                  | ☐                  | Microservices platform |
| **Storage**                           |                    |       |
| Azure Blob Storage                     | ✔                  | Object storage |
| Azure Disk Storage                     | ✔                  | Persistent disks |
| Azure File Storage                     | ✔                  | SMB file shares |
| Azure Queue Storage                    | ☐                  | Messaging queue |
| Azure Table Storage                    | ☐                  | NoSQL key-value store |
| Azure Data Lake Storage Gen2           | ☐                  | Big data analytics storage |
| Azure NetApp Files                     | ☐                  | Enterprise file storage |
| **Networking**                         |                    |       |
| Azure Virtual Network                  | ☐                  | Network backbone |
| Azure Load Balancer                     | ☐                  | L4 traffic balancing |
| Azure Application Gateway (WAF)       | ☐                  | L7 traffic & security |
| Azure VPN Gateway                      | ☐                  | Connectivity |
| Azure ExpressRoute                     | ☐                  | Private connectivity |
| Azure Front Door                        | ☐                  | Global load balancing |
| Azure Traffic Manager                  | ☐                  | DNS-based routing |
| Azure DNS                              | ☐                  | Domain management |
| Azure Bastion                           | ☐                  | Secure RDP/SSH |
| Azure Firewall                          | ☐                  | Network security |
| Azure DDoS Protection                   | ☐                  | DDoS mitigation |
| Azure Private Link                      | ☐                  | Private endpoint connectivity |
| Azure Route Server                      | ☐                  | Dynamic routing |
| **Security & Identity**                 |                    |       |
| Azure Active Directory (AAD)           | ☐                  | Identity & access |
| Azure Key Vault                          | ☐                  | Secrets, keys, certificates |
| Azure Security Center / Defender        | ☐                  | Threat detection |
| Azure Sentinel                           | ☐                  | SIEM & analytics |
| **Databases**                           |                    |       |
| Azure SQL Database                       | ✔                  | Relational database |
| Azure Cosmos DB                          | ☐                  | Multi-model NoSQL DB |
| Azure Synapse Analytics                  | ☐                  | Data warehouse & BI |
| Azure Database for MySQL                 | ☐                  | Managed MySQL |
| Azure Database for PostgreSQL            | ☐                  | Managed PostgreSQL |
| Azure Database for MariaDB               | ☐                  | Managed MariaDB |
| Azure Cache for Redis                     | ☐                  | In-memory caching |
| **Integration & Messaging**              |                    |       |
| Azure Logic Apps                          | ☐                  | Workflow automation |
| Azure Service Bus                          | ☐                  | Messaging |
| Azure Event Grid                           | ☐                  | Event routing |
| Azure Event Hubs                           | ☐                  | Telemetry ingestion |
| Azure API Management                        | ☐                  | API gateway |
| Azure IoT Hub                                | ☐                  | IoT device management |
| **Analytics & AI**                              |                    |       |
| Azure Machine Learning                           | ☐                  | Model training & deployment |
| Azure Cognitive Services                          | ☐                  | Prebuilt AI APIs |
| Azure Databricks                                  | ☐                  | Big data analytics & AI |
| **Backup & DR**                                   |                    |       |
| Azure Backup                                       | ☐                  | Backup & restore |
| Azure Site Recovery                                | ☐                  | Multi-region DR |
| **DevOps & Monitoring**                             |                    |       |
| Azure DevOps                                      | ☐                  | CI/CD & repos |
| Azure Monitor / Application Insights / Log Analytics | ☐               | Observability |



---

## 4. SLA Requirements from Business Units
Each BU defines its **Availability SLA**, **RPO**, and **RTO** expectations.  

#### Example – Finance BU
# Azure Services SLA / RPO / RTO Inventory
> Track SLA, RPO, RTO, and criticality for each Azure service.

| Azure Service                         | Business SLA (%) | RPO Requirement | RTO Requirement | Criticality | Notes |
|---------------------------------------|-----------------|----------------|----------------|-------------|-------|
| **Compute**                           |                 |                |                |             |       |
| Azure Virtual Machines                | 99.95%          | 1 hr           | 4 hrs          | High        | Core business applications |
| Azure App Service                     | 99.95%          | 30 min         | 1 hr           | High        | Web apps & APIs |
| Azure Kubernetes Service (AKS)       | 99.95%          | 15 min         | 1 hr           | High        | Containerized apps |
| Azure Functions                       | 99.95%          | 15 min         | 1 hr           | Medium      | Event-driven workloads |
| Azure Container Instances             | 99.95%          | 15 min         | 1 hr           | Medium      | Short-lived containers |
| Azure Container Apps                  | 99.95%          | 15 min         | 1 hr           | Medium      | Managed container apps |
| Azure Service Fabric                  | 99.95%          | 15 min         | 1 hr           | Medium      | Microservices platform |
| **Storage**                           |                 |                |                |             |       |
| Azure Blob Storage                     | 99.9%           | 30 min         | 2 hrs          | Medium      | Object storage |
| Azure Disk Storage                     | 99.9%           | 30 min         | 2 hrs          | Medium      | Persistent disks |
| Azure File Storage                     | 99.9%           | 30 min         | 2 hrs          | Medium      | SMB file shares |
| Azure Queue Storage                    | 99.9%           | 30 min         | 2 hrs          | Medium      | Messaging queue |
| Azure Table Storage                    | 99.9%           | 30 min         | 2 hrs          | Medium      | NoSQL key-value store |
| Azure Data Lake Storage Gen2           | 99.9%           | 15 min         | 1 hr           | High        | Big data analytics storage |
| Azure NetApp Files                     | 99.99%          | 15 min         | 30 min         | High        | Enterprise file storage |
| **Networking**                         |                 |                |                |             |       |
| Azure Virtual Network                  | 99.9%           | Not applicable | Not applicable | Medium      | Network backbone |
| Azure Load Balancer                     | 99.99%          | Not applicable | Not applicable | High        | L4 traffic balancing |
| Azure Application Gateway (WAF)       | 99.95%          | 15 min         | 1 hr           | High        | Web traffic management |
| Azure VPN Gateway                      | 99.9%           | 15 min         | 1 hr           | High        | Connectivity |
| Azure ExpressRoute                     | 99.95%          | 15 min         | 30 min         | High        | Private connectivity |
| Azure Front Door                        | 99.99%          | 15 min         | 30 min         | High        | Global load balancing |
| Azure Traffic Manager                  | 99.99%          | 15 min         | 30 min         | High        | DNS-based routing |
| Azure DNS                              | 99.99%          | Not applicable | Not applicable | High        | Domain management |
| Azure Bastion                           | 99.9%           | Not applicable | Not applicable | Medium      | Secure RDP/SSH |
| Azure Firewall                          | 99.95%          | Not applicable | Not applicable | High        | Network security |
| Azure DDoS Protection                   | 99.9%           | Not applicable | Not applicable | High        | DDoS mitigation |
| Azure Private Link                      | 99.95%          | Not applicable | Not applicable | Medium      | Private endpoint connectivity |
| Azure Route Server                      | 99.95%          | Not applicable | Not applicable | Medium      | Dynamic routing |
| **Security & Identity**                 |                 |                |                |             |       |
| Azure Active Directory (AAD)           | 99.9%           | Not applicable | Not applicable | High        | Identity & access |
| Azure Key Vault                          | 99.9%           | 15 min         | 1 hr           | High        | Secrets, keys, certificates |
| Azure Security Center / Defender        | 99.9%           | Not applicable | Not applicable | High        | Threat detection |
| Azure Sentinel                           | 99.95%          | Not applicable | Not applicable | High        | SIEM & analytics |
| **Databases**                           |                 |                |                |             |       |
| Azure SQL Database                       | 99.99%          | 5 sec          | 30 sec         | High        | Core financial & transactional data |
| Azure Cosmos DB                          | 99.999%         | 5 sec          | 30 sec         | Critical    | Globally distributed DB |
| Azure Synapse Analytics                  | 99.9%           | 15 min         | 1 hr           | High        | Data warehouse & BI |
| Azure Database for MySQL                 | 99.99%          | 15 min         | 1 hr           | High        | Managed MySQL |
| Azure Database for PostgreSQL            | 99.99%          | 15 min         | 1 hr           | High        | Managed PostgreSQL |
| Azure Database for MariaDB               | 99.99%          | 15 min         | 1 hr           | High        | Managed MariaDB |
| Azure Cache for Redis                     | 99.9%           | 5 min          | 30 min         | High        | In-memory caching |
| **Integration & Messaging**              |                 |                |                |             |       |
| Azure Logic Apps                          | 99.95%          | 15 min         | 1 hr           | Medium      | Workflow automation |
| Azure Service Bus                          | 99.95%          | 5 min          | 30 min         | High        | Messaging |
| Azure Event Grid                           | 99.99%          | 1 min          | 15 min         | High        | Event routing |
| Azure Event Hubs                           | 99.95%          | 1 min          | 30 min         | High        | Telemetry ingestion |
| Azure API Management                        | 99.95%          | 15 min         | 1 hr           | High        | API gateway |
| Azure IoT Hub                                | 99.95%          | 1 min          | 15 min         | High        | IoT device management |
| **Backup & DR**                           |                 |                |                |             |       |
| Azure Backup                               | 99.9%           | 30 min         | 2 hr           | Medium      | Backup & restore |
| Azure Site Recovery                        | 99.9%           | 30 min         | 1 hr           | High        | Multi-region DR |
| **DevOps & Monitoring**                     |                 |                |                |             |       |
| Azure DevOps                                | 99.9%           | 30 min         | 2 hr           | Medium      | CI/CD & repos |
| Azure Monitor / Application Insights / Log Analytics | 99.95% | 15 min | 1 hr | High | Observability |


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
| Service        | Business SLA | Microsoft SLA | Gap      | Risk    | Notes |
|----------------|--------------|---------------|----------|---------|-------|
| Azure SQL DB   | 99.99%       | 99.99%        | None     | Low     | Meets requirement |
| Azure VMs      | 99.99%       | 99.95%        | -0.04%   | Medium  | Needs AZ deployment |
| Azure Storage  | 99.95%       | 99.9%         | -0.05%   | Medium  | Enable GRS/RA-GRS |
| App Gateway    | 99.99%       | 99.95%        | -0.04%   | Medium  | Ensure ≥2 instances |

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

| Azure Service          | SLA Strategy Recommendation                                                                 |
|-------------------------|---------------------------------------------------------------------------------------------|
| **App Service / API**   | Use **App Service Environment (ASE)** or **Availability Zones** for ≥99.95%. For active-active, use **Front Door**. |
| **App Gateway**         | Deploy in **zonal configuration**. For higher SLA → pair with **Azure Front Door** for global failover. |
| **Azure Front Door**    | Global active-active by default. Recommended for **mission-critical web workloads**.         |
| **Traffic Manager**     | DNS-based geo-routing. Suitable for **multi-region failover** (higher RTO vs Front Door).   |
| **Azure SQL**           | Zone redundant (ZRS) for ≥99.95%. Use **Auto-failover groups** for geo-redundancy.          |
| **Cosmos DB**           | Enable **multi-region writes** for 99.999% SLA.                                             |
| **Azure Storage**       | Use **ZRS** for intra-region, **RA-GRS** for cross-region DR.                               |
| **Key Vault**           | Use **Premium tier with zone redundancy**.                                                  |
| **AKS**                 | Deploy node pools across **Availability Zones**. Use **multi-region clusters** if SLA >99.95%. |
| **VMs**                 | Use **Availability Sets** or **Zones** for resilience. For higher SLA → use paired region failover. |

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

