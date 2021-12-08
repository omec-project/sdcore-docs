..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0
.. _gNB-Simulator:

gNB Simulator
=============

Description
-----------
The gNB Sim tool simulates gNodeB and UE by generating and processing NAS and
NGAP messages for the configured UEs and call flows. The tool currently supports
simulation profiles for the following procedures,

* Registration
* UE initiated PDU Session Establishment
* UE Initiated De-registration.

It is also capable to generate and send user data packets (ICMP echo request)
and process down-link user data (ICMP echo response) over the established data
plane path (N3 Tunnel).

Configure gNB Simulator
-----------------------
* The config file for GNBSIM can be found at *<repo dir>/config/gnbsim.yaml*

    *Note: The configuration has following major fields (Read the comments in the config file for more details)*

    * **gnbs**: List of gNB's to be simulated. Each item in the list holds configuration specific to a gNB.
    * **profiles**: List of test/simulation profiles. Each item in the list holds configuration specific to a profile.

* Enable or disable a specific profile using the **enable** field.

    *Note: Currently following profiles are supported*

    * **register**: Registration procedure
    * **pdusessest** (Default): Registration + UE initiated PDU Session Establishment + User Data packets
    * **deregister**: Registration + UE initiated PDU Session Establishment + User Data packets + Deregister

Build gNB Simulator
-------------------
* To modify gNB Sim within a container run

    .. code-block:: bash

        $ kubectl exec -it gnbsim-0 -n omec bash

    Make required changes and run

    .. code-block:: bash

        $ go build

* To modify gNB Sim and build a new docker image

    .. code-block:: bash

        $ cd <repo dir>
        $ make docker-build

    Use newly created image in the AIAB cluster run,

    .. code-block:: bash

        $ cd <aiab repo dir>
        $ make reset-5g-test

    Modify the override file (ransim-values.yaml) to add the new image name

    .. code-block:: bash

        $ make 5gc

Run gNB Sim
-----------

    Enter into the gNB Sim pod by running

    .. code-block:: bash

        $ kubectl exec -it gnbsim-0 -n omec bash

    After entering the pod run,

    .. code-block:: bash

        $ ./gnbsim

    *Note: By default, the gNB Sim reads the configuration from /free5gc/config/gnb.conf file. To provide a different configuration file,
    use the below command*

    .. code-block:: bash

        $ ./gnbsim --cfg config/gnbsim.yaml
