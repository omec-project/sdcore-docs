..
   SPDX-FileCopyrightText: 2023-present Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _auto-scaling-5g-nfs:

Auto scaling 5G NFs
===================

Autoscaling cloud native network functions is a critical capability for modern cloud infrastructure.
It enables dynamic scaling of network functions to handle increased traffic or workload demands,
ensuring optimal performance and cost-effectiveness.

Kubernetes Event-driven Autoscaling (KEDA) is an open-source tool that makes it easier to implement
autoscaling for cloud-native network functions(https://github.com/kedacore/keda).

When the network functions receive more traffic or workload, KEDA automatically scales up the pods to
handle the increased demand. When the demand decreases, KEDA scales down the pods to save resources and
minimize costs.

We can enable autoscaling based on memory usage, CPU usage, and custom metrics.

Illustration
------------

Let's explore the steps on how to set up autoscaling in AIAB.

In this example, we are setting up KEDA to scale the smf pod up for every 50 N4 messages received by SMF


Run the following steps in aether-in-a-box folder:

* Create aiab.diff file as described below
* patch < aiab.diff
* Create resources/keda.yaml as described below
* Create resources/5g-monitoring/smf-monitor.yaml as described below
* Create autoscale.yaml as described below
* make 5g-core
* make monitoring-5g
* make autoscale-aiab
* kubectl get hpa -n omec : To view the horizontal pod scaler.
* kubectl get pods -n omec | grep smf :  To view the scaled pods.

Create file aiab.diff with following content

.. code-block::

    diff --git a/Makefile b/Makefile
    index bd54a7a..df85e0a 100644
    --- a/Makefile
    +++ b/Makefile
    @@ -26,9 +26,10 @@ GET_HELM              = get_helm.sh
     KUBESPRAY_VERSION ?= release-2.17
     DOCKER_VERSION    ?= '20.10'
     HELM_VERSION	  ?= v3.10.3
    -KUBECTL_VERSION   ?= v1.23.15
    +KUBECTL_VERSION   ?= v1.24.11

    -RKE2_K8S_VERSION  ?= v1.23.15+rke2r1
    +RKE2_K8S_VERSION  ?= v1.24.11+rke2r1
    +#RKE2_K8S_VERSION  ?= v1.23.15+rke2r1
     K8S_VERSION       ?= v1.21.6

     OAISIM_UE_IMAGE ?= andybavier/lte-uesoftmodem:1.1.0-$(shell uname -r)
    @@ -65,6 +66,8 @@ ROUTER_HOST_NETCONF   := /etc/systemd/network/10-aiab-access.netdev /etc/systemd
     UE_NAT_CONF           := /etc/systemd/system/aiab-ue-nat.service

     # monitoring
    +AUTOSCALE_CHART              := kedacore/keda
    +AUTOSCALE_VALUES             ?= $(MAKEDIR)/autoscale.yaml
     RANCHER_MONITORING_CRD_CHART := rancher/rancher-monitoring-crd
     RANCHER_MONITORING_CHART     := rancher/rancher-monitoring
     MONITORING_VALUES            ?= $(MAKEDIR)/monitoring.yaml
    @@ -675,6 +678,26 @@ test: | 4g-core $(M)/oaisim
        fi
        @grep -q "Simulation Result: PASS\|Profile Status: PASS" /tmp/gnbsim.out

    +autoscale: $(M)/autoscale
    +$(M)/autoscale: $(M)/helm-ready
    +	helm repo add kedacore https://kedacore.github.io/charts
    +	helm upgrade --install --wait $(HELM_GLOBAL_ARGS) \
    +    --namespace=autoscale \
    +    --create-namespace \
    +    --values=$(AUTOSCALE_VALUES) \
    +    keda-aiab \
    +    $(AUTOSCALE_CHART)
    +	touch $(M)/autoscale
    +
    +autoscale-aiab: $(M)/autoscale
    +	kubectl apply -f resources/keda.yaml
    +
    +autoscale-clean:
    +	kubectl delete -f resources/keda.yaml
    +	helm -n autoscale delete keda-aiab || true
    +	kubectl delete namespace autoscale || true
    +	rm $(M)/autoscale
    +
     reset-test: | oaisim-clean omec-clean router-clean
        @cd $(M); rm -f omec oaisim 5g-core

    diff --git a/resources/5g-monitoring/kustomization.yaml b/resources/5g-monitoring/kustomization.yaml
    index 96bc72b..0b757e9 100644
    --- a/resources/5g-monitoring/kustomization.yaml
    +++ b/resources/5g-monitoring/kustomization.yaml
    @@ -5,6 +5,7 @@
     resources:
       - ./metricfunc-monitor.yaml
       - ./upf-monitor.yaml
    +  - ./smf-monitor.yaml

     configMapGenerator:
       - name: grafana-ops-dashboards


Create a file resources/keda.yaml with the following content

.. code-block::

    ---
    apiVersion: keda.sh/v1alpha1
    kind: ScaledObject
    metadata:
      name: smf-scale
      namespace: omec
    spec:
      scaleTargetRef:
         kind: Deployment
         name: smf
      minReplicaCount: 1
      maxReplicaCount: 5
      cooldownPeriod: 30
      pollingInterval: 1
      triggers:
      - type: prometheus
        metadata:
          serverAddress: http://rancher-monitoring-prometheus.cattle-monitoring-system.svc:9090
          metricName: n4_messages_total
          query: |
            sum(n4_messages_total{job="smf"})
          threshold: "50"

Create file resources/5g-monitoring/smf-monitor.yaml with following content

.. code-block::

    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: smf
      namespace: omec
    spec:
      endpoints:
        - path: /metrics
          port: prometheus-exporter
      namespaceSelector:
        matchNames:
          - omec
      selector:
        matchLabels:
          app: smf

Add an empty autoscale.yaml in aiab folder. This file can be used to add override values for keda helm chart.

.. code-block::

    touch autoscale.yaml

