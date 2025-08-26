```mermaid
flowchart TD
    A[Start: Identify Azure Service Used] --> B[Gather Business SLA Requirement]
    B --> C[Check Microsoft SLA for Service]
    C --> D{Does MS SLA Meet Business SLA?}
    
    D -- Yes --> E[Document SLA Match ✅]
    D -- No --> F[Identify SLA Gap ❌]
    
    F --> G[Capture Business RPO & RTO Requirements]
    G --> H{Is RPO/RTO Achievable in Single Region?}
    
    H -- Yes --> I[Mitigate with Azure Native Features (ZRS, Availability Zones)]
    H -- No --> J[Consider Multi-Region Deployment 🌍]
    
    J --> K[Design with Geo-Redundancy (GZRS, Paired Regions, Traffic Manager, Front Door)]
    I --> L[Document Recommendation & Risk]
    K --> L[Document Recommendation & Risk]
    
    L --> M[End: Finalize Findings & Next Steps]

