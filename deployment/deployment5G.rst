..
   SPDX-FileCopyrightText: 2023-present Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_5G_guide:

5G Deployment Guide
===================

Deployment Overview
-------------------

SD-Core is released with Helm charts and container images. We recommend using
**Kubernetes** and **Helm** to deploy SD-Core. All SD-Core container images are
hosted on Docker Hub and GitHub Registry.

Hardware Resource Requirements
------------------------------

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
  * - AF
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

For setting up a 5G development environment, please refer to
`Aether OnRamp <https://docs.aetherproject.org/onramp/overview.html>`_.
The legacy :ref:`aiab-guide` is preserved for historical reference.

Production Environments - 5G
""""""""""""""""""""""""""""

To install SD-Core into your Kubernetes cluster, follow these steps:

Step 1: Clone SD-Core 5G Helm Chart
''''''''''''''''''''''''''''''''''''

Clone the repository and update dependencies:

.. code-block:: bash

   git clone https://github.com/omec-project/sdcore-helm-charts.git
   cd sdcore-helm-charts/sdcore-helm-charts/
   helm dep update  # Update Helm dependencies

Step 2: Prepare Your Helm Values for 5G
''''''''''''''''''''''''''''''''''''''''

While you can modify the existing ``values.yaml`` directly, we recommend creating a
separate values file (e.g., ``myvalues.yaml``) using ``values.yaml`` as a template.
This approach makes it easier to track your customizations and upgrade in the future.

For detailed explanations of the supported Helm values, refer to the Configuration
section below.

Step 3: Install 5G Using SD-Core Umbrella Helm Chart
'''''''''''''''''''''''''''''''''''''''''''''''''''''

The following command deploys the SD-Core Helm chart with release name ``sdcore-5g``
in the ``sdcore-5g`` namespace:

.. code-block:: bash

   helm install -n sdcore-5g --create-namespace -f myvalues.yaml sdcore-5g \
     ./sdcore-helm-charts

.. note::
   Adjust the chart path (``./sdcore-helm-charts``) to match your local directory structure where you cloned the sdcore-helm-charts repository.

**Verify the Installation**

Check the Helm release status:

.. code-block:: bash

    helm -n sdcore-5g ls
    xxxx@node:~$ helm -n sdcore-5g ls
    NAME     	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART         	APP VERSION
    sdcore-5g	sdcore-5g	1       	2022-03-05 16:25:32.338495035 -0700 MST	deployed	sd-core-0.10.9
    xxxx@node:~$

    xxxx@node:~$ kubectl get pods -n aether-5gc
    NAME                                           READY   STATUS    RESTARTS   AGE
    af-794f6bc999-8z9td                            1/1     Running   0          84m
    amf-5d84ccb587-x8b2r                           1/1     Running   0          84m
    ausf-57c665bd98-r9t9x                          1/1     Running   0          84m
    kafka-dual-0                                   1/1     Running   0          84m
    kafka-entity-operator-76764c7dfc-mptj8         2/2     Running   0          83m
    metricfunc-6bdb886f6d-jmn8s                    1/1     Running   0          84m
    mongodb-0                                      2/2     Running   0          84m
    mongodb-1                                      2/2     Running   0          83m
    mongodb-arb-0                                  2/2     Running   0          84m
    mongodb-kubernetes-operator-7989c65684-bvlxw   1/1     Running   0          84m
    nrf-5b76f8cbdc-fb8ws                           1/1     Running   0          84m
    nssf-749598c758-lwkzm                          1/1     Running   0          84m
    pcf-6c77f966d5-j86p9                           1/1     Running   0          84m
    simapp-6549f79d79-rh6dq                        1/1     Running   0          84m
    smf-5f7bcc456b-95567                           1/1     Running   0          84m
    strimzi-cluster-operator-7c667c9ccb-7xtcn      1/1     Running   0          84m
    udm-5bc879dc6c-4dqhf                           1/1     Running   0          84m
    udr-59f87695b4-sbs4s                           1/1     Running   0          84m
    upf-0                                          5/5     Running   0          84m
    webui-76c549747b-6xv2r                         1/1     Running   0          84m
    xxxx@node:~$

**Application Function (AF)**

The ``5g-control-plane`` chart deploys the AF by default (``config.af.deploy: true``). The AF registers at
the NRF, discovers the PCF through it (set ``pcfUri`` in ``config.af.cfgFiles`` to skip discovery) and
exposes a northbound HTTP API on port ``7782`` (Service ``af``) for the IMS P-CSCF. Set
``config.af.deploy: false`` if no IMS is used. The northbound API is unauthenticated unless
``northbound.authTokenFile`` is set in ``afcfg.yaml``, so restrict access to it to the IMS network.

**Uninstall SD-Core**

To uninstall the SD-Core deployment:

.. code-block:: bash

   helm -n sdcore-5g uninstall sdcore-5g
   kubectl delete namespace sdcore-5g  # Optional: remove the namespace

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

.. code-block:: yaml

   sctplb:
     deploy: true

Enable AMF DB Store
'''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block:: yaml

   amf:
     cfgFiles:
       amfcfg.conf:
         configuration:
           enableDBStore: true

Enable SMF DB Store
'''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block:: yaml

   smf:
     cfgFiles:
       smfcfg.conf:
         configuration:
           enableDBStore: true

Enable UPF-Adapter
''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block:: yaml

   upfadapter:
     deploy: true

Enable NRF Keep-Alive
''''''''''''''''''''''
Edit sd-core-5g-values.yaml as following

.. code-block:: yaml

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

.. code-block:: yaml

   cpiface:
     dnn: "internet"
     hostname: "upf"
     enable_ue_ip_alloc: true
     ue_ip_pool: "172.250.0.0/16"


Enable Static UE IP-Address allocation
''''''''''''''''''''''''''''''''''''''
This config shall help in reserving Static UE IP-Address for any given UE.
The config should mention details about DNN, UE's IMSI and preferred IP-Address from that DNN pool.

.. code-block:: yaml

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

.. code-block:: diff

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

.. code-block:: diff

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
