..
   SPDX-FileCopyrightText: 2022-present Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

SD-Core
=======

The SD-Core project is a 4G/5G disaggregated mobile core optimized for public
cloud deployment in concert with distributed edge clouds. It exposes standard 3GPP interfaces
enabling use of SD-Core as a conventional mobile core. SD-Core is an integral component
of Aether, ONF’s 5G Connected Edge platform for
private mobile connectivity and edge cloud services. It can be rapidly deployed
pre-integrated with Aether, as a standalone 5G/4G mobile core, or as control and
dataplane (UPF) components integrated into custom designed solutions. This range
of versatility makes the open source SD-Core platform ideally suited for the
broadest range of use cases and deployment scenarios.

SD-Core is ideally suited for

- Small carrier
- Private enterprise 4G/5G networks
- Research community or Universities who wish to study/learn more on 3gpp 4G/5G


Getting Started with SD-Core
----------------------------
- Learn more about SD-Core

  - `SD-Core Website <https://opennetworking.org/sd-core/>`_
  - `SD-Core Whitepaper <https://opennetworking.org/wp-content/uploads/2021/07/SD-Core-Technical-White-Paper-FINAL-1.pdf>`_
  - `SD-Core Techinar <https://www.youtube.com/watch?v=-eQzbSxXgSU>`_
  - `SD-Core Wiki <https://wiki.opennetworking.org/display/COM/SD-Core>`_
  - `SD-Core Public Folder <https://drive.google.com/drive/folders/1dM5b0B65LkQQ0dGK1m-iIceRJfAASEm1>`_


Community
---------

Information about participating in the SD Core community and development process
can be found on the `SD-Core Wiki
<https://wiki.opennetworking.org/display/COM/SD-Core>`_.

- Stay in touch by joining

  - `SD-Core mailing list <https://groups.google.com/a/opennetworking.org/g/sdcore-announce>`_
  - \#sdcore-dev channel in `Aether Community Slack <https://aether5g-project.slack.com>`_


.. toctree::
   :maxdepth: 2
   :caption: Overview
   :hidden:
   :glob:

   overview/introduction.rst
   overview/architecture.rst
   overview/3gpp-compliance-5g.rst
   overview/3gpp-compliance-4g.rst
   overview/faq.rst
   glossary.rst

.. toctree::
   :maxdepth: 2
   :caption: Configuration
   :hidden:
   :glob:

   configuration/config.rst
   configuration/config_rest.rst
   configuration/config_simapp.rst
   configuration/application_filtering.rst
   configuration/qos_config.rst
   configuration/config_upf.rst

.. toctree::
   :maxdepth: 2
   :caption: Deployment
   :hidden:
   :glob:

   deployment/deployment4G.rst
   deployment/deployment5G.rst
   deployment/deploymentupf.rst
   deployment/deploymentueransim.rst

.. toctree::
   :maxdepth: 2
   :caption: Design
   :hidden:
   :glob:

   design/design-smf.rst
   design/design-amf.rst
   design/design-metricfunc.rst

.. toctree::
   :maxdepth: 2
   :caption: Developer Guide
   :hidden:
   :glob:

   developer/aiab.rst
   developer/aiab5g.rst
   developer/gnbsim.rst
   developer/rogue-subscriber.rst
   developer/auto-scaling-5g-nfs.rst

.. toctree::
   :maxdepth: 2
   :caption: Troubleshooting Guide
   :hidden:
   :glob:

   troubleshooting/flowchart.rst

.. toctree::
   :maxdepth: 3
   :caption: Test Automation
   :hidden:
   :glob:

   testing/about_system_tests
   testing/sdcore_testing
   testing/acceptance_specification

.. toctree::
   :maxdepth: 2
   :caption: Releases
   :hidden:
   :glob:

   release/1*
   release/upcoming.rst
   release/process.rst
