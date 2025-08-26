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

| Azure Service               | Finance | Operations | Sales & Marketing | HR & Internal IT | Notes |
|-----------------------------|---------|------------|------------------|-----------------|-------|
| Azure Virtual Machines      | ✔       | ✔          |                  |                 | Core compute workloads |
| Azure SQL Database          | ✔       |            | ✔                |                 | Financial & customer data |
| Azure Storage               | ✔       | ✔          | ✔                | ✔               | Blob/File/Queue/Table |
| Azure Kubernetes Service    |         | ✔          |                  |                 | Containerized apps |
| Azure App Service           | ✔       |            | ✔                |                 | Web apps |
| Azure Functions             |         | ✔          |                  |                 | Event-driven workloads |
| Azure VPN Gateway           | ✔       | ✔          |                  |                 | Connectivity |
| Azure Key Vault             | ✔       | ✔          | ✔                | ✔               | Secrets, keys, certs |
| Azure Monitor & Log Analytics | ✔     | ✔          | ✔                | ✔               | Observability |
| Azure Backup & Site Recovery | ✔      | ✔          |                  | ✔               | DR & backup |
| Azure Active Directory      | ✔       | ✔          | ✔                | ✔               | Identity & access |
| Azure Synapse Analytics     | ✔       |            | ✔                |                 | BI & analytics |
| Power BI Embedded           |         |            | ✔                |                 | Sales dashboards |
| Azure API Management        | ✔       | ✔          | ✔                |                 | Integration services |
| Azure Service Bus           | ✔       | ✔          |                  |                 | Messaging |
| Azure Application Gateway (WAF) | ✔   | ✔          | ✔                |                 | Web traffic management |
| Azure Front Door            | ✔       | ✔          | ✔                |                 | Global load balancing |
| *(continue full Azure catalog…)* |     |            |                  |                 | |

---

## 4. SLA Requirements from Business Units
Each BU defines its **Availability SLA**, **RPO**, and **RTO** expectations.  

#### Example – Finance BU
| Service          | Business SLA (%) | RPO Requirement | RTO Requirement | Criticality | Notes |
|------------------|------------------|-----------------|-----------------|-------------|-------|
| Azure SQL DB     | 99.99%           | 15 min          | 1 hr            | High        | Core financial data |
| Azure VMs        | 99.95%           | 1 hr            | 4 hrs           | High        | Core apps |
| Azure Storage    | 99.9%            | 30 min          | 2 hrs           | Medium      | Archive |

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


## 9. Decision Flow for SLA & Multi-Region Strategy
- **Key Gaps**: (placeholder)  
- **High Risk Services**: (placeholder)  
- **Multi-Region DR Candidates**: (placeholder)  
- **Final Recommendations**: (placeholder)  

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

