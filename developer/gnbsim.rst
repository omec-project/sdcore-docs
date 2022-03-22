..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0
.. _gNB-Simulator:

gNB Simulator Deployment
========================

gNB Simulator can be deployed in following modes,

**gNB simulator in AIAB mode with 2 interfaces:**
-------------------------------------------------

- This is default mode of deployment for gNB Simulator
- Multus cni needs to be enabled on cluster. Required for bess-upf & gNB
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

**gNB simulator running standalone with 2 or more interfaces**
--------------------------------------------------------------

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


**gNB simulator running standalone with single interface**
----------------------------------------------------------

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

Description
-----------
The gNBSim tool simulates gNodeB and UE by generating and processing NAS and
NGAP messages for the configured UEs and call flows. The tool currently supports
simulation profiles for the following procedures,

* Registration
* UE Initiated PDU Session Establishment
* UE Initiated De-registration.
* AN Release
* Ue Initiated Service Request Procedure

It is also capable to generate and send user data packets (ICMP echo request)
and process down-link user data (ICMP echo response) over the established data
plane path (N3 Tunnel).


Configure gNBSim
-----------------------
* The config file for gNBSim can be found at *<repo dir>/config/gnbsim.yaml*

    *Note: The configuration has following major fields (Read the comments in
    the config file for more details)*

    * **gnbs**:
        List of gNB's to be simulated. Each item in the list holds configuration
        specific to a gNB.
    * **profiles**:
        List of test/simulation profiles. Each item in the list holds
        configuration specific to a profile.

* Enable or disable a specific profile using the **enable** field.

    *Note: Currently following profiles are supported*

    * **register**:
        Registration procedure
    * **pdusessest** (Default):
        Registration + UE initiated PDU Session Establishment + User Data packets
    * **deregister**:
        Registration + UE initiated PDU Session Establishment + User Data packets
        + Deregister
    * **anrelease**:
        Registration + UE initiated PDU Session Establishment + User Data packets
        + AN Release
    * **uetriggservicereq**:
        Registration + UE initiated PDU Session Establishment + User Data packets
        + AN Release + UE Initiated Service Request

Run gNBSim
-----------
* To quickly launch and test AiaB with 5G SD-CORE using gNBSim:

    .. code-block:: bash

        $ make 5g-test

    (refer AiaB documentation :ref:`aiab-guide`)

* Alternatively, once 5G SD-CORE is up, you can enter into the gNBSim pod by
    running:

    .. code-block:: bash

        $ kubectl exec -it gnbsim-0 -n omec bash

    Then run following command to launch gNBSim:

    .. code-block:: bash

        $ ./gnbsim

    *Note: By default, the gNB Sim reads the configuration from
    /gnbsim/config/gnb.conf file. To provide a different configuration file, use
    the below command*

    .. code-block:: bash

        $ ./gnbsim --cfg <config file path>

Build gNBSim
-------------------

* If you find a need to change gNBSim code and use the updated image in the AIAB setup then
  follow below steps.

* To modify gNBSim and build a new docker image:

    .. code-block:: bash

        $ git clone https://github.com/omec-project/gnbsim.git
        $ cd gnbsim
        $ make docker-build  #requires golang installed on the machine

* To use newly created image in the AiaB cluster:

Update *~/aether-in-box/sd-core-5g-values.yaml* to point to the newly built image, then run:

    .. code-block:: bash

        $ cd ~/aether-in-a-box/
        $ make reset-5g-test


    .. code-block:: bash

        $ make 5g-test

    (refer AiaB documentation :ref:`aiab-guide`)


