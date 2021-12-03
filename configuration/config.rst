Overview
========

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

Configuration
-------------

    - Network Slice Configuration

        - Configuration to create a slice of network
        - Slice contains the QoS configuration
        - Group of devices assigned to network slice
        - Site configuration including UPF, eNBs/gNB assigned to the slice

    - Device Group Configuration

        - Configuration of group of UEs
        - QoS required for the device group
        - IP domain configuration for the group of devices

    - UE Provisioning

        - Configuration of IMSI and its security keys configuration

Sample Configuration
--------------------

