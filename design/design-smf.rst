..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _design_smf:

SMF Design Overview
===================

.. image:: ../_static/images/CN-SMF.png
   :width: 500px
   :alt: SMF Architecture Diagram

UPF-Adapter
-----------

The UPF-Adapter layer (optional) has been introduced to address a limitation where UPF
may not support connections from multiple SMF instances using the same Node-ID.

**Key Functions:**

- Acts as a multiplexer/demultiplexer for PFCP messages between multiple SMF instances
  and the UPF
- Receives custom PFCP messages from SMF instances when deployed
- Intercepts and modifies specific fields before forwarding PFCP messages to the actual UPF
- Performs similar processing for responses from UPF back to SMF instances

