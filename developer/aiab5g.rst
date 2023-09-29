..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _aiab5g-guide:

Aether In a Box - 5G
====================

The documentation for Aether In a Box (AiaB) - 5G is located in `Aether OnRamp <https://docs.aetherproject.org/master/onramp/overview.html>`_,
where specifics about setting up AiaB 5G, running 5G test, troubleshooting,
and other details are described.

Developer Loop
______________

Suppose you wish to test a new build of a 5G SD-CORE services. You can deploy
custom images by editing ~/aether-in-a-box/sd-core-5g-values.yaml, for
example::

    images:
      tags:
        webui: omecproject/5gc-webui:master-7f96cfd

To upgrade a running 5G SD-CORE with the new image, or to redeploy the 5G
SD-CORE with the image::

    make reset-5g-test # delete 5G deployment if it was already started before updating image
    make 5g-core  # now this deployment will use new webui image
