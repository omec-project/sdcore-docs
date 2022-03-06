..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_4G_guide:

4G Deployment Guide
====================

Deployment Overview
-------------------
SD-Core is released with Helm chart and container images.
We recommend using **Kubernetes** and **Helm** to deploy SD-Core.
SD-Core images are hosted on an ONF member-only Docker registry.
You need to obtain access token and supply that as part of the Helm value.

Hardware resource requirement
-----------------------------

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


Deployment Options
------------------

Development Environments
""""""""""""""""""""""""
Please refer (see :ref:`aiab-guide`) to setup 4G development environment.

Production Environments - 4G
""""""""""""""""""""""""""""

To install SD-Core into your Kubernetes cluster, follow instructions

Step1 - Clone SD-Core 4G Helm chart
'''''''''''''''''''''''''''''''''''
.. code-block::

  git clone "https://gerrit.opencord.org/sdcore-helm-charts"
  cd sdcore-helm-charts/sdcore-helm-charts/
  helm dep update #Update Helm dependencies

Step2 - Prepare your Helm values for 4G
'''''''''''''''''''''''''''''''''''''''

You can modify existing values.yaml directly, but we recommend composing another value
file myvalues.yaml using values.yaml as an example. We are highlighting a few things we
need to modify here. More explanation of the supported Helm values can be found in the
Configuration section below.

Step3 - Install 4G using SD-Core umbrella helm chart
''''''''''''''''''''''''''''''''''''''''''''''''''''

The following command will deploy the SD-Core helm chart with release name sdcore-4g in the sdcore-4g namespace.

.. code-block::

    helm install -n sdcore-4g --create-namespace -f myvalues.yaml sdcore-4g ~/cord/sdcore-helm-charts/sdcore-helm-charts

To verify the installation:

.. code-block::

    helm -n sdcore-4g ls

To uninstall:

.. code-block::

    helm -n sdcore-4g uninstall sdcore-4g
    kubectl delete namespace sdcore-4g # also remove the sdcore-4g if needed
