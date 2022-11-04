..
   SPDX-FileCopyrightText: © 2022 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_upf_guide:

UPF Deployment Guide
====================

- Each Site has one or more UPFs dedicated for use case
- Each Slice supports only 1 UPF
- UPFs can be added during runtime and UP/CP form PFCP association
- Edges can run on different versions of UPF. Changes are always backward compatible
- Option to Install only 4G or 5G or both
- Multiple UPF (user plane function) options available to meet the needs of different applications BESS-UPF, P4-UPF
- Many UPFs can connect to same control plane. Control Plane selects UPF based on
  various criteria - DNN/Slice (5G), Apn, IMSI, ULI(4G), Slice IDs
- IP address allocation supported at Control plane and also at UPF
- UPF Attach/detach to SD-Core. UPF Pools created based on enterprise need.

Option1: AF_PACKET Mode UPF
''''''''''''''''''''''''''''

- Refer Aether in a box (AIAB) for this mode.
- AIAB has all default values and its good example of how to use AF_PACKET mode
- If performance is not the concern then this option should be considered
- AF_PACKET mode is easy to deploy and does not need to do extra installations on K8s node


Option2: SRIOV and DPDK enabled UPF
'''''''''''''''''''''''''''''''''''''

- This option should be preferred if performance is utmost important
- Please refer to `UPF Installation Guide <https://docs.google.com/document/d/1-BT7XqVsL7ffBlD7aweYaScKDQH7Gv5tHKt-sJGuf6c/edit#>`_ guide for more details
