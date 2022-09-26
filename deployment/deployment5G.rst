..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_5G_guide:

5G Deployment Guide
===================

Deployment Overview
-------------------
SD-Core is released with Helm chart and container images.
We recommend using **Kubernetes** and **Helm** to deploy SD-Core.
SD-Core images are hosted on docker hub.

Hardware resource requirement
-----------------------------

.. list-table:: CPU & Memory Requirements for 5G components
  :widths: 5 5 5
  :header-rows: 1

  * - SD-Core Component
    - Required CPU
    - Required Memory in Gi
  * - AMF
    - 2 CPU Cores
    - 4Gi
  * - SMF
    - 2 CPU Cores
    - 4Gi
  * - NRF
    - 2 CPU Cores
    - 1Gi
  * - NSSF
    - 2 CPU Cores
    - 1Gi
  * - AUSF
    - 1 CPU Cores
    - 1Gi
  * - PCF
    - 1 CPU Cores
    - 1Gi
  * - UDR
    - 2 CPU Cores
    - 1Gi
  * - UDM
    - 2 CPU Cores
    - 1Gi
  * - Config5G(webconsole)
    - 1 CPU Cores
    - 1Gi
  * - SimApp
    - 1 CPU Cores
    - 1Gi
  * - MongoDB
    - 2 CPU Cores
    - 4Gi


.. note::
   SD-Core deployment is tested on Intel/AMD hardware. There is WIP to run SD-Core
   on ARM architecture.

Deployment Options
------------------

Development Environments
""""""""""""""""""""""""

Please refer (see :ref:`aiab-guide`) to setup 5G development environment.

Production Environments - 5G
""""""""""""""""""""""""""""

To install SD-Core into your Kubernetes cluster, follow instructions

Step1 - Clone SD-Core 5G Helm chart
'''''''''''''''''''''''''''''''''''
.. code-block::

  git clone "https://gerrit.opencord.org/sdcore-helm-charts"
  cd sdcore-helm-charts/sdcore-helm-charts/
  helm dep update #Update Helm dependencies

Step2 - Prepare your Helm value for 5G
''''''''''''''''''''''''''''''''''''''

You can modify existing values.yaml directly, but we recommend composing another value
file myvalues.yaml using values.yaml as an example. We are highlighting a few things we
need to modify here. More explanation of the supported Helm values can be found in the
Configuration section below.

Step3 - Install 5G using SD-Core umbrella helm chart
''''''''''''''''''''''''''''''''''''''''''''''''''''

The following command will deploy the SD-Core helm chart with release name sdcore-5g in the sdcore-5g namespace.

.. code-block::

    helm install -n sdcore-5g --create-namespace -f myvalues.yaml sdcore-5g  ~/cord/sdcore-helm-charts/sdcore-helm-charts

To verify the installation:

.. code-block::

    helm -n sdcore-5g ls
    ajayonf@node:~$ helm -n sdcore-5g ls
    NAME     	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART         	APP VERSION
    sdcore-5g	sdcore-5g	1       	2022-03-05 16:25:32.338495035 -0700 MST	deployed	sd-core-0.10.9
    ajayonf@node:~$

    ajayonf@node:~$ kubectl get pods -n sdcore-5g
    NAME                       READY   STATUS    RESTARTS   AGE
    amf-66bf99c879-5x4ms       1/1     Running   0          3m23s
    ausf-65dc454b79-jp2cb      1/1     Running   0          3m23s
    mongodb-6df94d8dd9-h8p4w   1/1     Running   0          3m23s
    nrf-65bcfbb496-xvt6t       1/1     Running   0          3m23s
    nssf-6f58859d67-552l2      1/1     Running   0          3m23s
    pcf-5b4c75f57d-sl5rh       1/1     Running   0          3m23s
    simapp-d8994999d-98k6v     1/1     Running   0          3m23s
    smf-77c89ccc6d-4d8g2       1/1     Running   0          3m23s
    udm-6dcdc457c6-gwmfk       1/1     Running   0          3m23s
    udr-84678ff6dc-zkj52       1/1     Running   0          3m23s
    upf-0                      0/5     Pending   0          3m23s
    webui-66b4df44b-9clwf      1/1     Running   0          3m23s
    ajayonf@node:~$

To uninstall:

.. code-block::

    helm -n sdcore-5g uninstall sdcore-5g
    kubectl delete namespace sdcore-5g # also remove the sdcore-5g if needed


