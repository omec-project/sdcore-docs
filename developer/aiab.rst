..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _aiab-guide:

================
Aether In a Box
================

Setting Up Aether-in-a-Box
__________________________

Aether-in-a-Box (AiaB) provides an easy way to deploy Aether’s SD-CORE
components and run basic tests to validate the installation. This guide
describes the steps to set up AiaB.

AiaB can be set up with a 4G or 5G SD-CORE. We use SimApp to configure
the required state in SD-CORE for testing core functionality.

Helm charts are the primary method of installing the SD-CORE resources.
AiaB offers a great deal of flexibility regarding which Helm chart
versions to install:

* Local definitions of charts (for testing Helm chart changes)
* Latest published charts (for deploying a development version of Aether)
* Specified versions of charts (for deploying a specific Aether release)

AiaB can be run on a bare metal machine or VM. System prerequisites:

* Ubuntu 18.04
* Kernel 4.15 or later
* Haswell CPU or newer

Clone Repositories
__________________

To initialize the AiaB environment, first clone the following repository using
your Gerrit ID::

    cd ~
    git clone "ssh://<username>@gerrit.opencord.org:29418/aether-in-a-box"

    mkdir -p ~/cord
    cd ~/cord
    git clone "ssh://<username>@gerrit.opencord.org:29418/sdcore-helm-charts"
    git clone "ssh://<username>@gerrit.opencord.org:29418/aether-helm-charts"

Set up Authentication Tokens
____________________________

::

    cd ~/aether-in-a-box

Edit the file configs/authentication.

Fill out REGISTRY_USERNAME and REGISTRY_CLI_SECRET as follows:

    * Log into the Aether Harbor Registry using your Crowd credentials
    * Select User Profile from the drop-down menu in the upper right corner
    * For REGISTRY_USERNAME, use the Username in your profile
    * Copy the CLI secret to the clipboard and paste to REGISTRY_CLI_SECRET

Also fill out REPO_USERNAME and REPO_PASSWORD with the information needed to
authenticate with Aether’s Helm chart repositories.

If you have already set up AiaB but you used incorrect credentials, first
clean up AiaB as described in the Cleanup section, then edit
configs/authentication and re-build AiaB.

Start the 4G SD-CORE
____________________

::

    make test

Start the 5G SD-CORE
____________________

If you have already installed the 4G SD-CORE, you must skip this step.
Only one version of the SD-CORE can be installed at a time

To deploy 5G SD-CORE::

    make 5gc

To deploy and test 5G SD-CORE::

    make 5g-test

The above step uses gNBSim to perform Registration + UE-Initiated PDU Session
Establishment + User Data Packets. To test other procedures, modify *gnb.conf*
in *ransim-values.yaml* (refer gNBSim documentation :ref:`gNB-Simulator`)

Cleanup
_______

The first time you build AiaB, it takes a while because it sets up the
Kubernetes cluster. Subsequent builds will be much faster if you follow
these steps to clean up the Helm charts without destroying the Kubernetes
cluster.::

    Clean up the 4G SD-CORE: *make reset-test
    Clean up the 5G SD-CORE: *make reset-5g-test

Developer Loop
______________

Suppose you wish to test a new build of a 5G SD-CORE services. You can deploy
custom images by editing ~/aether-in-a-box/5g-core-values.yaml, for example::

    images:
      tags:
        webui: registry.aetherproject.org/omecproject/5gc-webui:onf-release3.0.5-roc-935305f
      pullPolicy: IfNotPresent

To upgrade a running 5G SD-CORE with the new image, or to deploy the 5G SD-CORE
with the image::

    make 5gc

Troubleshooting / Known Issues
______________________________

If you suspect a problem, first verify that all pods are in Running state::

    kubectl -n omec get pods
    kubectl -n aether-roc get pods

If the pods are stuck in ImagePullBackOff state, then it’s likely an issue
with credentials. See the Set up Authentication Tokens section.

4G Test Fails
_____________

Occasionally make test (for 4G) fails for unknown reasons; this is true
regardless of which Helm charts are used. If this happens, first try
cleaning up AiaB and re-running the test. If make test fails consistently,
check whether the configuration has been pushed to the SD-CORE::

    kubectl -n omec logs config4g-0 | grep "Successfully"

You should see that a device group and slice has been pushed::

    [INFO][WebUI][CONFIG] Successfully posted message for device group 4g-oaisim-user to main config thread
    [INFO][WebUI][CONFIG] Successfully posted message for slice default to main config thread

Then tail the config4g-0 log and make sure that the configuration has been
successfully pushed to all SD-CORE components.
