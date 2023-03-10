..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _aiab-guide:

Aether In a Box - 4G
====================

The documentation for Aether In a Box (AiaB) - 4G is located in `Installing the 4G AIAB <https://docs.aetherproject.org/master/developer/aiab.html#installing-the-4g-aiab>`_,
where specifics about setting up AiaB 4G, running 4G test, troubleshooting,
and other details are described. Moreover, details about deploying AiaB
with external 4G radios are presented `Aether-in-a-Box with External 4G Radio <https://docs.aetherproject.org/master/developer/aiabhw.html>`_.

Developer Loop
______________

Suppose you wish to test a new build of a 4G SD-CORE services. You can deploy
custom images by editing ~/aether-in-a-box/sd-core-4g-values.yaml, for
example::

    images:
      tags:
        spgwc: omecproject/spgw:master-e419062

To upgrade a running 4G SD-CORE with the new image, or to redeploy the 4G
SD-CORE with the image::

    make reset-test # delete 4G deployment if it was already started before updating image
    make 4g-test  # now this deployment will use new spgwc image
