TEST POD
========

Description
-----------
Testpod is developer tool to simulate 5G NFs and control NF behaviour as
per test case requirement. Currently, it simulates AMF, NRF, PCF, UDM and UPF.
While all other NFs run virtually on single pod, SMF runs on actual image on another pod.

The Testpod can be run locally on any environment having miniKube via helm test package
file present in repository OR locally as in binary mode.

How to use testPod
------------------

* Binary mode
    * SMF => ./smf -smfcfg ../../config/smfcfg.yaml -uerouting ../../config/uerouting.yaml
    * UPF => ./pfcpiface -config ../conf/upf.json
    * TestPod App => ./testpod amf

* Minikube mode
    * To test SMF(precondition- UPF should be running)
    * helm install smftest ./helm/smf/
