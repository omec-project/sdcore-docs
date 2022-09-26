..
   SPDX-FileCopyrightText: © 2022 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_upf_guide:

UPF Deployment Guide
====================

- Each Site has one or more UPFs dedicated for use case
- UPFs can be added during runtime and UP/CP form PFCP association
- Edges can run on different versions of UPF. Changes are always backward compatible
- Option to Install only 4G or 5G or both
- Multiple UPF (user plane function) options available to meet the needs of different applications BESS-UPF, P4-UPF
- Many UPFs can connect to same control plane. Control Plane selects UPF based on
  various criteria - DNN/Slice (5G), Apn, IMSI, ULI(4G), Slice IDs
- IP address allocation supported at Control plane and also at UPF
- UPF Attach/detach to SD-Core.  UPF Pools created based on enterprise need.
