..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _design_amf:

AMF Design Overview
===================
To make AMF cloud native application enhanced the existing design of AMF. Introduced a new service
called SctpLb (SctpLoadbalancer) which receives ngap messages and distribute to Amf Instances. Also
added DB support to Store UE Context. On successful completion of each procedure UE Context
create/update/delete in MongoDB. AMF is tested with simulated gNB/UEs (gnbsim) for its stability.

.. image:: ../_static/images/CN-AMF.png
  :width: 500px

SctpLb (SctpLoadbalancer)
-------------------------

  * Accept and manage gnb or sctp connections

  * GRPC communication between SctpLb and Amf Service

  * Handles Amf Instance Down/Up Notifications

  * Backend NF manages AMF instances

  * Round-Robin Distribution of Sctp Messages over grpc channel to Backend NF

  * Redirect Support for forwarding Sctp Messages to a particular Amf Instance
