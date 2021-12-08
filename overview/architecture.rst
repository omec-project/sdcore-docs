..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

SD-Core Architecture
====================

    * SD-Core is a flexible, agile, scalable and configurable dual-mode 4G/5G core
      network platform that builds upon and enhances ONF’s OMEC and free 5GC core
      network platforms to support LTE, 5G NSA and 5G SA services.

    * The SD-Core control plane provides the flexibility of simultaneous supports
      for 5G standalone, 5G non-standalone and 4G/LTE deployments.

    * SD-Core provides a rich set of APIs to Runtime Operation Control (ROC).

        * Operators can use these APIs to provision the subscribers in the mobile core;
        * Control runtime configuration of network functions
        * Provide telemetry data to third party applications
        * Third party applications can leverage telemetry data to create applications
          for closed loop control.

.. image:: ../_static/images/SD-Core-Architecture.png
  :width: 700px

Multiple Distributed User Planes
--------------------------------

SD-Core has three User Plane Functions (UPFs) designed to be deployed throughout
the network edge. Each UPF is optimized to handle specific classes of application
and take advantage of various hardware acceleration options. Deployments can
intermix the UPF variants.

    * P4-Based UPF optimized for private enterprise deployments, and providing fine-grained
      visibility for verifiable performance and secure operations
    * Containerized Dual-Core UPF optimized for private enterprise deployments, capable of
      processing LTE and 5G traffic simultaneously
    * Containerized Dual-Core UPF optimized for various MNO use cases, capable of processing
      LTE and 5G traffic simultaneously


SD-Core architecture is modular and apis are provided to manage connectivity service.

    - Connectivity service is designed in such a way that it can be consumed easily and its
      easy to configure. Please refer ``configuration section``. Configuration APIs are same
      for 4G & 5G service.
    - Metrics are exposed from SD-Core which helps network admins and application developers.
    - Application filtering is supported to restrict the access to applications.

Architecture Diagram showing SD-Core box
----------------------------------------
- Diagram should show ROC interface, prometheus interface, UPF interface, gNB/eNB interface

Architecture Diagram of SD-Core 4G block
----------------------------------------
- show configPod, config distribution, MongoDB, Cassandra DB, SIMApp..., 4G network Functions

Architecture Diagram of SD-Core 5G block
----------------------------------------
- show configPod, config distribution, MongoDB, SIMApp, 5G network functions

Configuration Distribution Architecture
---------------------------------------
- how grpc, rest is used to distribute the configuration

