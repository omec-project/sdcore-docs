..
   SPDX-FileCopyrightText: 2022-present Intel Corporation
   SPDX-License-Identifier: Apache-2.0

SD-Core Upcoming Release
========================

Currently SD-Core has high level focus of making AMF & SMF cloud native. Also
adding some new features in the gNBSim to give more flexibility to user.

Work Items
----------

**Documentation update** : Update SD-Core document and Aether document
to answer frequently asked questions.

**Cloud Native Control Plane**

- NRF Keepalive : Each Network Function does periodic registration towards NRF.
  NRF removes the network function from the NRF database if keepalive missed for configured number of seconds.

- Saving Subscriber States : Enable subscriber state storage in database.
  Upcoming release is planned to have support for AMF & SMF.

- Multiple Instance of AMF : Support running multiple instances of AMF

- Multiple Instance of SMF : Support running multiple instances of SMF

- SCTPLB : SctpLb is new component to terminate SCTP connection from gNodeB.

- UPF-Adapter : Upf-adapter is a new component used by multiple SMF instances to communicate with UPF

**Common Features**

- SMF supports - UE address allocation from UPF. This feature was already supported in 4G (SPGW). Now
  with new release, this feature will be part of 5G Core.

**gNBSim improvements to support**

- REST Interface to start profile

- Custom profile to run arbitrary procedures for subscribers

- Adding Custom Delay between execution of the subscribers profiles

- GTPU Echo Request/Response Support in gNBSim

- Making gNBSim configurable to send user defined slice Ids & DNN

- Sending correct TAC information in the ULI IE
