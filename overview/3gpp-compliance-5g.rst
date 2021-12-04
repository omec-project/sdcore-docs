5G - 3GPP Release Compliance
============================

SMF Compliance
--------------
* Interfaces
    * SBI : Yes
    * PFCP: Yes

* Services
    * PDU Session Management : Yes
    * Event Exposure : No
    * NIDD : No

* Producer Service Operations
    * SM contexts collection
        * Create SM Context : Yes
    * Individual SM context
        * Retrieve SM Context : No
        * Update SM Context : Yes
        * Release SM Context : Yes
        * Notify SM Context Status : Yes
        * Send MO Data : No
    * PDU sessions collection
        No
    * Individual PDU session
        No

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
    * PDU Session Management
* Producer Service Operations
* Consumer Service Operations


NRF Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
    * Network Function Registration/Deregistration
* Functions supported
* Service/Functions not supported
    * Keepalive


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
* Producer Service Operations
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
