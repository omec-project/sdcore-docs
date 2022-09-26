..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _aiab5g-guide:

Aether In a Box - 5G
====================

Setting Up Aether-in-a-Box - 5G
________________________________

Aether-in-a-Box (AiaB) provides an easy way to deploy Aether’s SD-CORE
components and run basic tests to validate the installation. This guide
describes the steps to set up AiaB.

AiaB can be set up with a 4G or 5G SD-CORE. We use SimApp to configure
the required subscribers & network slices in SD-CORE for testing core
functionality.

Helm charts are the primary method of installing the SD-CORE resources.
AiaB offers a great deal of flexibility regarding which Helm chart
versions to install:

* Local definitions of charts (for testing Helm chart changes)
* Latest published charts (for deploying a development version of Aether)
* Specified versions of charts (for deploying a specific Aether release)

AiaB can be run on a bare metal machine or VM. System prerequisites:

* Ubuntu 18.04 or later
* Kernel 4.15 or later
* Haswell CPU or newer

Clone Repositories
__________________

To initialize the AiaB environment, first clone the following repository::
your Gerrit ID::

    cd ~
    git clone "https://gerrit.opencord.org/aether-in-a-box"

    mkdir -p ~/cord
    cd ~/cord
    git clone "https://gerrit.opencord.org/sdcore-helm-charts"

.. note::
    Only one version of the SD-CORE (4G or 5G) can be installed in AIAB environment
    at a time. The first time you build AiaB, it takes a while because it sets up the
    Kubernetes cluster. Subsequent builds will be much faster if you follow below steps
    to delete & redeploy SD-Core (4G/5G) without destroying the Kubernetes

Running 5G Test
________________

To deploy 5G SD-CORE using local helm charts::

    make 5g-core

To deploy and test 5G SD-CORE using local helm charts::

    make 5g-test

The above step uses gNBSim to perform Registration + UE-Initiated PDU Session
Establishment + User Data Packets. To test other procedures, modify *gnb.conf*
in *~/aether-in-a-box/sd-core-5g-values.yaml* (refer gNBSim documentation :ref:`gNB-Simulator`)

Developer Loop
______________

Suppose you wish to test a new build of a 5G SD-CORE services. You can deploy
custom images by editing ~/aether-in-a-box/sd-core-5g-values.yaml, for example::

    images:
      tags:
        webui: omecproject/5gc-webui:master-7f96cfd

To upgrade a running 5G SD-CORE with the new image, or to redeploy the 5G SD-CORE
with the image::

    make reset-5g-test # delete 5G deployment if it was already started before updating image
    make 5g-core  #now this deployment will use new webui image

Troubleshooting / Known Issues
______________________________

Deployment Status
""""""""""""""""""
If you suspect a problem, first verify that all pods are in Running state::

    kubectl -n omec get pods

If the pods are stuck in ImagePullBackOff state, then it’s likely an issue
with image name.

Test Failure
""""""""""""

If make 5g-test fails consistently, then try to debug the issue by looking
at logs at amf, smf.
