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
        - Applications allowed to be accessed by this slice

Option I - Configuration using Simapp POD
-----------------------------------------

Easiest way to configure SD-Core is to use simapp. Simapp is the POD which takes
yaml configuration and configures the subscribers, device groups, network slices

.. code-block::

  config:
    simapp:
      cfgFiles:
        simapp.yaml:
          configuration:
            provision-network-slice: true
            sub-provision-endpt:
              addr: config4g
              port: 5000
            subscribers:
            - ueId-start: 208014567891201
              ueId-end: 208014567891211
              plmnId: 20801
              opc: "d4416644f6154936193433dd20a0ace0"
              op: ""
              key: "465b5ce8b199b49faa5f0a2ee238a6bc"
              sequenceNumber: 96
            device-groups:
            - name:  "4g-oaisim-user"
              imsis:
                - "208014567891201"
                - "208014567891202"
              ip-domain-name: "pool1"
              ip-domain-expanded:
                dnn: internet
                dns-primary: "8.8.8.8"
                mtu: 1460
                ue-ip-pool: "172.250.0.0/16"
                ue-dnn-qos:
                  dnn-mbr-downlink: 20000000
                  dnn-mbr-uplink: 4000000
                  bitrate-unit: bps
                  traffic-class:  #default bearer QCI/ARP
                    name: "platinum"
                    qci: 9
                    arp: 1
                    pdb: 300
                    pelr: 6
              site-info: "aiab"
            network-slices:
            - name: "default"
              slice-id:
                sd: "010203"
                sst: 1
              site-device-group:
              - "4g-oaisim-user"
              site-info:
                gNodeBs:
                - name: "aiab-gnb1"
                  tac: 1
                plmn:
                  mcc: "208"
                  mnc: "01"
                site-name: "aiab"
                upf:
                  upf-name: "upf"
                  upf-port: 8805

Option II - Configuration using REST Interface
----------------------------------------------

You can decide to use any other tool to generate REST messages towards SD-Core to configure
subscribers, device groups and network slice


Subscriber Configuration through REST Interface
"""""""""""""""""""""""""""""""""""""""""""""""

Below example configures subscriber `208014567891209` in the SD-Core

.. code-block::

  - Post:
    URL: `http://<config-service-name-or-ip>:<port>/api/subscriber/<imsi-xxx>`
    Ex: `http://<config-service-name-or-ip>:<port>/api/subscriber/<imsi-208014567891209>`

    Request Body:

        {
            "UeId":"208014567891209",
            "plmnId":"20801",
            "opc":"d4416644f6154936193433dd20a0ace0",
            "key":"465b5ce8b199b49faa5f0a2ee238a6bc",
            "sequenceNumber":"96"
        }

  - Delete:
    URL: `http://<config-service-name-or-ip>:<port>/api/subscriber/<imsi-xxx>`
    Ex: `http://<config-service-name-or-ip>:<port>/api/subscriber/<imsi-208014567891209>`


Device Group Configuration through REST Interface
"""""""""""""""""""""""""""""""""""""""""""""""""

.. code-block::

  - Post:
    URL: `http://<config-service-name-or-ip>:<port>/device-group/<group-name>`
    Ex: `http://config5g:8080/device-group/iot-camera`

    Request Body:
    {
        "imsis":
        [
            "123456789123456"
            "123456789123457"
            "123456789123458"
        ],
        "site-info": "menlo",
        "ip-domain-name": "pool1",
        "ip-domain-expanded":
        {
            "dnn": "internet",
            "ue-ip-pool": "10.91.0.0/16",
            "dns-primary": "8.8.8.8",
            "dns-secondary": "8.8.4.4",
            "mtu": 1460,
            "ue-dnn-qos":
            {
                "dnn-mbr-uplink": 4000000,
                "dnn-mbr-downlink": 20000000,
                "bitrate-unit": "Mbps",
                "traffic-class": "platinum"
            }
        }
    }

  - Delete
    URL: `http://<config-service-name-or-ip>:<port>/device-group/<group-name>`
    Ex: `http://config5g:8080/device-group/iot-camera`

Network Slice Configuration through REST Interface
""""""""""""""""""""""""""""""""""""""""""""""""""

.. code-block::

  - Post:
    URL: `http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>`
    Ex: `http://config5g:8080/network-slice/slice1`


    Request Body:
    {
        "slice-id":
        {
            "sst": "1",
            "sd": "010203"
        },
        "qos":
        {
            "uplink": 4000000,
            "downlink": 20000000,
            "bitrate-unit": "Mbps",
            "traffic-class": "platinum"
        },
        "site-device-group":
        [
            "iot-camera"
        ],
        "site-info":
        {
            "site-name": "menlo",
            "plmn":
            {
                "mcc": "315",
                "mnc": "010"
            },
            "gNodeBs":
            [
                {
                "name": "menlo-gnb1",
                "tac": 1
                }
            ],
            "upf":
            {
            "upf-name": "upf.menlo.aetherproject.org",
            "upf-port": 8805
            }
        },
    }

  - Delete
    URL: `http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>`
    Ex: `http://config5g:8080/network-slice/slice1`


