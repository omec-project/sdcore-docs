Configuration Overview
======================

Reference helm chart
--------------------

    - `SD-Core Helm Chart Repository <https://gerrit.opencord.org/admin/repos/sdcore-helm-charts>`_

Configuration Methods
---------------------
SD-Core supports 2 ways to configure network functions and micro services.

    - Helm Chart

        - Each individual network function and microservice has its own helm chart.
        - User needs to provide override values and deploy the network functions as per their need.

    - REST Config Interface

        - Basic static configuration is passed through helm chart
        - Dynamic slice creation APIs are provided through REST interface.
        - REST APIs are defined to create/modify/delete network slice.
        - REST APIs are also provided to provision subscribers and grouping the subscribers under device Group.

Configuration Steps
-------------------
This Configuration describes what to configure at high level from RoC/SIMAPP. ConfigPod stores this configuration
and publish to respective clients over REST/grpc.

    - Step1 : Provision subscriber in 4G/5G subsystem

        - This step is used to configure IMSI in the SD-Core
        - This procedure is used to configure security keys for a subscriber
        - Subscribers can be created during system startup or later

    - Step2 : Device Group Configuration

        - Group multiple devices under device group
        - Configure QoS for the device group
        - Configure IP domain configuration for the device group e.g. MTU, IP Pool, DNS server


    - Step3: Network Slice Configuration

        - Configuration to create a Network Slice
        - Add device Group into Network Slice
        - Slice contains the Slice level QoS configuration
        - Site configuration including UPF, eNBs/gNBs assigned to the slice
        - Applications allowed to be accessed by this slice (see :ref:`application-filtering`)


