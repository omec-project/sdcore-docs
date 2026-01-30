..
   SPDX-FileCopyrightText: 2023-present Intel Corporation
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _design_metricfunc:

Metric Function Design Overview
===============================

.. image:: ../_static/images/Metric_Func_Arch.png
  :width: 500px

Metric-Function
---------------

The Metric Function act as an aggregator and processor of metrics received from different 5G Network Functions.
Currently, only SMF and AMF publishes metrics to the Metric Function as of this release.

The Metric Function provides following features

* API Service exposure
    It provides APIs to fetch various metrics as mentioned below
        * GetSubscriberAll (/nmetric-func/v1/subscriber/all)
        * GetSubscriberSummary (/nmetric-func/v1/subscriber/<imsi>)
        * GetNfStatus (/nmetric-func/v1/nfstatus/<GNB/UPF>)
        * GetNfServiceStats (/nmetric-func/v1/nfServiceStatsSummary/<AMF/SMF>) (not supported in this release)
        * GetNfServiceStatsAll (/nmetric-func/v1/nfServiceStats/all) (not supported in this release)
* Prometheus Client exposure
    * It exposes Prometheus client interface for metrics scraping via Prometheus server
* Analytics Function exposure(not supported in this release)
    * It shall push events to configured Analytics Function.


Sample output from API Service
------------------------------
* GetSubscriberAll (/nmetric-func/v1/subscriber/all)

    .. code-block:: text

       http://<metricfunc-pod-ip>:9301/nmetric-func/v1/subscriber/all

       ["imsi-208930100007487","imsi-208930100007488","imsi-208930100007489","imsi-208930100007490","imsi-208930100007491"]


* GetSubscriberSummary (/nmetric-func/v1/subscriber/<imsi>)

    .. code-block:: text

       http://<metricfunc-pod-ip>:9301/nmetric-func/v1/subscriber/imsi-208930100007487
       {
           "imsi":"imsi-208930100007487",
           "smfId":"urn:uuid:c573621f-e198-4f67-988b-f7373e67601c","smfIp":"192.168.84.172",
           "smfSubState":"Connected","ipaddress":"172.250.237.121","dnn":"internet","slice":"sd:010203 sst:1",
           "upfid":"upf","upfAddr":"192.168.85.188",
           "amfId":"b17f4726-4809-43e6-b5b6-afa0fc72807b","guti":"20893cafe00002647e6","tmsi":2508774,"amfngapId":2508775,
           "ranngapId":3405774848,"amfSubState":"Registered","gnbid":"208:93:000102","tacid":"000001","amfIp":"192.168.84.159"
       }

* GetNfStatus (/nmetric-func/v1/nfstatus/<GNB/UPF>)

    .. code-block:: text

       http://<metricfunc-pod-ip>:9301/nmetric-func/v1/nfstatus/UPF
       [
           {"nfType":"UPF","nfStatus":"Connected","nfName":"upf-1"},
           {"nfType":"UPF","nfStatus":"Connected","nfName":"upf-2"}
       ]

       http://<metricfunc-pod-ip>:9301/nmetric-func/v1/nfstatus/GNB
       [
           {"nfType":"GNB","nfStatus":"Disconnected","nfName":"208:93:000112"},
           {"nfType":"GNB","nfStatus":"Disconnected","nfName":"208:93:000102"}
       ]

