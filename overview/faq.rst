..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

FAQs
====

    * **Does SD-Core support for roaming architecture?**

      *SD-Core is primarily focused for private 5G  & private LTE use cases and*
      *hence roaming aspects of architecture are not supported.*

    * **Does SD-Core support charging functionality or CHF (charging network function)?**

        *SD-Core is primarily focussed for private 5G & private LTE use cases and*
        *hence charging related aspects are not supported.*

    * **Is SD-Core/5G-Core cloud native?**

        *SD-Core is not cloud native, but it runs in K8s environment.*
        *As per road map AMF, SMF will be cloud native by the Q3 of 2022. This is WIP.*

    * **What are the changes omec 5G has on top of free5gc?**

        * Configuration APIs to configure all network functions
        * QoS support at default flow and per application flow
        * 5000 subscribers with 10 calls per second stability achieved (Single Instance)
        * Error cases with UPF connectivity fixed
        * Error case of no response or message retransmission towards UPF
        * Error cases with Network functions restarts fixed
        * Stability issues on NGAP interfaces and N1 interfaces fixed
        * 100+ code commits to achieve code stability
        * 3gpp compliance of 5G core is added in SD core documentation
        * per UE FSM in AMF & SMF
        * Transaction support in AMF & SMF
        * UE address allocation by UPF support at SMF
        * **There are many more changes done and above are just high level summary**

    * **Network Performance Testing of SD-Core**

        *No performance results available. Limited scale testing is performed to check*
        *the control plane subscriber capacity and  transaction rate. But still its not*
        *formal enough to share with wider community. Watch out for release notes and testing
        *section to get current performance results*

