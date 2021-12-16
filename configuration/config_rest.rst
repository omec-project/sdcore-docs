..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Configuration using REST Interface
==================================

You can decide to use any other tool to generate REST messages towards SD-Core to configure
subscribers, device groups and network slice


Subscriber Configuration
""""""""""""""""""""""""

Below example configures subscriber `208014567891209` in the SD-Core. You can any
number of subscribers using these APIs. SD-Core takes care of configuring Network
Function responsible for authentication with the below details.

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

Device Group Configuration
""""""""""""""""""""""""""
Below example groups multiple IMSIs under one IP domain. IP domain is close
match with APN in 4G & dnn in case of 5G. Along with UE IP pool, there is
also configuration of QoS for the users in this group.

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
                "traffic-class":
                {
                    "qci": 9,
                    "arp": 1,
                    "pdb": 2,
                    "pelr": 1,
                    "name": "platinum"
                }
            }
        }
    }

  - Delete
    URL: `http://<config-service-name-or-ip>:<port>/device-group/<group-name>`
    Ex: `http://config5g:8080/device-group/iot-camera`


.. note::
    REST API can use PUT Method to modify/replace the device group configuration.
    IMSIs can be added, removed through PUT Method.

Network Slice Configuration
"""""""""""""""""""""""""""
Below example creates Network Slice with set of eNBs, UPF and device groups.

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
            "traffic-class":
            {
                "qci": 9,
                "arp": 1,
                "pdb": 2,
                "pelr": 1,
                "name": "platinum"
            }
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

.. note::
   Slice needs to have single UPF. Multiple UPFs can not be added in single Slice. One or more access
   nodes can be added in slice. For now SD-Core does not do any validation of access nodes connecting
   to MME/AMF, but TAC & PLMN validation is done in Core Network.

Network Slice + Application filtering Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""
Below example creates Network Slice with set of eNBs, UPF and device groups.
Note that this slice only allows traffic to single application hosted at
address 10.91.1.3
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
            "traffic-class":
            {
                "qci": 9,
                "arp": 1,
                "pdb": 2,
                "pelr": 1,
                "name": "platinum"
            }
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
        "application-filtering-rules":
          [
             {
                "rule-name": rule-1,
                "priority": 5,
                "action" : permit,
                "endpoint": "10.91.1.3",
                "traffic-class":
                {
                  "name": “platinum”,
                  "qci": 9,
                  "arp": 125,
                  "pdb": 300,
                  "pelr": 6
                }
            }
          ]
    }

  - Delete
    URL: `http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>`
    Ex: `http://config5g:8080/network-slice/slice1`


.. note::
    ROC uses REST APIs to configure SD-Core. ROC provides nice web portal to manage network slices and devices.
    `Refer Aether document <https://docs.aetherproject.org/>`_.
