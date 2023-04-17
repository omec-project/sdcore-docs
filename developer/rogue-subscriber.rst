..
   SPDX-FileCopyrightText: 2023-present Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _rogue-subscriber:

Rogue Subscriber Blocking
=========================

.. image:: ../_static/images/rogue-subscriber.png
  :width: 500px

This feature enables 5G network to revoke subscription of malicious UE. It is required that UPF is
configured to support malicious subscriber identification. The custom user application can read the malicious
subscriber's IP Address identified by the UPF and can make available to 5G core network via Metric-Function.
The 5G network shall revoke malicious UEs subscription based on UE IP-Addresses received.

Please follow detailed flow

* The UPF shall detect malicious UE IP-Address and the user application shall learn it.
* The user application shall maintain the malicious subscriber's IP Address.
* The Controller functionality of the MetricFunction shall keep polling the user application to fetch malicious
  subscriber's IP
  Address.
* The metricfunc manages all subscriber contexts, so the Controller identifies the IMSI associated to malicious
  Subscriber IP.
* The MetricFunc Pod notifies the ROC to disable the SIM Card associated with malicious subscriber.
* ROC updates the Config Server(webui) with updated Device Group(s) and slice(s) information.
* AMF initiates a network-triggered deregistration procedure to detach the UE from the 5G core.

The Metric-Function configuration to poll the user application

.. code-block::

   userAppApiServer:
     addr: "userapp.omec.svc"
     port: 9301
   rocEndPoint:
     addr: "aether-roc-umbrella-aether-roc-gui-v2-1-external.aether-roc.svc"
     port: 80
