..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

TestPod
========

Description
-----------
Testpod is developer tool to simulate 5G NFs and control NF behaviour as
per test case requirement. Currently, it simulates AMF, NRF, PCF, UDM and UPF.
While all other NFs run virtually on single pod, SMF runs on actual image on another pod.

The Testpod can be run locally on any environment having miniKube via helm test package
file present in repository OR locally as in binary mode.

How to use TestPod
------------------

* Repository
    * `https://github.com/omec-project/testpod5G.git`

* Execution
    * Binary mode
        * SMF (NF to be tested)
            * Make SMF clone (`git clone --branch onf-release3.0.5 https://github.com/omec-project/smf.git --recursive`)
            * Change SMF PFCP port to 8806 (lib/pfcp/pfcpUdp/udp.go PFCP_PORT = 8806)
            * Compile SMF (go build)
            * Run SMF image(./smf -smfcfg ../../config/smfcfg.yaml -uerouting ../../config/uerouting.yaml)
        * UPF (Only PFCP layer)
            * Make UPF clone (`git clone https://github.com/badhrinathpa/upf-epc.git`)
            * git checkout "sim_fast_path" branch
            * cd  pfcpiface and do "go build"
            * Run UPF pfcp image (./pfcpiface -config ../conf/upf.json)
        * TestPod App
            * Make Testpod clone (`git clone  https://github.com/omec-project/testpod5G.git`)
            * Compile Testpod image(go build)
            * Run Testpod image as AMF to test SMF ( ./testpod amf )
        * Update local DNS table as following (/etc/hosts)
            * # Testpod specific
            * 127.0.0.1 upf
            * 127.0.0.1 smf
            * 127.0.0.1 nrf
            * 127.0.0.1 pcf
            * 127.0.0.1 amf
            * 127.0.0.1 udm

    * Minikube mode
        * Install minikube using Homebrew (brew install minikube)
        * Make Testpod clone (`git clone  https://github.com/omec-project/testpod5G.git`)
        * To test SMF(precondition- UPF should be running)
        * helm install smftest ./helm/smf/
