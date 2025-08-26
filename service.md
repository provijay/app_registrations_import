1. Introduction

This document provides an overview of Azure services in use across business units, their SLA requirements, comparison with Microsoft’s published SLAs, and identification of gaps and opportunities. It also includes a decision framework for Multi-Region Disaster Recovery (DR) strategy.

2. Business Units Covered

BU1 – Finance

BU2 – Operations

BU3 – Sales & Marketing

BU4 – HR & Internal IT

(Add more as required)

3. Azure Services Inventory

Tick (✔) which services are used by each business unit.

Azure Service	Finance	Operations	Sales & Marketing	HR & Internal IT	Notes
Azure Virtual Machines	✔	✔			Core compute workloads
Azure SQL Database	✔		✔		Customer & finance data
Azure Storage	✔	✔	✔	✔	Blob/File/Queue/Table
Azure Kubernetes Service (AKS)		✔			Containerized apps
Azure App Service	✔		✔		Web apps
Azure Functions		✔			Event-driven workloads
Azure VPN Gateway	✔	✔			Connectivity
Azure Key Vault	✔	✔	✔	✔	Secrets, keys, certs
Azure Monitor & Log Analytics	✔	✔	✔	✔	Observability
Azure Backup & Site Recovery	✔	✔		✔	DR & backup
Azure Active Directory	✔	✔	✔	✔	Identity & access
Azure Synapse Analytics	✔		✔		BI & analytics
Power BI Embedded			✔		Sales dashboards
Azure API Management	✔	✔	✔		Integration services
Azure Service Bus	✔	✔			Messaging
(continue full Azure catalog…)					
4. SLA Requirements from Business Units

Each BU defines its Availability SLA, RPO, and RTO expectations.

Example Template
Finance BU
Service	Business SLA (Availability %)	RPO Requirement	RTO Requirement	Criticality	Notes
Azure SQL Database	99.99%	15 min	1 hr	High	Supports financial reporting
Azure VMs	99.95%	1 hr	4 hrs	High	Core apps
Azure Storage	99.9%	30 min	2 hrs	Medium	Archive storage

(Repeat for each BU)

5. Microsoft SLA Reference (Fine Print)

For each Azure service, include official SLA commitments, conditions, and caveats.

Example – Azure SQL Database

SLA: 99.99% uptime for single database or elastic pool in Premium/Business Critical tiers.

Conditions: Requires at least one replica and zone-redundant configuration.

Exclusions: Planned maintenance, preview features, customer misconfiguration.

Multi-region requirement: Geo-replication or auto-failover groups required for DR.

(Repeat per service used by BUs, e.g., VMs, Storage, AKS, App Service, etc.)

6. Gap Analysis

Compare Business SLA vs. Microsoft SLA to identify gaps.

Service	Business SLA Requirement	Microsoft SLA	Gap Identified	Risk	Notes
Azure SQL DB	99.99%	99.99%	None	Low	Meets requirement
Azure VMs	99.99%	99.95%	-0.04%	Medium	Requires VM scale sets across AZs
Azure Storage	99.95%	99.9%	-0.05%	Medium	Need GRS or ZRS for DR
7. Opportunities for Multi-Region DR

Identify which services must be multi-region (business SLA > MS SLA).

Highlight RPO/RTO gaps where Azure native DR solutions can help.

Examples:

Azure SQL DB: Implement Auto-failover groups for cross-region DR.

Azure VMs: Use Azure Site Recovery (ASR) to replicate to paired region.

Azure Storage: Enable Geo-redundant storage (GRS) for resilience.

8. Decision Framework for Multi-Region DR

Use the following framework to decide if Multi-Region DR is required:

Criteria	Question	Action
Business SLA vs. MS SLA	Does the business SLA exceed Microsoft SLA?	If Yes → Consider DR solution
RPO/RTO	Do RPO/RTO requirements mandate faster recovery than native SLA?	If Yes → Design DR strategy
Criticality	Is the service mission critical (financial, customer-facing, compliance)?	If Yes → Multi-region recommended
Cost vs. Risk	Is cost of multi-region justified by business impact?	If Yes → Proceed; if No → Accept risk