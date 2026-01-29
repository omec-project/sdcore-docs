..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Frequently Asked Questions
==========================

**Does SD-Core support roaming architecture?**

   SD-Core is primarily focused on private 5G and private LTE use cases, and
   therefore roaming aspects of the architecture are not currently supported.

**Does SD-Core support charging functionality or CHF (Charging Network Function)?**

   SD-Core is primarily focused on private 5G and private LTE use cases, and
   therefore charging-related aspects are not currently supported.

**Is SD-Core/5G-Core cloud native?**

   SD-Core components are designed to run in Kubernetes environments with cloud-native
   principles including containerization, scalability, and dynamic configuration.

**What is SD-Core's relationship with free5GC?**

   SD-Core's 5G control plane leverages seed code from the free5GC project, upon which
   the SD-Core community has implemented numerous architectural enhancements and optimizations.
   Key improvements include:

   - Configuration APIs to configure all network functions
   - QoS support for default flows and per-application flows
   - Stability improvements supporting 5000 subscribers with 10 calls per second
     (single instance)
   - Fixed error cases related to UPF connectivity
   - Improved handling of message retransmission and timeout scenarios with UPF
   - Enhanced stability during network function restarts
   - Stability improvements on NGAP and N1 interfaces
   - Over 100 code commits focused on stability improvements
   - 3GPP compliance documentation for 5G core
   - Per-UE Finite State Machine (FSM) in AMF and SMF
   - Transaction support in AMF and SMF
   - UE address allocation by UPF support in SMF

   This is a high-level summary. For more details, see the
   `detailed changes document <https://docs.google.com/document/d/1B4WQdgK5QwLcsmgg9qMRP0lupawVzh1F8N5YjTpLBCM/edit#>`_.

**What about network performance testing of SD-Core?**

   Limited scale testing has been performed to evaluate control plane subscriber capacity
   and transaction rates. Formal performance results will be published in the release notes
   and testing sections as they become available.

