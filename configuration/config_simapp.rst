..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Configuration using Simapp interface
====================================

Easiest way to configure SD-Core is to use simapp. Simapp is the POD which takes
yaml configuration and configures the subscribers, device groups, network slices

Simapp Initial Configuration Helm Values
----------------------------------------

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
            - ueId-start: "208014567891201"
              ueId-end: "208014567891205"
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
                - "208014567891203"
                - "208014567891204"
                - "208014567891205"
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

.. note::
    Simapp takes initial configuration through helm chart. Above yaml files is initial config.
    Operator can add multiple devices, device groups & slices in the initial config.

Configuration Modification through Simapp interface
---------------------------------------------------

Adding new subscribers
"""""""""""""""""""""""

If 5G core is already started and subscriber needs to be added in the 5G-Core then do the following,

Run the command -  ``kubectl edit configmap simapp -n <namespace>`` and update subscribers section.
Once config is updated then save the
file and exit from the file. Subscribers will get added within 60 seconds. In below we are updating
ueId-end from 208014567891205 to 208014567891210. This will add 5 new subscribers.

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
            - ueId-start: "208014567891201"
              ueId-end: "208014567891210"
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
                - "208014567891203"
                - "208014567891204"
                - "208014567891205"
                - "208014567891206"
                - "208014567891207"
                - "208014567891208"
                - "208014567891209"
                - "208014567891210"
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

.. note::
        There is no need to restart simapp after configmap change. New config will be automatically
        reloaded and updated configuration is passed to SD-Core.

Deleting subscribers
""""""""""""""""""""

If 5G core is already started and subscriber needs to be removed in the 5G-Core then do the following,

Run the command -  ``kubectl edit configmap simapp -n <namespace>`` and update subscribers section.
Once config is updated then save the file and exit from the file. Subscribers will get added within
60 seconds. In below we are updating ueId-end from 208014567891210 to 208014567891208. This will
remove 2 subscribers from 5G core.

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
            - ueId-start: "208014567891201"
              ueId-end: "208014567891208"
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
                - "208014567891203"
                - "208014567891204"
                - "208014567891205"
                - "208014567891206"
                - "208014567891207"
                - "208014567891208"
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

Adding subscribers with multiple subscriber ranges
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

If 5G core is already started and subscriber needs to be added in the 5G-Core then do the following,

Run the command -  ``kubectl edit configmap simapp -n <namespace>`` and update subscribers section.
Once config is updated then save the file and exit from the file. Subscribers will get added within 60 seconds.
In below we are adding new subscriber range 208014567891216 to 208014567891220. This will add 5 new subscribers.
If you have multiple ranges with different key & opc values then adding multiple subscriber blocks helps.


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
            - ueId-start: "208014567891201"
              ueId-end: "208014567891205"
              plmnId: 20801
              opc: "d4416644f6154936193433dd20a0ace0"
              op: ""
              key: "465b5ce8b199b49faa5f0a2ee238a6bc"
              sequenceNumber: 96
            - ueId-start: "208014567891216"
              ueId-end: "208014567891220"
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
                - "208014567891203"
                - "208014567891204"
                - "208014567891205"
                - "208014567891216"
                - "208014567891217"
                - "208014567891218"
                - "208014567891219"
                - "208014567891220"
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

Updating QoS Values for subscribers
"""""""""""""""""""""""""""""""""""

Run the command -  ``kubectl edit configmap simapp -n <namespace>`` and update QoS values mentioned in ip domain.
Config snippet is provided below.

.. code-block::

                ue-dnn-qos:
                  dnn-mbr-downlink: 20000000
                  dnn-mbr-uplink: 4000000
                  bitrate-unit: bps

.. note::
        If subscriber QoS is changed and if subscriber is already connected to the network then new values
        are not used for already connected subscribers. To use new QoS rates, subscriber needs to be
        disconnected and reconnected.
