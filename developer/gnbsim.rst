..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0
.. _gNB-Simulator:

gNBSim Usage
=============

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
* NW triggered de-registration
* UE Requested PDU Session Release
* NW triggered PDU Session Release

It is also capable to generate and send user data packets (ICMP echo request)
and process down-link user data (ICMP echo response) over the established data
plane path (N3 Tunnel).

gNBSim Code References
----------------------

* Code Repository: `github repository <https://github.com/omec-project/gnbsim>`_
* Helm Chart: `gerrit repository <https://gerrit.opencord.org/plugins/gitiles/sdcore-helm-charts/+/refs/heads/master/5g-ran-sim/>`_
* RAN SIM Helm Chart: `5g-ran-sim repository <https://charts.aetherproject.org>`_


Configure gNBSim
-----------------
* The sample config file for gNBSim can be found `here <https://github.com/omec-project/gnbsim/blob/main/config/gnbsim.yaml>`_

    *Note: The configuration has following major fields (Read the comments in
    the config file for more details)*

    * **gnbs**:
        List of gNB's to be simulated. Each item in the list holds configuration
        specific to a gNB.
    * **profiles**:
        List of test/simulation profiles. Each item in the list holds
        configuration specific to a profile.
    * **customProfiles**:
        List of custom profiles. Each item in the list holds
        configuration specific to a customProfile.

* Enable or disable a specific profile using the `enable` field within profile block.
    Note: Currently following profiles are supported


Run gNBSim
-----------

* To quickly launch and test AiaB with 5G SD-CORE using gNBSim:

    .. code-block:: bash

        $ make 5g-test

    (refer AiaB documentation :ref:`aiab5g-guide`)

* Alternatively, you can do following
    running:

    .. code-block:: bash

        $ make 5g-core

* Once all PODs are up then you can enter into the gNBSim pod by running

    .. code-block:: bash

        $ kubectl exec -it gnbsim-0 -n omec bash

* Then run following command to launch gNBSim profiles:

    .. code-block:: bash

        $ ./gnbsim

    *Note: By default, the gNB Sim reads the configuration from
    /gnbsim/config/gnb.conf file. To provide a different configuration file, use
    the below command*

    .. code-block:: bash

        $ ./gnbsim --cfg <config file path>

Build gNBSim
------------

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

    (refer AiaB documentation :ref:`aiab5g-guide`)


gNBSim System level features
----------------------------

* Logging summary result

* HTTP API to create new profile. Below configuration enables http server in gNBSim.
  Example to use gNBSim can be found `script <https://github.com/omec-project/gnbsim/blob/main/scripts/create-new-profile.sh>`_

    .. code-block:: bash

      config:
        gnbsim:
          httpServer:
            enable: true #enable httpServer in gnbsim
            port: 6000

* Gnbsim can generate and send user data packets (ICMP echo request)
  and process downlink user data (ICMP echo response) over the established data
  plane path (N3 Tunnel). Configure number of data packets to be sent. Configure
  AS (Application Server) address. This is used to send data packets.

    .. code-block:: bash

      - profileType: nwtriggeruedereg # profile type
        profileName: profile6 # uniqely identifies a profile within application
        enable: false # Set true to execute the profile, false otherwise.
        gnbName: gnb1 # gNB to be used for this profile
        startImsi: 208930100007497 # First IMSI. Subsequent values will be used if ueCount is more than 1
        ueCount: 1 # Number of UEs for for which the profile will be executed
        defaultAs: "192.168.250.1" #default icmp pkt destination
        perUserTimeout: 10 #if no expected event received in this time then treat it as failure


* Executing all enabled profiles in parallel or in sequential order.

    .. code-block:: bash

       config:
         gnbsim:
           yamlCfgFiles:
             gnb.conf:
               configuration:
                   execInParallel: false #run all profiles in parallel

.. note::
  There is execInParallel option under each profile as well. execInParallel under profile means that all the
  subscribers in the profile are run in parallel

* Timeout for each call flow within profile

    .. code-block:: bash

       - profileType: nwtriggeruedereg # profile type
         profileName: profile6 # uniqely identifies a profile within application
         perUserTimeout: 10 #if no expected event received in this time then treat it as failure

* Getting gNBSim golang profile

    .. code-block:: bash

       config:
         gnbsim:
           goProfile:
             enable: true #enable/disable golang profile in gnbsim
             port: 5000

* Run gNBSim with single Interface or multi interface

    .. code-block:: bash

       config:
         gnbsim:
           yamlCfgFiles:
             gnb.conf:
               configuration:
                   singleInterface: false #default false i.e. multiInterface. Works well for AIAB

* Support of Custom Profiles: User can now define your own profile. New profile can be
  created by using existing baseline procedure. Example of custom profile can be found here.
  Check customProfiles in `gNBSim config <https://github.com/omec-project/gnbsim/blob/main/config/gnbsim.yaml>_`

    .. code-block:: bash

       customProfiles:
         customProfiles1:
           profileType: custom # profile type
           profileName: custom1 # uniqely identifies a profile within application
           enable: false # Set true to execute the profile, false otherwise.
           execInParallel: false #run all subscribers in parallel
           stepTrigger: true #wait for trigger to move to next step
           gnbName: gnb1 # gNB to be used for this profile
           startImsi: 208930100007487
           ueCount: 5
           defaultAs: "192.168.250.1" #default icmp pkt destination
           opc: "981d464c7c52eb6e5036234984ad0bcf"
           key: "5122250214c33e723a5dd523fc145fc0"
           sequenceNumber: "16f3b3f70fc2"
           plmnId: # Public Land Mobile Network ID, <PLMN ID> = <MCC><MNC>
             mcc: 208 # Mobile Country Code (3 digits string, digit: 0~9)
             mnc: 93 # Mobile Network Code (2 or 3 digits string, digit: 0~9)
           startiteration: iteration1
           iterations:
             #at max 7 actions
             - "name": "iteration1"
               "1": "REGISTRATION-PROCEDURE 5"
               "2": "PDU-SESSION-ESTABLISHMENT-PROCEDURE 5"  #5 second delay after this procedure
               "3": "USER-DATA-PACKET-GENERATION-PROCEDURE 10"
               "next":  "iteration2"
             - "name": "iteration2"
               "1": "AN-RELEASE-PROCEDURE 100"
               "2": "UE-TRIGGERED-SERVICE-REQUEST-PROCEDURE 10"
               "repeat": 5
               "next":  "iteration3"
             - "name": "iteration3"
               "1": "UE-INITIATED-DEREGISTRATION-PROCEDURE 10"
               #"repeat": 0 #default value 0 . i.e execute once
               #"next":  "quit" #default value quit. i.e. no further iteration to run

* Support of Multiple gNBs: Two gnbs are configured by default. So User can create profiles by using these gnbs.
  Configuration of two gNBs can be found here

     .. code-block:: bash

        gnb:
          ips:
          - '"192.168.251.5/24"' #gnb1 IP
          - '"192.168.251.6/32"' #gnb2 IP
        configuration:
          runConfigProfilesAtStart: true
          singleInterface: #this will be added through configmap script
          execInParallel: false #run all profiles in parallel
          gnbs: # pool of gNodeBs
            gnb1:
              n2IpAddr: # gNB N2 interface IP address used to connect to AMF
              n2Port: 9487 # gNB N2 Port used to connect to AMF
              n3IpAddr: 192.168.251.5 # gNB N3 interface IP address used to connect to UPF
              n3Port: 2152 # gNB N3 Port used to connect to UPF
              name: gnb1 # gNB name that uniquely identify a gNB within application
              globalRanId:
                plmnId:
                  mcc: 208 # Mobile Country Code (3 digits string, digit: 0~9)
                  mnc: 93 # Mobile Network Code (2 or 3 digits string, digit: 0~9)
                gNbId:
                  bitLength: 24
                  gNBValue: "000102" # gNB identifier (3 bytes hex string, range: 000000~FFFFFF)
              supportedTaList:
              - tac: "000001" # Tracking Area Code (3 bytes hex string, range: 000000~FFFFFF)
                broadcastPlmnList:
                  - plmnId:
                      mcc: 208
                      mnc: 93
                    taiSliceSupportList:
                        - sst: 1 # Slice/Service Type (uinteger, range: 0~255)
                          sd: "010203" # Slice Differentiator (3 bytes hex string, range: 000000~FFFFFF)
              defaultAmf:
                hostName: amf # Host name of AMF
                ipAddr: # AMF IP address
                port: 38412 # AMF port
            gnb2:
              n2IpAddr: # gNB N2 interface IP address used to connect to AMF
              n2Port: 9488 # gNB N2 Port used to connect to AMF
              n3IpAddr: 192.168.251.6 # gNB N3 interface IP address used to connect to UPF
              n3Port: 2152 # gNB N3 Port used to connect to UPF
              name: gnb2 # gNB name that uniquely identify a gNB within application
              globalRanId:
                plmnId:
                  mcc: 208 # Mobile Country Code (3 digits string, digit: 0~9)
                  mnc: 93 # Mobile Network Code (2 or 3 digits string, digit: 0~9)
                gNbId:
                  bitLength: 24
                  gNBValue: "000112" # gNB identifier (3 bytes hex string, range: 000000~FFFFFF)
              supportedTaList:
              - tac: "000001" # Tracking Area Code (3 bytes hex string, range: 000000~FFFFFF)
                broadcastPlmnList:
                  - plmnId:
                      mcc: 208
                      mnc: 93
                    taiSliceSupportList:
                        - sst: 1 # Slice/Service Type (uinteger, range: 0~255)
                          sd: "010203" # Slice Differentiator (3 bytes hex string, range: 000000~FFFFFF)
              defaultAmf:
                hostName: amf # Host name of AMF
                ipAddr: # AMF IP address
                port: 38412 # AMF port

* Delay between Procedures can be added using customProfiles.
