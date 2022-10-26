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
``````````````````````````````````````````````````````

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

Running gNBSim Standalone Application in or out of a Docker
```````````````````````````````````````````````````````````
.. image:: ../_static/images/Standalone_gnbsim_1_interface.jpg
  :width: 1000px

Note that ``DATA-IFACE`` is ens1f0, this interface to be used for both control and data traffic

We need two VMs, in this example we call one is SD-Core VM, other one is Simulator VM
  * SD-Core VM: to Deploy AIAB
  * Simulator VM: to Run gnbsim process in or out of Docker

SD-Core VM Preparation:

- To Expose External IP and Port of amf service, update sd-core-5g-values.yaml ::

     amf:
       # use externalIP if you need to access your AMF from remote setup and you don't
       # want setup NodePort Service Type
       ngapp:
         externalIp: <DATA_IFACE_IP>
         nodePort: 38412
- Deploy 5g core with options DATA_IFACE=ens1f0 and ENABLE_GNBSIM=false, sample command::

     $ ENABLE_GNBSIM=false DATA_IFACE=ens1f0 CHARTS=release-2.0 make 5g-core
- Make sure that ``DATA_IFACE`` connected  with Simulator VM

Simulator VM Preparation

- Single interface is used for user plane traffic towards UPF
- Single interface is used to send traffic towards control plane (i.e. AMF).
- Checkout gnbsim code using the following command::

     $ git clone https://github.com/omec-project/gnbsim.git
- Install 'go' if you want to run with local executable ::

     $ wget  https://go.dev/dl/go1.19.linux-amd64.tar.gz
     $ sudo tar -xvf go1.19.linux-amd64.tar.gz
     $ mv go /usr/local
     $ export PATH=$PATH:/usr/local/go/bin
- To Compile the code locally, you can use below commands::

     $ ``go build`` or ``make docker-build``
- Add following route in routing table for sending traffic over ``DATA_IFACE`` interface ::

     $ ip route add 192.168.252.3 via <DATA-IFACE-IP-IN-SD-CORE-VM>
- Just to Make sure the data connectivity, ping UPF IP from ``DATA_IFACE``::

     $ ping 192.168.252.3 -I <DATA_IFACE>
- configure correct n2 and n3 addresses in config/gnbsim.yaml ::

        configuration:
             singleInterface: false #default value
             execInParallel: false #run all profiles in parallel
             gnbs: # pool of gNodeBs
                gnb1:
                   n2IpAddr: <DATA-IFACE-IP>># gNB N2 interface IP address used to connect to AMF
                   n2Port: 9487 # gNB N2 Port used to connect to AMF
                   n3IpAddr: <DATA-IFACE-IP> # gNB N3 interface IP address used to connect to UPF. when singleInterface mode is false
                   n3Port: 2152 # gNB N3 Port used to connect to UPF
                   name: gnb1 # gNB name that uniquely identify a gNB within application
- configure AMF address or FQDN appropriately in gnbsim.yaml ::

        configuration:
             singleInterface: false #default value
             execInParallel: false #run all profiles in parallel
             gnbs: # pool of gNodeBs
               gnb1:
                defaultAmf:
                   hostName:  # Host name of AMF
                   ipAddr: <AMF-SERVICE-EXTERNAL-IP> ># AMF Service external IP address in SD-Core VM
                   port: 38412 # AMF port
- Run gnbsim application using the following command::

   $ ./gnbsim -cfg config/gnbsim.yaml
        (or)
- Install Docker and run gnbsim inside a Docker with Docker hub Image or locally created Image ::

   $ docker run --privileged -it -v ~/gnbsim/config:/gnbsim/config --net=host <Docker-Image> bash
   $ ./gnbsim -cfg config/gnbsim.yaml

Note: gnbsim docker images found at https://hub.docker.com/r/omecproject/5gc-gnbsim/tags
