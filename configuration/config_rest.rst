..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Configuration using REST Interface
==================================

You can use any tool to generate REST messages to configure SD-Core with
subscribers, device groups, and network slices.


Subscriber Configuration
""""""""""""""""""""""""

The example below configures subscriber ``208014567891209`` in SD-Core. You can configure
any number of subscribers using these APIs. SD-Core automatically configures the Network
Function responsible for authentication with the provided details.

**POST Request** - Add a subscriber:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/api/subscriber/<imsi-xxx>
   Example: http://<config-service-name-or-ip>:<port>/api/subscriber/imsi-208014567891209

**Request Body:**

.. code-block:: json

   {
       "UeId": "208014567891209",
       "plmnId": "20801",
       "opc": "d4416644f6154936193433dd20a0ace0",
       "key": "465b5ce8b199b49faa5f0a2ee238a6bc",
       "sequenceNumber": "96"
   }

**DELETE Request** - Remove a subscriber:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/api/subscriber/<imsi-xxx>
   Example: http://<config-service-name-or-ip>:<port>/api/subscriber/imsi-208014567891209

Device Group Configuration
""""""""""""""""""""""""""

The example below groups multiple IMSIs under one IP domain. The IP domain corresponds
to APN in 4G and DNN in 5G. This configuration includes the UE IP pool and QoS settings
for all users in this group.

**POST Request** - Create a device group:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/device-group/<group-name>
   Example: http://config5g:8080/device-group/iot-camera

**Request Body:**

.. code-block:: json

   {
       "imsis": [
           "123456789123456",
           "123456789123457",
           "123456789123458"
       ],
       "site-info": "menlo",
       "ip-domain-name": "pool1",
       "ip-domain-expanded": {
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

**DELETE Request** - Remove a device group:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/device-group/<group-name>
   Example: http://config5g:8080/device-group/iot-camera

.. note::
   REST API supports the PUT method to modify or replace device group configuration.
   IMSIs can be added or removed using the PUT method.

.. note::
   If UPF is configured to allocate UE addresses, you must add the address pool
   configuration to the UPF deployment, even if you have already specified the UE
   address pool in the slice configuration.


Network Slice Configuration
"""""""""""""""""""""""""""

The example below creates a network slice with a set of eNBs/gNBs, UPF, and device groups.

**POST Request** - Create a network slice:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>
   Example: http://config5g:8080/network-slice/slice1

**Request Body:**

.. code-block:: json

   {
       "slice-id": {
           "sst": "1",
           "sd": "010203"
       },
       "qos": {
           "uplink": 4000000,
           "downlink": 20000000,
           "bitrate-unit": "Mbps",
           "traffic-class": {
               "qci": 9,
               "arp": 1,
               "pdb": 2,
               "pelr": 1,
               "name": "platinum"
           }
       },
       "site-device-group": [
           "iot-camera"
       ],
       "site-info": {
           "site-name": "menlo",
           "plmn": {
               "mcc": "315",
               "mnc": "010"
           },
           "gNodeBs": [
               {
                   "name": "menlo-gnb1",
                   "tac": 1
               }
           ],
           "upf": {
               "upf-name": "upf.menlo.aetherproject.org",
               "upf-port": 8805
           }
       }
   }

**DELETE Request** - Remove a network slice:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>
   Example: http://config5g:8080/network-slice/slice1

.. note::
   Each slice must have a single UPF. Multiple UPFs cannot be added to a single slice.
   One or more access nodes can be added to a slice. Currently, SD-Core does not validate
   access nodes connecting to MME/AMF, but TAC and PLMN validation is performed in the
   core network.

Network Slice with Application Filtering Configuration
\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"

The example below creates a network slice with application filtering enabled.
This configuration restricts traffic to only allow a single application hosted
at address ``10.91.1.3``.

**POST Request** - Create a network slice with application filtering:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>
   Example: http://config5g:8080/network-slice/slice1

**Request Body:**

.. code-block:: json

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
               "rule-name": "rule-1",
               "priority": 5,
               "action": "permit",
               "endpoint": "10.91.1.3",
               "traffic-class":
               {
                   "name": "platinum",
                   "qci": 9,
                   "arp": 125,
                   "pdb": 300,
                   "pelr": 6
               }
           }
       ]
   }

**DELETE Request** - Remove a network slice:

.. code-block:: text

   URL: http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>
   Example: http://config5g:8080/network-slice/slice1


.. note::
   ROC (Runtime Operational Controller) uses these REST APIs to configure SD-Core. ROC provides
   a user-friendly web portal to manage network slices and devices. For more information,
   refer to the `Aether documentation <https://docs.aetherproject.org/>`_.
