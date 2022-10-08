..
   SPDX-FileCopyrightText: © 2022 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_gnbsim_guide:

gNBSim Deployment Guide
========================

gNBSim in AIAB mode with 2 interfaces
```````````````````````````````````````

- This is default mode of deployment for gNB Simulator
- Multus cni needs to be enabled on cluster. Required for bess-upf & gNBSim
- `make 5gc` will by default deploy gNB Simulator in this mode
- One interface is used for user plane traffic towards UPF
- Second interface is used to send traffic towards control plane (i.e. AMF).
- UPF network & default gateway is provided in the override values.
- Route to UPF network is added when POD comes up
- defaultAs is configured per profile. This address is used to send data traffic during test

.. note::
   Multiple gNB's in one simulator instance need more changes in helm chart. This is pending work.

To add UPF routes. Following is example of override values ::

  config:
    gnbsim:
      gnb:
        ip: 192.168.251.5/24 #user plane IP at gnb if 2 separate interface provided
      singleInterface: false
      networkTopo:
        - upfAddr: "192.168.252.3/32"
          upfGw: "192.168.251.1"


.. image:: ../_static/images/Single-cluster_2_interface.jpg
  :width: 700px

gNB simulator running standalone with single interface
```````````````````````````````````````````````````````

- Install gNB Simulator on any K8s cluster
- Multus cni needs to be enabled for the K8s cluster where bess-upf runs
- Make sure gNB Simulator can communicate with AMF & UPF
- *TODO* - New Makefile target will deploy just 5G control plane
- *TODO* - New Makefile target will deploy only gNB Simulator
- Single interface is used for user plane traffic towards UPF & as well traffic towards AMF
- defaultAs is configured per profile. This address is used to send data traffic during test
- configure AMF address or FQDN appropriately

.. note::
  Multiple gNB's can not be simulated since only 1 gNB will be able to use 2152 port


Following is example of override values ::

  config:
    gnbsim:
      singleInterface: true
      yamlCfgFiles:
        gnb.conf:
          configuration:
             gnbs: # pool of gNodeBs
               gnb1:
                 n3IpAddr: "POD_IP" # set if singleInterface is true

.. image:: ../_static/images/Separate-cluster_Single_interface.jpg
  :width: 700px

gNBSim running standalone with 2 or more interfaces
```````````````````````````````````````````````````

- Install gNB Simulator on any K8s cluster
- Multus cni needs to be enabled on cluster. Required for bess-upf & gNB
- Make sure gNB Simulator can communicate with AMF & UPF
- *TODO* - New Makefile target will deploy just 5G control plane
- *TODO* - New Makefile target will deploy only gNB Simulator
- One interface is used for user plane traffic towards UPF
- Second interface is used to send traffic towards control plane (i.e. AMF).
- UPF network & default gateway is provided in the override values.
- Route to UPF network is added when POD comes up
- defaultAs is configured per profile. This address is used to send data traffic during test
- configure AMF address or FQDN appropriately

.. note::
   Multiple gNB's in one simulator instance need more changes in helm chart. This is pending work.


To add UPF routes. Following is example of override values ::

  config:
    gnbsim:
      gnb:
        ip: 192.168.251.5/24 #user plane IP at gnb if 2 separate interface provided
      singleInterface: false
      networkTopo:
        - upfAddr: "192.168.252.3/32"
          upfGw: "192.168.251.1"

.. image:: ../_static/images/Separate-cluster_2_interface.jpg
  :width: 700px
