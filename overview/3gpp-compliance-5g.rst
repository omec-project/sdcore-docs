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

* Resources/Methods
    * SM contexts collection
        * create(POST) : Yes
    * Individual SM context
        * retrieve(POST) : No
        * modify(POST) : Yes
        * release(POST) : Yes
        * send-mo-data(POST) : No
    * PDU sessions collection
        No
    * Individual PDU session
        No

* NF Functions
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
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
    * PDU Session Management
* Functions supported
* Service/Functions not supported
    * PCF Notify


NRF Compliance
--------------
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
    * Network Function Registration/Deregistration
* Functions supported
* Service/Functions not supported
    * Keepalive


AUSF Compliance
---------------
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
* Functions supported
* Service/Functions not supported


UDR Compliance
--------------
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
* Functions supported
* Service/Functions not supported


UDM Compliance
--------------
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
* Functions supported
* Service/Functions not supported


NSSF Compliance
---------------
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
* Functions supported
* Service/Functions not supported


PCF Compliance
--------------
* Interface support
    * SBI : Yes
    * UNKNOWN: No
* Service Supported
* Functions supported
* Service/Functions not supported


SD Core High Level Features supported
-------------------------------------

High Level Features Not supported
---------------------------------
* URLLC
* Location Based Services
