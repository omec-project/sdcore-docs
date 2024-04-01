..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

SD-Core Next Release
========================

We expect next SD-Core release to be available in the **Sep 2024**.

Metrics Support
----------------

     - Creating SD-Core metrics dashboard for 5G
     - Should handle multiple instances of AMF, SMF
     - Example statistics could be - `Number of UEs, UE status, UPFs status, gNB status, UE details`

Extensions of AMF, SMF Cloud Native Support
-------------------------------------------

    - Robustness test with multiple AMF, SMF
    - Auto scale AMF, SMF with CPU/Memory/Custom metrics
    - Adding SBI Load Balancer
    - Multiple instances of SCTP LBs
    - Multiple instances of UPF adapter

Cloud Native UPF
----------------

    - Running multiple instances of UPF
    - Storing states in DB

gNBSim Features
----------------

    - Running multiple gNodeBs under same gNBSim container
    - gNodeB handover support

NRF Notification
----------------

    - NRF discovery result cache support
    - NRF notification integration in AMF, SMF
    - SCTPLb to use NRF notification, discovery APIs (postponed)
    - Distributed Resource Sharing Module (DRSM) to use NRF notification & discovery APIs
    - UPF Adapter to use NRF notification & discovery APIs

Redundancy Events
-----------------

    - Testing restart of Sctplb
    - Testing restart of upf adapter
    - Testing restart of metric function

.. note::
   Some of the features mentioned above are stretch goals and we rely on community members to
   submit the code. There is chance that some of the code may not be able to make it to next
   release.
