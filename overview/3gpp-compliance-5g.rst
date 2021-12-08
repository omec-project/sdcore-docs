5G - 3GPP Release Compliance
============================

High Level Summary
------------------

* Service based Interfaces supported
    * Nnssf, Nnrf, Npcf, Nudm, Nausf, Namf, Nsmf


.. image:: ../_static/images/5G_Interfaces.png
  :width: 700px


* Reference model based Interfaces supported
    * N1, N2, N3, N4, N6, N7, N8, N9, N10, N11, N12, N13, N15, N22

.. image:: ../_static/images/5G_Arch_ reference_model.png
  :width: 700px


* NF supported
    * AMF, NRF, SMF, PCF, UDM, UDR, NSSF, AUSF


* High Level Features supported
    * UE Registration
    * UE De-Registration
    * PDU Session Establishment/Modification/Release
    * AN Release
    * Network triggered Service Request
    * Xn based inter NG-RAN handover

* High Level Features Not supported
    * URLLC
    * Location Based Services


SMF Compliance
--------------
* Interfaces
    * SBI : Yes
    * N4(UPF), N7(PCF), N10(UDM), N11(AMF) : Yes

* Services
    * PDU Session Management
    * Event Exposure
    * NIDD

* Service Operations
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


AMF Compliance
--------------
* Interfaces
    * SBI : Yes
    * N11(SMF), N15(PCF), N8(UDM), N12(AUSF), N22(NSSF), N2(AN), N1(UE) : Yes
    * N14(AMF), N58(NSSAAF) : No

* Services
    * Communication
    * Event Exposure
    * Mobile Terminated
    * Location

* Service Operations
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

* Service Operations
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


AUSF Compliance
---------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * UE Authentication
    * SoR Protection
    * UPU Protection

* Service Operations
    * UE Authentication
        * Authenticate
        * Deregister
    * SoR Protection
        * Protect
    * UPU Protection
        * Protect



UDR Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No
* Services
    * Data Repository
    * Group IDmap

* Service Operations
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

* Service Operations
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



NSSF Compliance
---------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * NS Selection
    * NSSAI Availability

* Service Operations
    * NS Selection
        * Get
    * NSSAI Availability
        * Update
        * Subscribe
        * Unsubscribe
        * Notify
        * Delete
        * Options


PCF Compliance
--------------
* Interfaces
    * SBI : Yes
    * UNKNOWN: No

* Services
    * AM Policy Control : Yes
    * SM Policy Control : Yes

* Service Operations
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
