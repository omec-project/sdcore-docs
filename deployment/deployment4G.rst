..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_4G_guide:

4G Deployment Guide
====================

Deployment Overview
-------------------

SD-Core is released with Helm charts and container images. We recommend using
**Kubernetes** and **Helm** to deploy SD-Core. All SD-Core container images are
hosted on Docker Hub.

Hardware Resource Requirements
------------------------------

.. list-table:: CPU & Memory Requirements for 4G components
  :widths: 5 5 5
  :header-rows: 1

  * - SD-Core Component
    - Required CPU
    - Required Memory in Gi
  * - MME
    - 2 CPU Cores
    - 2Gi
  * - SPGW
    - 2 CPU Cores
    - 5Gi
  * - PCRF
    - 2 CPU Cores
    - 1Gi
  * - HSS
    - 2 CPU Cores
    - 1Gi
  * - Config4G
    - 1 CPU Cores
    - 1Gi
  * - SimApp
    - 1 CPU Cores
    - 1Gi
  * - Cassandra
    - 2 CPU Cores
    - 4Gi

.. note::
   SD-Core deployment is tested on Intel/AMD hardware. There is WIP to run SD-Core
   on ARM architecture.

Deployment Options
------------------

Development Environments
""""""""""""""""""""""""

For setting up a 4G development environment, please refer to the
:ref:`aiab-guide` (Aether-in-a-Box guide).

Production Environments - 4G
""""""""""""""""""""""""""""

To install SD-Core into your Kubernetes cluster, follow these steps:

Step 1: Clone SD-Core 4G Helm Chart
''''''''''''''''''''''''''''''''''''

Clone the repository and update dependencies:

.. code-block:: bash

   git clone https://github.com/omec-project/sdcore-helm-charts.git
   cd sdcore-helm-charts/sdcore-helm-charts/
   helm dep update  # Update Helm dependencies

Step 2: Prepare Your Helm Values for 4G
''''''''''''''''''''''''''''''''''''''''

While you can modify the existing ``values.yaml`` directly, we recommend creating a
separate values file (e.g., ``myvalues.yaml``) using ``values.yaml`` as a template.
This approach makes it easier to track your customizations and upgrade in the future.

For detailed explanations of the supported Helm values, refer to the Configuration
section below.

Step 3: Install 4G Using SD-Core Umbrella Helm Chart
'''''''''''''''''''''''''''''''''''''''''''''''''''''

The following command deploys the SD-Core Helm chart with release name ``sdcore-4g``
in the ``sdcore-4g`` namespace:

.. code-block:: bash

   helm install -n sdcore-4g --create-namespace -f myvalues.yaml sdcore-4g \
     ./sdcore-helm-charts

.. note::
   Adjust the chart path (``./sdcore-helm-charts``) to match your local directory structure where you cloned the sdcore-helm-charts repository.

**Verify the Installation**

Check the Helm release status:

.. code-block:: bash

   helm -n sdcore-4g ls

**Uninstall SD-Core**

To uninstall the SD-Core deployment:

.. code-block:: bash

   helm -n sdcore-4g uninstall sdcore-4g
   kubectl delete namespace sdcore-4g  # Optional: remove the namespace
