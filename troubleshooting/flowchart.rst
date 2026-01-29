..
   SPDX-FileCopyrightText: 2026 Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Connectivity Troubleshooting
============================

This section provides guidance for troubleshooting connectivity issues in SD-Core deployments.

Key Metrics to Monitor
----------------------

4G Networks
^^^^^^^^^^^

When troubleshooting 4G connectivity issues, monitor the following:

- **eNB Status**: Check if the eNodeB is properly connected and registered
- **Subscriber Information**: Verify IP address allocation and IMSI registration
- **Bearer Status**: Ensure default and dedicated bearers are established correctly
- **S1-AP Connection**: Verify the control plane connection between eNB and MME
- **S1-U Connection**: Check the user plane connection between eNB and SGW/PGW

5G Networks
^^^^^^^^^^^

When troubleshooting 5G connectivity issues, monitor the following:

- **gNB Status**: Check if the gNodeB is properly connected and registered
- **Subscriber Information**: Verify IP address allocation and IMSI/SUPI registration
- **PDU Session Status**: Ensure PDU sessions are established correctly
- **NG-AP Connection**: Verify the control plane connection between gNB and AMF
- **N3 Connection**: Check the user plane connection between gNB and UPF

Common Troubleshooting Steps
----------------------------

1. **Verify Pod Status**: Ensure all SD-Core pods are running without errors
2. **Check Logs**: Review logs from relevant network functions (AMF, SMF, UPF, etc.)
3. **Validate Configuration**: Confirm subscriber, device group, and network slice configurations
4. **Network Connectivity**: Test connectivity between components
5. **Resource Availability**: Check CPU, memory, and network resources
