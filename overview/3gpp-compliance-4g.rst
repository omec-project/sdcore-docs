..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _4g-compliance:

4G - 3GPP Release Compliance
============================

High Level Procedures Supported
-------------------------------

    - Initial UE Attach
    - UE Detach
    - S1 Release
    - Service Request
    - N/W initiated Detach
    - Downlink Data Notification
    - s1/x2 Handover for eNB change
    - 5G-NSA related procedure support

High Level Procedures/Functions Not Supported
---------------------------------------------

    - Location based services
    - MME, SGW handover
    - Indirect tunnel forwarding
    - Roaming architecture
    - Charging
    - Lawful intercept
    - IMS integration
    - dedicated Bearers ( Partial support)
    - Multiple PDN Support
    - CSFB

MME Compliance
--------------
* Interface supported : NAS, s1ap, S6a, S11
* Functions supported

    - All the procedures mentioned above and following,
    - Dedicated bearer handling
    - s1ap interface management procedure
    - S1 Context management procedures
    - Subscriber management procedure on S6a interface

* Functions not supported

    - HSS modify/delete subscriber data

SPGW Compliance
----------------
* Interface supported: Gx, Sxab
* Functions supported: All the procedures mentioned above and following,

    - PFCP Association management
    - Control plane based UE address allocation
    - User Plane based UE address allocation
    - Receive and handle Usage Report sent by user plane

* Functions not supported


PCRF Compliance
----------------
* Interface supported: Gx
* Functions supported

    - Installing PCC rules for the subscribers
    - Removal of Rules with timer trigger
    - Removal of Gx Session with timer trigger

* Functions not supported

    - Charging functionality
    - PCEF initiated Gx session update


HSS Compliance
---------------
* Interface supported: S6a
* Functions supported

    - Subscriber management
    - Authentication Vector generation
    - Resynchronization of authentication vector
    - Update Location procedure
    - Purge Location procedure

* Functions not supported

    - Insert subscriber data runtime
    - Delete Subscriber data runtime
