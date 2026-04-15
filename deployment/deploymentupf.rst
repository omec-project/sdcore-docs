..
   SPDX-FileCopyrightText: © 2022 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

.. _deployment_upf_guide:

UPF Deployment Guide
====================

- Each Site has one or more UPFs dedicated for use case
- Each Slice supports only 1 UPF
- UPFs can be added during runtime and UP/CP form PFCP association
- Edges can run on different versions of UPF. Changes are always backward compatible
- Option to Install only 4G or 5G or both
- SD-Core uses BESS-UPF, a software-based user plane function optimized for various deployment scenarios
- Many UPFs can connect to same control plane. Control Plane selects UPF based on
  various criteria - DNN/Slice (5G), Apn, IMSI, ULI(4G), Slice IDs
- IP address allocation supported at Control plane and also at UPF
- UPF Attach/detach to SD-Core. UPF Pools created based on enterprise need.

Option1: AF_PACKET Mode UPF
----------------------------

- Refer `Aether OnRamp <https://docs.aetherproject.org/onramp/overview.html>`_ for deployment examples.
- OnRamp provides default configurations and examples for AF_PACKET mode
- If performance is not the concern then this option should be considered
- AF_PACKET mode is easy to deploy and does not need to do extra installations on K8s node


Option2: SRIOV and DPDK enabled UPF
------------------------------------
Use this option when the UPF should run in DPDK mode with SRIOV-backed interfaces.
The current ``bess-upf`` chart already includes the SRIOV device-plugin manifests and
the ``sriovdp-config`` ConfigMap when ``omec-user-plane.config.upf.sriov.enabled`` is
set to ``true``. The workflow is therefore:

- prepare the node for hugepages, IOMMU, and SRIOV
- create and bind the required VFs to ``vfio-pci``
- set the ``omec-user-plane`` values so the chart can generate the correct SRIOV resources
- deploy SD-Core with those values

Pre-requisite:
''''''''''''''
- As a pre-requisite please make sure virtualization and VT-d parameters are enabled in BIOS.

- Make sure IOMMU is enabled and enough hugepage memory is allocated. The UPF chart requests
  ``2Gi`` of ``hugepages-1Gi`` per UPF pod when hugepages are enabled, so size the node for the
  number of UPF instances that will run on it. These changes can be made by updating
  ``/etc/default/grub`` as follows,

  .. code-block:: bash

     GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt default_hugepagesz=1G hugepagesz=1G hugepages=32 transparent_hugepage=never"

  Note: A single UPF instance requires two 1Gi hugepages.

  Once it is updated apply the changes by running below command,

  .. code-block:: bash

     $sudo update-grub
     $sudo reboot

  You can verify the allocated hugepages using below command,

  .. code-block:: bash

     curl https://raw.githubusercontent.com/DPDK/dpdk/main/usertools/dpdk-hugepages.py -O dpdk-hugepages.py

     $chmod +x dpdk-hugepages.py
     $./dpdk-hugepages.py -s
     Node Pages Size Total
     0    2048  2Mb    4Gb
     1    2048  2Mb    4Gb

     Hugepages mounted on /dev/hugepages

Step 1: Create VF devices and bind them to the vfio-pci driver
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
- Create the required VF devices on the PFs that will carry the N3 and N6 networks.
  In the example below the PFs are ``ens801f0`` for N3 and ``ens801f1`` for N6.
  If both N3 and N6 will use VFs from the same PF, create at least two VFs on that PF.

  .. code-block:: bash

     echo 2 > /sys/class/net/ens801f0/device/sriov_numvfs
     echo 2 > /sys/class/net/ens801f1/device/sriov_numvfs

  Now retrieve the PCI address for the newly created VF devices using below command,

  .. code-block:: bash

     ls -l /sys/class/net/ens801f0/device/virtfn*
     ls -l /sys/class/net/ens801f1/device/virtfn*

- Make sure all VF devices contain a valid MAC address (not all zero's),

  .. code-block:: bash

     ip link show ens801f0
     ip link show ens801f1

  If the MAC shown for the VF's are all zero's, then retrieve the MAC using the PCI obtained above, as follows,

  .. code-block:: bash

     cat /sys/bus/pci/devices/0000\:b1\:01.0/net/ens801f0v0/address
     00:11:22:33:44:50

     cat /sys/bus/pci/devices/0000\:b1\:01.1/net/ens801f0v1/address
     00:11:22:33:44:51

     cat /sys/bus/pci/devices/0000\:b2\:01.0/net/ens801f1v0/address
     00:11:22:33:44:60

  Then, set the VF's MAC address using the value obtained above

  .. code-block:: bash

     ip link set ens801f0 vf 0 mac 00:11:22:33:44:50
     ip link set ens801f0 vf 1 mac 00:11:22:33:44:51
     ip link set ens801f1 vf 0 mac 00:11:22:33:44:60

- Bind the VFs that will be consumed by the UPF pod to the ``vfio-pci`` driver.

  .. code-block:: bash

     curl https://raw.githubusercontent.com/ceph/dpdk/master/tools/dpdk-devbind.py -O dpdk-devbind.py
     chmod +x dpdk-devbind.py

     ./dpdk-devbind.py -b vfio-pci 0000:b1:01.0
     ./dpdk-devbind.py -b vfio-pci 0000:b1:01.1
     ./dpdk-devbind.py -b vfio-pci 0000:b2:01.0

  Verify the result using:

  .. code-block:: bash

     ./dpdk-devbind.py --status

Step 2: Configure ``omec-user-plane`` values for SRIOV and DPDK
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set the ``omec-user-plane`` values so the chart can generate the SRIOV device-plugin
configuration and request the correct PCI resources. The important fields are:

- ``config.upf.privileged: true`` when running with SRIOV-backed DPDK interfaces
- ``config.upf.hugepage.enabled: true`` to mount and request hugepages
- ``config.upf.sriov.enabled: true`` to install the SRIOV device plugin and generated config
- ``config.upf.access.iface`` and ``config.upf.core.iface`` set to the PF names used to create VFs
- ``config.upf.access.resourceName`` and ``config.upf.core.resourceName`` set to the Kubernetes
  device-plugin resource names exposed to the pod
- ``config.upf.access.cniPlugin`` and ``config.upf.core.cniPlugin`` set to ``vfioveth``
- ``config.upf.cfgFiles.upf.jsonc.mode: dpdk``

Example:

  .. code-block:: yaml

     omec-user-plane:
       enable: true
       resources:
         enabled: true
       config:
         upf:
           privileged: true
           hugepage:
             enabled: true
           sriov:
             enabled: true
           routes:
             - to: ${NODE_IP}/32
               via: 169.254.1.1
           enb:
             subnet: ${RAN_SUBNET}
           access:
             ipam: static
             cniPlugin: vfioveth
             iface: ens801f0
             resourceName: intel.com/intel_sriov_vfio_access
             gateway: 192.168.252.1
             ip: 192.168.252.3/24
           core:
             ipam: static
             cniPlugin: vfioveth
             iface: ens801f1
             resourceName: intel.com/intel_sriov_vfio_core
             gateway: 192.168.250.1
             ip: 192.168.250.3/24
           cfgFiles:
             upf.jsonc:
               mode: dpdk

- When ``access.resourceName`` and ``core.resourceName`` are the same, the chart requests two VFs
  from that shared resource pool. Ensure the node advertises at least ``2`` allocatable devices for
  that resource.
- When the resource names are different, the chart generates SRIOV device-plugin selectors from the
  configured PF names and expects one VF from the access pool and one VF from the core pool.
- ``iface`` is still required with ``vfioveth`` because the chart uses the PF names to build the
  SRIOV device-plugin configuration.

  .. code-block:: bash

     kubectl get configmap sriovdp-config -n <namespace> -o yaml
     kubectl get nodes -o json | jq '.items[].status.allocatable'

  Make sure the advertised allocatable resources match the ``resourceName`` values from the Helm
  configuration. For example:

  .. code-block:: json

     {
       "hugepages-1Gi": "32Gi",
       "intel.com/intel_sriov_vfio_access": "1",
       "intel.com/intel_sriov_vfio_core": "1"
     }

  Or, when a single shared pool is used for both interfaces:

  .. code-block:: json

     {
       "hugepages-1Gi": "32Gi",
       "intel.com/intel_sriov_vfio": "2"
     }

Step 3: Deploy SD-Core with the updated values
'''''''''''''''''''''''''''''''''''''''''''''

Deploy SD-Core using the values file updated above.

  .. code-block:: bash

     helm upgrade --install sdcore sdcore-helm-charts/sdcore-helm-charts \
       -n <namespace> \
       -f sd-core-5g-values.yaml

- If you are using the legacy automation targets, make sure they pass the same ``omec-user-plane``
  values shown above. The key change is that the UPF-specific SRIOV configuration now lives entirely
  in Helm values; separate manual installation of the SRIOV device plugin is no longer required.

- After deployment, verify that the UPF pod is running with two SRIOV-backed interfaces and that
  the BESS container resolved the requested PCI devices:

  .. code-block:: bash

     kubectl get pods -n <namespace>
     kubectl describe pod upf-0 -n <namespace>
     kubectl logs upf-0 -n <namespace> -c bessd | grep allow-list

  UPF will be deployed in DPDK mode and can then be validated using UERANSIM or the preferred RAN simulator.

.. note::

 - This option should be preferred if performance is utmost important
 - Please refer to `UPF Installation Guide <https://docs.google.com/document/d/1-BT7XqVsL7ffBlD7aweYaScKDQH7Gv5tHKt-sJGuf6c/edit#>`_ guide for more details
