# 📘 Azure Network Architecture Transformation – Hub-and-Spoke to Virtual WAN + ExpressRoute  

## 1. Executive Summary  
Our current Azure networking setup uses a **single hub-and-spoke model** with ~15–20 VNets per spoke, connected to on-premises through **site-to-site (S2S) VPN**. While this architecture has served us well, it introduces operational complexity, scaling limitations, and higher costs when expanded across multiple regions.  

The proposed target state is to adopt **Azure Virtual WAN (VWAN) with Secure Hub**, integrated with **ExpressRoute (ER)** as the primary on-premises connectivity and **VPN as failover**. This will streamline management, improve resiliency, and align with future multi-region disaster recovery needs, while keeping all workloads **within Europe**.  

This document presents the **baseline vs. target architecture**, a **TOGAF-aligned gap analysis**, the **business case for change**, and a **migration approach**.  

---

## 2. Baseline Architecture (Current State)  

The **hub-and-spoke model** has been our standard approach. It consists of:  
- A **single central hub VNet** that hosts Palo Alto Firewall and Azure Firewall.  
- Around **15–20 spoke VNets**, each hosting different applications and workloads.  
- Connectivity to on-premises through **site-to-site VPN**.  

**Operational observations:**  
- VNet peering between hub and each spoke is **manual**, which creates administrative overhead.  
- Centralized inspection through firewalls adds complexity and latency.  
- Scaling becomes challenging as the number of VNets grows.  
- VPN gateways are bandwidth-limited and do not provide **SLA-backed guarantees**.  

**Figure 1: Current Hub-and-Spoke Architecture**  
![Hub and Spoke Model Reference](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png)  

---

## 3. Target Architecture (Future State)  

The **target state** architecture simplifies and modernizes our network using **Azure Virtual WAN (VWAN)** with **Secure Hub**:  
- **VWAN Hub**: A Microsoft-managed hub that automates VNet connections.  
- **ExpressRoute (ER)**: Provides **private, SLA-backed connectivity** between on-premises and Azure (Europe region).  
- **S2S VPN**: Retained as **failover** for resiliency.  
- **Security**: Azure Firewall Premium inside VWAN Secure Hub for inspection, with Palo Alto still possible for advanced use cases.  

**Operational improvements:**  
- VNets connect directly to VWAN hub, removing the need for manual peering.  
- Centralized firewall management via Azure Firewall Manager.  
- Simplified onboarding of new VNets or branch locations.  
- Architecture is **future-ready** for multi-region DR in Europe.  

**Figure 2: Target Virtual WAN + ExpressRoute Architecture**  
![Azure Virtual WAN Reference](https://learn.microsoft.com/en-us/azure/virtual-wan/media/secured-hub.png)  

---

## 4. Visual Comparison – Current vs Target  

This comparison illustrates how VWAN reduces complexity while improving performance.  

| Current Hub-and-Spoke | Target Virtual WAN + ER |
|-------------------------|--------------------------|
| ![Hub and Spoke](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png) | ![Virtual WAN](https://learn.microsoft.com/en-us/azure/virtual-wan/media/secured-hub.png) |

**Key Takeaway:**  
- Left (Hub-and-Spoke): Many manual connections, heavy firewall dependency, VPN bottleneck.  
- Right (VWAN + ER): Centralized, automated, high-performance, resilient design.  

---

## 5. Gap Analysis (TOGAF B-to-T)  

This section maps the **Baseline (B)** to the **Target (T)** and highlights the gaps.  

| Dimension              | Current (Baseline)                  | Target (VWAN + ER)                          | Gap / Change Needed |
|------------------------|--------------------------------------|---------------------------------------------|----------------------|
| **Connectivity**       | VPN-based, bandwidth-limited         | ER-based, high bandwidth, SLA-backed         | Provision ER, configure VPN failover |
| **Topology**           | Hub-and-Spoke, manual peering        | VWAN, automated VNet connection              | Migrate VNets into VWAN hub |
| **Security**           | Palo Alto + Azure Firewall in hub    | VWAN Secure Hub (Firewall Premium) + optional Palo Alto | Redesign security policies |
| **Resiliency**         | Single VPN tunnel per hub            | ER + VPN failover (resilient)                | Configure dual paths |
| **Operations**         | Complex, manual, high overhead       | Centralized policy, simplified management    | Training + policy migration |
| **Scalability**        | Limited as VNets grow                | Elastic scaling, multi-region ready          | Gradual migration of spokes |
| **Cost**               | Multiple appliances, peering charges | VWAN economies of scale with ER              | New cost model (OPEX-heavy) |

---

## 6. Opportunities & Benefits  

### Business Benefits  
- **Performance & Reliability**: ExpressRoute ensures high bandwidth and low latency with SLA guarantees.  
- **Cost Optimization**: VWAN reduces dependency on manual peering and third-party firewalls, cutting long-term costs.  
- **Future-Readiness**: Easily expand into multi-region disaster recovery scenarios within Europe.  
- **Operational Efficiency**: Centralized connectivity management reduces manual effort and errors.  
- **Security Posture**: VWAN Secure Hub enforces standardized policies across VNets.  

### Technical Benefits  
- Automated VNet onboarding (no manual peering).  
- Hybrid connectivity resiliency (ER primary, VPN backup).  
- Consistent firewall policies across all workloads.  
- Easier monitoring through Azure-native tools.  

---

## 7. Risks & Constraints  

| Risk / Constraint                          | Mitigation |
|--------------------------------------------|------------|
| **Migration Downtime**: Reconnecting VNets may cause brief outages. | Phased migration, test before cutover. |
| **Firewall Redesign**: Moving policies from Palo Alto to VWAN. | Hybrid model during transition, pilot test policies. |
| **Cost Shift**: Upfront ER/VWAN costs may appear higher. | Long-term OPEX savings justify investment. |
| **Skill Gap**: Teams may lack VWAN knowledge. | Training, updated runbooks, KT sessions. |
| **Europe-only focus**: Expansion outside Europe may require adjustments. | VWAN supports global scaling if needed. |

---

## 8. Migration Approach  

A structured, phased migration will minimize disruption.  

**Step 1: Preparation**  
- Design VWAN hub architecture for Europe.  
- Provision ExpressRoute and connect to VWAN.  
- Set up backup VPN tunnels.  

**Step 2: Pilot**  
- Connect 2–3 VNets to VWAN.  
- Test connectivity, routing, and firewall rules.  

**Step 3: Gradual Migration**  
- Move remaining VNets in waves (5–6 at a time).  
- Run Palo Alto + VWAN Secure Hub in parallel.  
- Validate workloads before decommissioning old hub.  

**Step 4: Optimization**  
- Centralize firewall policies in VWAN Secure Hub.  
- Monitor cost and performance.  
- Fully retire hub-and-spoke once stable.  

---

## 9. Cost & Operational Considerations  

### 9.1 Cost Comparison (Indicative – insert estimates later)  

| Cost Category           | Current Hub-and-Spoke (Baseline) | Target VWAN + ER (Future) | Notes / Explanation |
|--------------------------|-----------------------------------|----------------------------|----------------------|
| **Connectivity**        | VPN Gateway (~1.25 Gbps max), peering charges per VNet | ExpressRoute (10–20 Gbps scalable), VWAN Hub connection | ER provides predictable billing, higher throughput |
| **Firewalling**         | Palo Alto licenses + Azure Firewall (per hub) | Azure Firewall Premium in VWAN Hub (centralized), optional Palo Alto | VWAN may reduce Palo Alto footprint |
| **VNet Peering**        | Peering costs between each spoke and hub (~15–20 VNets) | Automated VWAN connections (included in VWAN costs) | Peering costs eliminated |
| **Operational Effort**  | High (manual peering, complex rules, troubleshooting) | Lower (centralized management in VWAN) | OPEX savings on admin & ops |
| **Scalability Costs**   | Expensive (each new VNet requires setup + peering) | Marginal (new VNet auto-attaches to VWAN hub) | Faster onboarding |
| **DR / Multi-region**   | Complex, duplicate hubs/firewalls in each region | Simplified, VWAN supports multi-hub in EU | Future-proof design |

### 9.2 TCO Projection (3-Year Horizon, Indicative)  

| Cost Type        | Year 1 (Setup + Run) | Year 2 (Run) | Year 3 (Run) | 3-Year Total | Notes / Explanation |
|------------------|----------------------|--------------|--------------|--------------|----------------------|
| **CapEx**        | High (ER setup, VWAN provisioning, migration effort) | Low | Low | Moderate | Initial setup costs front-loaded |
| **OpEx – Connectivity** | Medium (VPN + ER running in parallel) | Medium-Low (ER stabilized) | Medium-Low | Medium | VPN cost reduces after migration |
| **OpEx – Firewalling** | High (Palo Alto + Azure Firewall both active) | Medium (gradual Palo Alto reduction) | Medium-Low (mostly VWAN Firewall Premium) | Medium | Cost reduction as Palo Alto footprint reduces |
| **OpEx – VNet Peering** | Medium (legacy peering until migration complete) | Low (VWAN auto-handling) | Low | Low | Peering costs eliminated |
| **OpEx – Operations/Admin** | Medium-High (dual ops during migration) | Medium (VWAN learning curve) | Low (optimized ops) | Medium-Low | Strong efficiency gains in long run |
| **Total (Indicative)** | High | Medium | Medium-Low | Lower than baseline | Long-term predictable OPEX model |

**Key Financial Insight:**  
- **Year 1**: Costs peak due to ER provisioning, VWAN setup, and dual-running firewalls.  
- **Year 2**: Costs normalize as Palo Alto and peering charges reduce.  
- **Year 3**: Lowest run rate – only ER + VWAN Secure Hub remain, with reduced admin effort.  
- **Result**: Lower 3-year TCO vs. hub-and-spoke, despite Year 1 spike.  

### 9.3 Operational Benefits  
- Reduced troubleshooting effort (simpler topology).  
- Standardized firewall and routing rules.  
- Faster VNet onboarding (minutes instead of days).  
- Improved monitoring through Azure Monitor and VWAN Insights.  

---

## 10. Management Talking Points  

Use these in board or steering committee presentations:  

- **Strategic Alignment**: Supports Europe-only cloud-first strategy with DR readiness.  
- **Cost Efficiency**: Less complexity, fewer firewalls, predictable OPEX.  
- **Performance & Reliability**: ExpressRoute provides guaranteed, private connectivity.  
- **Operational Simplicity**: Easier to manage, faster to scale.  
- **Security Posture**: Stronger with VWAN Secure Hub, integrates with Palo Alto if needed.  
- **Resiliency**: ER as primary + VPN backup ensures business continuity.  
- **Future-Ready**: Architecture scales easily if business expands.  

---

## 11. Conclusion / Recommendation  

Moving from **Hub-and-Spoke + VPN** to **VWAN + ExpressRoute** provides:  
- Lower complexity  
- Higher reliability  
- Stronger security  
- Better cost management  

**Recommendation**: Proceed with a **phased migration**, starting with a **pilot**. Validate cost and performance, then expand to all VNets. Keep VPN as failover to maximize resilience.  
