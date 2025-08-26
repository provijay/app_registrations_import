## 📌 SLA Strategy by Azure Service

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