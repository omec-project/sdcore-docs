..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

SD-Core Introduction
====================

The SD-Core™ project is a 4G/5G disaggregated mobile core optimized for public
cloud deployment in concert with distributed edge clouds and is ideally suited
for carrier and private enterprise 5G networks. It exposes standard 3GPP interfaces
enabling use of SD-Core as a conventional mobile core. It is also available
pre-integrated with an adapter (part of the Aether ROC subsystem) for those
deploying it as a mobile core as-a-service solution.

SD-Core is an integral component of Aether, ONF’s 5G Connected Edge platform for
private mobile connectivity and edge cloud services. It can be rapidly deployed
pre-integrated with Aether, as a standalone 5G/4G mobile core, or as control and
dataplane (UPF) components integrated into custom designed solutions. This range
of versatility makes the open source SD-Core platform ideally suited for the
broadest range of use cases and deployment scenarios.

SD-Core Overview
----------------

    - Ensure only authenticated mobile devices have network access
    - Provides IP connectivity for data & voice services
    - Ensures connectivity adheres to QoS and network slice policies
    - Tracks user mobility to ensure uninterrupted service
    - Tracks subscriber usage

.. image:: ../_static/images/SD-Core-Overview.png
  :width: 700px

SD-Core is an Integral Part of Aether
-------------------------------------

    - SD-Core is an integral component of Aether, ONF’s 5G Connected Edge platform for
      private mobile connectivity and edge cloud services.
    - SD-Core provides the 4G/5G connectivity and the SD-Core control plane at the central
      site controls multiple SD-Core user plane components running at each Aether Edge site.

.. image:: ../_static/images/Sd-Core-Aether-Integral.jpg
  :width: 700px
