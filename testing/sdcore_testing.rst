..
   SPDX-FileCopyrightText: © 2021 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _sdcore-testing:

Test frameworks and coverage
============================

Test Framework
--------------

NG40
""""

NG40 tool is used as RAN emulator in SD-Core testing. NG40 runs inside a VM
which is connected to both Aether control plane and data plane. In testing
scenarios that involve data plane verification, NG40 also emulates a few
application servers which serve as the destinations of data packets.

A typical NG40 test case involves UE attaching, data plane verification and
UE detaching. During the test NG40 acts as UEs and eNBs and talks to the
mobile core to complete attach procedures for each UE it emulates. Then NG40
verifies that data plane works for each attached UE by sending traffic between
UEs and application servers. Before finishing each test NG40 performs detach
procedures for each attached UE.

Test cases
''''''''''

Currently the following NG40 test cases are implemented:

4G Tests:

1. ``4G_M2AS_PING_FIX`` (attach, dl ping, detach)
2. ``4G_M2AS_UDP`` (attach, dl+ul udp traffic, detach)
3. ``4G_M2AS_TCP`` (attach, release, service request, dl+ul tcp traffic, detach)
4. ``4G_AS2M_PAGING`` (attach, release, dl udp traffic, detach)
5. ``4G_M2AS_SRQ_UDP`` (attach, release, service request, dl+ul udp traffic)
6. ``4G_M2CN_PS`` (combined IMSI/PTMSI attach, detach)
7. ``4G_HO`` (attach, relocate and dl ping, detach)
8. ``4G_SCALE`` (attach, dl ping, detach with multiple UEs)
9. ``4G_3_APPS`` (4G attach-detach with ICMP/UDP Data test with 3 applications)
10. ``4G_SCALE_HO`` (attach, Handover, dl ping, detach with multiple UEs)
11. ``4G_ATTACH_STRESS`` (attach-detach 200 times consecutively)
12. ``4G_TAU`` (attach, Tracking Area Update, detach)
13. ``4G_M2AS_UDP_TRAFFIC_CONFORMANT_TO_MAX_RATE`` (attach, UDP Data with correct qos bandwidth, detach)
14. ``4G_M2AS_UDP_TRAFFIC_EXCEEDING_MAX_RATE`` (attach, UDP Data with exceeding bandwidth, detach)

5G Tests:

1. ``5G_SA_Register_Deregister`` (registration, deregistration)
2. ``5G_SA_Register`` (registration, session establishment, deregistration)
3. ``5G_SA_Release`` (registration, session establishment, dl ping, release, deregistration)
4. ``5G_SA_Activate_Release`` (registration, session establishment, dl ping, release, service request,
   dl ping, deregistration)
5. ``5G_SA_Scale`` (registration, session establishment, dl ping, deregistration for multiple UEs)
6. ``5G_SA_M2AS_ICMP`` (registration, session establishment, dl ping, deregistration)
7. ``5G_SA_M2AS_TCP`` (registration, session establishment, dl+ul tcp traffic, deregistration)
8. ``5G_SA_M2AS_UDP`` (registration, session establishment, dl+ul udp traffic, deregistration)
9. ``5G_SA_SCALE`` (registration, session establishment, dl+ul udp traffic, deregistration with multiple UEs)
10. ``5G_SA_Error_Malformed_Reg_Type`` (Error Scenario: registration with malformed registration type)
11. ``5G_SA_Error_Auth_response_with_invalid_RES`` (Error Scenario: Invalid RES sent in Auth Response)
12. ``5G_SA_M2AS_UDP_TRAFFIC_CONFORMANT_TO_MAX_RATE``
    (registration, UDP Data with correct qos bandwidth, deregistration)
13. ``5G_SA_M2AS_UDP_TRAFFIC_EXCEEDING_MAX_RATE`` (registration, UDP Data with exceeding bandwidth, deregistration)

All the test cases are parameterized and can take arguments to specify number
of UEs, attach/detach rate, traffic type/rate etc. For example, ``4G_SCALE``
test case can be configured as a mini scalability test which performs only 5
UE attaches in a patchset pre-merge test, while in the nightly tests it can
take different arguments to run 10K UE attaches with a high attach rate.

Test suites
'''''''''''

The test cases are atomic testing units and can be combined to build test
suites. The following test suites have been built so far:

1. ``functionality test suite`` verifies basic functionality of the
   mobile core. 4G functionality suite runs 4G test case #1 to #8 including
   ``4G_SCALE`` which attaches 5 UEs with 1/s attach rate. 5G functionality
   suite runs 5G test case #1 to #8 including ``5G_SA_Scale`` which attaches
   100 UEs with 1/s attach rate.
2. ``scalability test suite`` tests the system by scale and verifies
   system stability. It runs ``4G_SCALE`` (or ``5G_SA_Scale``) which attaches
   a large number of UEs with high attach rate (16k UEs with 100/s rate on 4G
   CI pod, 1k UEs with 10/s rate on 4G staging pod, and 1k UEs with 1/s rate
   on 5G CI pod).
3. ``performance test suite`` measures performance of the control and
   data plane. It runs ``4G_SCALE`` multiple times with different attach rates
   to understand how the system performs under different loads.

Robot Framework
"""""""""""""""

Robot Framework was chosen to build test cases that involve interacting with
not only NG40 but also other parts of the system. In these scenarios Robot
Framework acts as a high level orchestrator which drives various components
of the system using component specific libraries including NG40.

Currently the ``Integration test suite`` is implemented using Robot
Framework. In the integration tests Robot Framework calls the ng40 library to
perform normal attach/detach procedures. Meanwhile it injects failures into
the system (container restarts, link down etc.) by calling functions
implemented in the k8s library.

The following integration tests are implemented at the moment:

4G Tests:

1. Subscriber Attach with HSS Restart (attach, Restart HSS, detach)
2. Subscriber Attach with SPGWC Restart (attach, Restart SPGWC, detach)
3. Subscriber Attach with pfcp-agent Restart (attach, Restart pfcp-agent, detach)
4. Subscriber Attach Detach HSS Restart Attach Detach (attach-detach, Restart HSS, attach-detach)
5. Subscriber Attach Detach SPGWC Restart Attach Detach (attach-detach, Restart SPGWC, attach-detach)
6. Subscriber Attach Detach MME Restart Attach Detach (attach-detach, Restart MME, attach-detach)
7. Subscriber Attach Detach pfcp-agent Restart Attach Detach (attach-detach, Restart pfcp-agent, attach-detach)
8. Measure Downtime for HSS Restart (Verifies if HSS restarts within acceptable time limit)
9. Measure Downtime for SPGWC Restart (Verifies if SPGWC restarts within acceptable time limit)
10. Measure Downtime for MME Restart (Verifies if MME restarts within acceptable time limit)
11. Measure Downtime for pfcp-agent Restart (Verifies if pfcp-agent restarts within acceptable time limit)
12. Context Replacement at MME (Verifies context replacement at MME after NG40 restart)
13. Context Replacement at SPGWC (Verifies context replacement at SPGWC after MME restart)
14. Context Replacement at UPF (Verifies context replacement at UPF after SPGWC restart)

5G Tests:

1. ``Subscriber Register-Deregister with SMF Restart`` (registration, SMF Restart, deregistration)
2. ``Subscriber Register-Deregister with AUSF Restart`` (registration, AUSF Restart, deregistration)
3. ``Subscriber Register-Deregister with NRF Restart`` (registration, NRF Restart, deregistration)
4. ``Subscriber Register-Deregister with NSSF Restart`` (registration, NSSF Restart, deregistration)
5. ``Subscriber Register-Deregister with PCF Restart`` (registration, PCF Restart, deregistration)
6. ``Subscriber Register-Deregister with UDR Restart`` (registration, UDR Restart, deregistration)
7. ``Subscriber Register-Deregister with UDM Restart`` (registration, UDM Restart, deregistration)
8. ``Subscriber Register-Deregister AMF Restart Subscriber Register-Deregister`` (registration
    -deregistration, AMF Restart, registration-deregistration)
9. ``Subscriber Register-Deregister SMF Restart Subscriber Register-Deregister`` (registration
    -deregistration, SMF Restart, registration-deregistration)
10. ``Subscriber Register-Deregister AUSF Restart Subscriber Register-Deregister`` (registration
    -deregistration, AUSF Restart, registration-deregistration)
11. ``Subscriber Register-Deregister NRF Restart Subscriber Register-Deregister`` (registration
    -deregistration, NRF Restart, registration-deregistration)
12. ``Subscriber Register-Deregister NSSF Restart Subscriber Register-Deregister`` (registration
    -deregistration, NSSF Restart, registration-deregistration)
13. ``Subscriber Register-Deregister PCF Restart Subscriber Register-Deregister`` (registration
    -deregistration, PCF Restart, registration-deregistration)
14. ``Subscriber Register-Deregister UDM Restart Subscriber Register-Deregister`` (registration
    -deregistration, UDM Restart, registration-deregistration)
15. ``Subscriber Register-Deregister UDR Restart Subscriber Register-Deregister`` (registration
    -deregistration, UDR Restart, registration-deregistration)
16. ``Measure Downtime for SMF Restart`` (Verifies if AMF restarts within acceptable time limit)
17. ``Measure Downtime for SMF Restart`` (Verifies if SMF restarts within acceptable time limit)
18. ``Measure Downtime for AUSF Restart`` (Verifies if AUSF restarts within acceptable time limit)
19. ``Measure Downtime for NRF Restart`` (Verifies if NRF restarts within acceptable time limit)
20. ``Measure Downtime for NSSF Restart`` (Verifies if NSSF restarts within acceptable time limit)
21. ``Measure Downtime for PCF Restart`` (Verifies if PCF restarts within acceptable time limit)
22. ``Measure Downtime for UDR Restart`` (Verifies if UDR restarts within acceptable time limit)
23. ``Measure Downtime for UDM Restart`` (Verifies if UDM restarts within acceptable time limit)
24. ``Context Replacement at AMF`` (Verifies context replacement at AMF after NG40 restart)
25. ``Context Replacement at UPF`` (Verifies context replacement at UPF after SMF restart)
26. ``Context Replacement at SMF`` (Verifies context replacement at SMF after AMF restart)

.. Note::
  More integration tests are being developed as part of Robot Framework

Test Schedules
--------------

Nightly Tests
"""""""""""""

SD-Core nightly tests are a set of jobs managed by Aether Jenkins.
All four test suites we mentioned above are scheduled to run nightly.

* ``functionality job (func)`` - runs NG40 test cases included in the
  functionality and integration test suites and verifies all tests pass.

* ``scalability job (scale)`` - runs the scalability test suite and reports the
  number of successful/failed attaches, detaches and pings.

All these jobs can be scheduled on any of the Aether PODs. By combining
the test type and test pod the following Jenkins jobs are generated:

* ``ci-4g`` pod: `sdcore_ci-4g_4g_bess_func`, `sdcore_ci-4g_4g_bess_scale`
* ``ci-5g`` pod: `sdcore_ci-5g_5g_bess_func`, `sdcore_ci-5g_5g_bess_scale`
* ``qa`` pod: `sdcore_qa_4g_bess_func`, `sdcore_qa_4g_bess_scale`
* ``qa2`` pod: `sdcore_qa2_4g_bess_func`, `sdcore_qa2_4g_bess_scale`

Nightly Job structure
"""""""""""""""""""""

The integration tests are written using Robot Framework and are executed along
with the functional tests. The top-level pipeline
(for example, `sdcore_ci-4g_4g_bess_func`) runs the following downstream jobs:

1. `sdcore_ci-4g_deploy`
2. `sdcore_ci-4g_4g_bess_robot-test`
3. `archive-artifacts_ci-4g`
4. `post-results_ci-4g`

Pre-Merge Tests
---------------

SD-Core pre-merge verification covers the following 4G/5G Core Github repos:

* ``c3po``
* ``Nucleus``
* ``upf-epc``
* ``spgw``

and 5G Core GitHub repos:

* ``amf``
* ``smf``
* ``ausf``
* ``nssf``
* ``nrf``
* ``pcf``
* ``udm``
* ``udr``
* ``webconsole``

SD-Core CI verifies the following:

1. ONF CLA verification
2. License verification (FOSSA/Reuse)
3. NG40 tests

These jobs are automatically triggered by submitted or updated pull-request to the repos
above. Re-trigger the checks by commenting one of the following phrases in the active pull-request:

* ``retest this please`` - re-tests all checks
* ``test container`` - re-tests pre-merge jobs
* ``test license`` - re-tests license verification
* ``test fossa`` - re-tests FOSSA verification
