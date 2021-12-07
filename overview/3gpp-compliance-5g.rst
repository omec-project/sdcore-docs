5G - 3GPP Release Compliance
============================

SMF Compliance
--------------
* Interfaces
    * SBI : Yes
    * PFCP: Yes

* Services
    * PDU Session Management
    * Event Exposure
    * NIDD

* Producer Service Operations
    * PDU Session Management
        * SM contexts collection
            * Create SM Context : Yes
        * Individual SM context
            * Retrieve SM Context : No
            * Update SM Context : Yes
            * Release SM Context : Yes
            * Notify SM Context Status : Yes
            * Send MO Data : No
        * PDU sessions collection
            * Create : No
        * Individual PDU session
            * Update : No
            * Release : No
            * Notify Status : No
            * Retrieve : No
            * Send MO Data: No
            * Transfer MO Data : No
            * Transfer MT Data : No
    * Event Exposure
        * No
    * NIDD
        * No



* Consumer Service Operations
    * PCF
        * SM Policy Association Create : Yes
        * SM Policy Association Update : No
        * SM Policy Association Termination : Yes
        * SM Policy Association Update Notification : No
        * SM Policy Association Termination Notification : No
    * AMF
        * SM Context Status Notification : Yes
    * UDM
        * Session Management Subscription Data Retrieval : Yes
        * SMF UE Registration/Deregistration : No
    * NRF
        *  NF Registration : Yes
        *  NF De-Registration : Yes



AMF Compliance
--------------
* Interfaces
    * N11, N15, N8, N12, N22, N2, N1 : Yes
    * N14, N58 : No

* Services
    * Communication
    * Event Exposure
    * Mobile Terminated
    * Location

* Producer Service Operations
    * Communication
        * UE Context Transfer : Yes
        * Registration Status Update : Yes
        * N1N2 Message Transfer (UE Specific) : Yes
        * N1N2 Transfer Failure Notification (UE Specific) : Yes
        * N1N2 Message Subscribe (UE Specific) : Yes
        * N1N2 Message Unsubscribe (UE Specific) : Yes
        * N1 Message Notify (UE Specific) : Yes
        * N2 Info Notify (UE Specific) : Yes
        * Non Ue N2 Message Transfer : No
        * Non Ue N2 Info Subscribe : No
        * Non Ue N2 Info Unsubscribe : No
        * N2 Info Notify : No
        * EBI Assignment : Yes
        * Create UE Context : Yes
        * Release UE Context : Yes
        * Relocate UE Context : No
        * Cancel Relocate UE Context : No
        * AMF Status Change Subscribe : Yes
        * AMF Status Change Unsubscribe : Yes
        * AMF Status Change Notify : Yes
    * Event Exposure
        * Subscribe : Yes
        * Unsubscribe : Yes
        * Notify : Yes
    * Mobile Terminated
        * Enable UE Reachability : No
        * Provide Domain Selection Info : Yes
    * Location
        * Provide Positioning Info : No
        * Event Notify : No
        * Provide Location Info : Yes
        * Cancel Location : No

* Consumer Service Operations
    * PCF
        * AM Policy Control Create : Yes
        * AM Policy Control Delete : Yes
        * AM Policy Control Update : Yes
    * NRF
        *  NF Registration : Yes
        *  NF De-Registration : Yes
        *  NF Selection : Yes
    * SMF
        * Create SM Context : Yes
        * Update SM Context : Yes
        * Release SM Context : Yes
    * AUSF
        * UE Authentication Auth Request : Yes
        * 5G AKA Confirm Request : Yes
        * EAP Auth Confirm Request : Yes
    * UDM
        * UE CM Registration : Yes
        * SDM Subscribe : Yes
        * Get UE Context In SMF Data : Yes
        * Get SMF Selection Data : Yes
        * Get AM Data : Yes
        * Get SliceSelection Data : Yes
    * NSSF
        * Selection Data For Registration : Yes


NRF Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * NF Management
    * NF Discovery
    * Access Token
    * Bootstrapping

* Producer Service Operations
    * NF Management
        * NF Register : Yes
        * NF Update
        * NF Deregister : Yes
        * NF Status Subscribe
        * NF Status Notify
        * NF Status Unsubscribe
        * NF List Retrieval
        * NF Profile Retrieval
    * NF Discovery
        * NF Discover : Yes
    * Access Token
        * Access Token Request : No
    * Bootstrapping
        * Bootstrapping Get : No

* Consumer Service Operations

AUSF Compliance
---------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * UE Authentication
    * SoR Protection
    * UPU Protection

* Producer Service Operations
    * UE Authentication
        * Authenticate
        * Deregister
    * SoR Protection
        * Protect
    * UPU Protection
        * Protect

* Consumer Service Operations


UDR Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No
* Services
    * Data Repository
    * Group IDmap

* Producer Service Operations
    * Data Repository
        * Query
        * Create
        * Delete
        * Update
        * Subscribe
        * Unsubscribe
        * Notify
    * Group IDmap
        * Query

* Consumer Service Operations


UDM Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * Subscriber Data Management
    * UE Context Management
    * UE Authentication
    * Event Exposure
    * Parameter Provision
    * NIDD Authorization
    * MT

* Producer Service Operations
    * Subscriber Data Management
        * Get
        * Subscribe
        * ModifySubscription
        * Unsubscribe
        * Notification
        * Info
    * UE Context Management
        * Registration
        * DeregistrationNotification
        * Deregistration
        * Get
        * Update
        * P-CSCF Restoration Notification
        * P-CSCF Restoration Trigger
        * AMF Deregistration
        * PEI Update
    * UE Authentication
        * Get
        * GetHssAv
        * Result Confirmation
    * Event Exposure
        * Subscribe
        * Unsubscribe
        * Notify
        * Modify Subscription
    * Parameter Provision
        * Update
        * Create
        * Delete
        * Get
    * NIDD Authorization
        * Get
        * Notification
    * MT
        * Provide Ue Info
        * Provide Location Info

* Consumer Service Operations


NSSF Compliance
---------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * NS Selection
    * NSSAI Availability

* Producer Service Operations
    * NS Selection
        * Get
    * NSSAI Availability
        * Update
        * Subscribe
        * Unsubscribe
        * Notify
        * Delete
        * Options

* Consumer Service Operations


PCF Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * AM Policy Control : Yes
    * SM Policy Control : Yes

* Producer Service Operations
    * SM Policy
        * SM Policy Control Create : Yes
        * SM Policy Control Update : No
        * SM Policy Control Update Notify : No
        * SM Policy Control Delete : Yes
    * AM Policy
        *  AM Policy Control Create : Yes
        *  AM Policy Control Update : No
        *  AM Policy Control Update Notify : No
        *  AM Policy Control Delete : Yes

* Consumer Service Operations
    * TODO- UDR


SD Core High Level Features supported
-------------------------------------

High Level Features Not supported
---------------------------------
* URLLC
* Location Based Services
