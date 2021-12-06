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
    * SBI : Yes
    * UNKNOWN: No

* Services
    * Communication
    * Event Exposure
    * Mobile Terminated
    * Location

* Producer Service Operations
    * Communication
        * UE Context Transfer
        * Registration Status Update
        * N1N2 Message Transfer (UE Specific)
        * N1N2 Transfer Failure Notification (UE Specific)
        * N1N2 Message Subscribe (UE Specific)
        * N1N2 Message Unsubscribe (UE Specific)
        * N1 Message Notify (UE Specific)
        * N2 Info Notify (UE Specific)
        * Non Ue N2 Message Transfer
        * Non Ue N2 Info Subscribe
        * Non Ue N2 Info Unsubscribe
        * N2 Info Notify
        * EBI Assignment
        * Create UE Context
        * Release UE Context
        * Relocate UE Context
        * Cancel Relocate UE Context
        * AMF Status Change Subscribe
        * AMF Status Change Unsubscribe
        * AMF Status Change Notify
    * Event Exposure
        * Subscribe
        * Unsubscribe
        * Notify
    * Mobile Terminated
        * Enable UE Reachability
        * Provide Domain Selection Info
    * Location
        * Provide Positioning Info
        * Event Notify
        * Provide Location Info
        * Cancel Location

* Consumer Service Operations


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
* Producer Service Operations
* Consumer Service Operations


UDR Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No
* Services
* Producer Service Operations
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
* Producer Service Operations
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
