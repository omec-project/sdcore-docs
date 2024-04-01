..
   SPDX-FileCopyrightText: 2023-present Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_5G_guide:

5G Deployment Guide
===================

Deployment Overview
-------------------
SD-Core is released with Helm chart and container images.
We recommend using **Kubernetes** and **Helm** to deploy SD-Core.
SD-Core images are hosted on docker hub.

Hardware resource requirement
-----------------------------

.. list-table:: CPU & Memory Requirements for 5G components
  :widths: 5 5 5
  :header-rows: 1

  * - SD-Core Component
    - Required CPU
    - Required Memory in Gi
  * - AMF
    - 2 CPU Cores
    - 4Gi
  * - SMF
    - 2 CPU Cores
    - 4Gi
  * - NRF
    - 2 CPU Cores
    - 1Gi
  * - NSSF
    - 2 CPU Cores
    - 1Gi
  * - AUSF
    - 1 CPU Cores
    - 1Gi
  * - PCF
    - 1 CPU Cores
    - 1Gi
  * - UDR
    - 2 CPU Cores
    - 1Gi
  * - UDM
    - 2 CPU Cores
    - 1Gi
  * - Config5G(webconsole)
    - 1 CPU Cores
    - 1Gi
  * - SimApp
    - 1 CPU Cores
    - 1Gi
  * - MongoDB
    - 2 CPU Cores
    - 4Gi
  * - UPF-Adapter
    - 1 CPU Cores
    - 1Gi
  * - SCTP Load Balancer
    - 1 CPU Cores
    - 1Gi

.. note::
   SD-Core deployment is tested on Intel/AMD hardware. There is WIP to run SD-Core
   on ARM architecture.

Deployment Options
------------------

Development Environments
""""""""""""""""""""""""

Please refer (see :ref:`aiab-guide`) to setup 5G development environment.

Production Environments - 5G
""""""""""""""""""""""""""""

To install SD-Core into your Kubernetes cluster, follow instructions

Step1 - Clone SD-Core 5G Helm chart
'''''''''''''''''''''''''''''''''''
.. code-block::

  git clone https://github.com/omec-project/sdcore-helm-charts.git
  cd sdcore-helm-charts/sdcore-helm-charts/
  helm dep update #Update Helm dependencies

Step2 - Prepare your Helm value for 5G
''''''''''''''''''''''''''''''''''''''

You can modify existing values.yaml directly, but we recommend composing another value
file myvalues.yaml using values.yaml as an example. We are highlighting a few things we
need to modify here. More explanation of the supported Helm values can be found in the
Configuration section below.

Step3 - Install 5G using SD-Core umbrella helm chart
''''''''''''''''''''''''''''''''''''''''''''''''''''

The following command will deploy the SD-Core helm chart with release name sdcore-5g in the sdcore-5g namespace.

.. code-block::

    helm install -n sdcore-5g --create-namespace -f myvalues.yaml sdcore-5g  ~/cord/sdcore-helm-charts/sdcore-helm-charts

To verify the installation:

.. code-block::

    helm -n sdcore-5g ls
    xxxx@node:~$ helm -n sdcore-5g ls
    NAME     	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART         	APP VERSION
    sdcore-5g	sdcore-5g	1       	2022-03-05 16:25:32.338495035 -0700 MST	deployed	sd-core-0.10.9
    xxxx@node:~$

    xxxx@node:~$ kubectl get pods -n sdcore-5g
    NAME                          READY   STATUS    RESTARTS   AGE
    amf-6cddb6ff5-g5kwp           1/1     Running   0          8d
    ausf-64fb5c5df5-g9xps         1/1     Running   0          8d
    gnbsim-0                      1/1     Running   0          8d
    mongodb-0                     1/1     Running   0          8d
    mongodb-1                     1/1     Running   0          8d
    mongodb-arbiter-0             1/1     Running   0          8d
    nrf-69794885b-pgl8f           1/1     Running   0          8d
    nssf-fc9c48c89-dxqn7          1/1     Running   0          8d
    pcf-5c7d7767c9-wv6dl          1/1     Running   0          8d
    simapp-669b99db9d-lbbm4       1/1     Running   0          8d
    smf-b87fc6f8f-4jdqr           1/1     Running   0          8d
    smf-b87fc6f8f-xt2n2           1/1     Running   0          8d
    udm-f948b57dc-n5b4h           1/1     Running   0          8d
    udr-698445bd87-8ptpm          1/1     Running   0          8d
    upf-0                         5/5     Running   0          8d
    upf-adapter-c4844b7fb-wqbvw   1/1     Running   0          8d
    webui-8cfb9659c-hqfp9         1/1     Running   0          8d
    xxxx@node:~$

To uninstall:

.. code-block::

    helm -n sdcore-5g uninstall sdcore-5g
    kubectl delete namespace sdcore-5g # also remove the sdcore-5g if needed

Cloud Native Configuration - 5G
""""""""""""""""""""""""""""""""

Following configuration need to be enabled in 5G helm values override file.
It is important to understand usage of following flags

- **SCTP Load Balancer** :
  Enable this flag to introduce SCTP Load Balancer between gNBs and multiple AMF instances
  to load balance sctp connections across multiple AMF instances.

- **DB Store** :
  Enable this flag to preserve AMF context or SMF PDU session into Database.
  This is required for any AMF/SMF instance to load session/context of any
  other instance which being fault recovered.

- **UPF-Adapter** :
  Enable this flag to introduce UPF-Adapter between multiple SMF instances
  and UPF. This required for the case where UPF does not support multiple
  SMF association with same pfcp node-id.

- **NRF Keep-Alive** :
  Enable this flag for NRF to maintain multiple NF profiles and trigger periodic
  profile updates from the registered NFs.

- **UE IP-Address alloc via UPF** :
  Enable this config to get UE IP-Address allocated via UPF rather than locally by SMF.

- **Static UE IP-Address alloc** :
  Enable this config to reserve static UE IP-Address for any specific UE.

- **Custom IMSI support** :
  Employ this config to have custom IMSI(starts with leading zeroes) for development environment with real UE.

Enable AMF Sctp Load Balancer
'''''''''''''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block::

    sctplb:
      deploy: true

Enable AMF DB Store
'''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block::

    amf:
      cfgFiles:
        amfcfg.conf:
          configuration:
            enableDBStore: true

Enable SMF DB Store
'''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block::

    smf:
      cfgFiles:
        smfcfg.conf:
          configuration:
            enableDBStore: true

Enable UPF-Adapter
''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block::

    upfadapter:
      deploy: true

Enable NRF Keep-Alive
''''''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block::

    nrf:
      cfgFiles:
        nrfcfg.conf:
          configuration:
            mongoDBStreamEnable: false
            nfProfileExpiryEnable: true
            nfKeepAliveTime: 60

Enable UE IP-Address allocation by UPF
''''''''''''''''''''''''''''''''''''''
This is optional feature to allocate UE IP-Address via UPF rather than locally via SMF.
Edit sd-core-5g-values.yaml as following

.. code-block::

 cpiface:
   dnn: "internet"
   hostname: "upf"
   enable_ue_ip_alloc: true
   ue_ip_pool: "172.250.0.0/16"


Enable Static UE IP-Address allocation
''''''''''''''''''''''''''''''''''''''
This config shall help in reserving Static UE IP-Address for any given UE.
The config should mention details about DNN, UE's IMSI and preferred IP-Address from that DNN pool.

.. code-block::

 smf:
   cfgFiles:
     smfcfg.conf:
       configuration:
         staticIpInfo:
         - dnn: internet
           imsiIpInfo:
             supi-123456789012341: "172.250.237.10"
             supi-123456789012342: "172.250.237.11"

Enable Custom IMSI with real UE 5G deployment
'''''''''''''''''''''''''''''''''''''''''''''

Following configuration is required to have custom test IMSI with real UE 5G deployment.

Existing MCC/MNC = 208/93
New MCC/MNC = 001/22

Patch following files

* Mandatory

Patch aether-in-a-box/sd-core-5g-values.yaml as following

.. code-block::

         # below block configures the subscribers and their security details.
          # you can have any number of subscriber ranges
          subscribers:
  -       - ueId-start: "208930100007487"
  -        ueId-end: "208930100007500"
  -        plmnId: "20893"
  +       - ueId-start: "001220100007487"
  +        ueId-end: "001220100007500"
  +        plmnId: "00122"
           opc: "981d464c7c52eb6e5036234984ad0bcf"
           op: ""
           key: "5122250214c33e723a5dd523fc145fc0"
           sequenceNumber: "16f3b3f70fc2"
  -       - ueId-start: "208930100007501"
  -        ueId-end: "208930100007599"
  -        plmnId: "20893"
  +       - ueId-start: "001220100007501"
  +        ueId-end: "001220100007599"
  +        plmnId: "00122"
           opc: "981d464c7c52eb6e5036234984ad0bcf"
           op: ""
           key: "5122250214c33e723a5dd523fc145fc0"

* only if ROC is employed

Patch aether-in-a-box/roc-5g-models.json as following

.. code-block::

            "imsi-definition": {
  -           "mcc": "208",
  -           "mnc": "93",
  +           "mcc": "001",
  +           "mnc": "22",
   {
                "sim-id": "aiab-sim-1",
                "display-name": "UE 1 Sim",
  -             "imsi": "208930100007487"
  +             "imsi": "001220100007487"
              },
