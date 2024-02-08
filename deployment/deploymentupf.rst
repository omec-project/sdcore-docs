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
- Multiple UPF (user plane function) options available to meet the needs of different applications BESS-UPF, P4-UPF
- Many UPFs can connect to same control plane. Control Plane selects UPF based on
  various criteria - DNN/Slice (5G), Apn, IMSI, ULI(4G), Slice IDs
- IP address allocation supported at Control plane and also at UPF
- UPF Attach/detach to SD-Core. UPF Pools created based on enterprise need.

Option1: AF_PACKET Mode UPF
----------------------------

- Refer Aether in a box (AIAB) for this mode.
- AIAB has all default values and its good example of how to use AF_PACKET mode
- If performance is not the concern then this option should be considered
- AF_PACKET mode is easy to deploy and does not need to do extra installations on K8s node


Option2: SRIOV and DPDK enabled UPF
------------------------------------
Please follow the below procedure to bring up UPF in DPDK mode with SRIOV.

Pre-requisite:
''''''''''''''
- As a pre-requisite please make sure virtualization and VT-d parameters are enabled in BIOS.

- make sure enough hugepage memory allocated, iommu enabled. These changes can be made by updating
  below parameter in /etc/default/grub as follows,

  .. code-block::

    GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt default_hugepagesz=1G hugepagesz=1G hugepages=32 transparent_hugepage=never"

  Note: Number of hugepages = 2 X No of UPF Instances

  Once it is updated apply the changes by running below command,

  .. code-block::

    $sudo update-grub
    $sudo reboot

  You can verify the allocated hugepages using below command,

  .. code-block::

    curl https://raw.githubusercontent.com/DPDK/dpdk/main/usertools/dpdk-hugepages.py -O dpdk-hugepages.py

    $chmod +x dpdk-hugepages.py
    $./dpdk-hugepages.py -s
    Node Pages Size Total
    0    2048  2Mb    4Gb
    1    2048  2Mb    4Gb

    Hugepages mounted on /dev/hugepages

step 1: Create VF devices and bind them to the vfio-pci driver
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
- Create required VF devices as follows (In this example the PF interface used is "ens801f0")

  .. code-block::

    echo 2 > /sys/class/net/ens801f0/device/sriov_numvfs

  Now retrieve the PCI address for the newly created VF devices using below command,

  .. code-block::

    ls -l /sys/class/net/ens801f0/device/virtfn*

- Make sure all the VF devices contains valid MAC address(not all zero's),

  .. code-block::

    ip link show ens801f0

  If the MAC shown for VF's are all zero's then retrieve the MAC using the PCI obtained above as follows,

  .. code-block::

    cat /sys/bus/pci/devices/0000\:b1\:01.0/net/ens801f0v0/address
    00:11:22:33:44:50

    cat /sys/bus/pci/devices/0000\:b1\:01.1/net/ens801f0v1/address
    00:11:22:33:44:51

  Set the above retrieved MAC address for the VF's using below command,

  .. code-block::

    ip link set ens801f0 vf 0 mac 00:11:22:33:44:50
    ip link set ens801f0 vf 1 mac 00:11:22:33:44:51

- Bind the VF devices to the vfio-pci driver as follows,

  .. code-block::

    curl https://raw.githubusercontent.com/ceph/dpdk/master/tools/dpdk-devbind.py -O dpdk-devbind.py
    chmod +x dpdk-devbind.py

    ./dpdk-devbind.py -b vfio-pci 0000:b1:01.0
    ./dpdk-devbind.py -b vfio-pci 0000:b1:01.1


step 2 - Install SRIOV device plugin
''''''''''''''''''''''''''''''''''''
- Install the required packages for kubernetes,

  .. code-block::

    cd aether-in-a-box
    make node-prep

- Download sriov-device-plugin.yaml and install,

  .. code-block::

    $wget https://github.com/opennetworkinglab/aether-configs/blob/main/sys/sriov-device-plugin/sriov-device-plugin.yaml
    $kubectl apply -f sriov-device-plugin.yaml

- Create the sriov-device-plugin-config.yaml file with below details and install,

  .. code-block::

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: sriovdp-config
    data:
      config.json: |
        {
          "resourceList": [
            {
              "resourcePrefix": "intel.com",
              "resourceName": "intel_sriov_vfio_access",
              "selectors": {
                "pfNames": ["ens801f0#0-1"],
                "vendors": ["8086"],
                "drivers": ["vfio-pci"]
              }
            },
            {
              "resourcePrefix": "intel.com",
              "resourceName": "intel_sriov_vfio_core",
              "selectors": {
                "pfNames": ["ens801f0#2-3"],
                "vendors": ["8086"],
                "drivers": ["vfio-pci"]
              }
            }
          ]
        }

    $kubectl apply -f sriov-device-plugin-config.yaml

- Make sure that there are minimum 1 intel_sriov_vfio_access/intel_sriov_vfio_core resources available,

  .. code-block::

    $kubectl get nodes -o json | jq '.items[].status.allocatable'
      {
      "cpu": "144",
      "ephemeral-storage": "222337451653",
      "hugepages-1Gi": "32Gi",
      "intel.com/intel_sriov_vfio_access": "1",
      "intel.com/intel_sriov_vfio_core": "1",
      "memory": "494544488Ki",
      "pods": "110"
    }

step 3 - Deploy 5G core using AiaB
'''''''''''''''''''''''''''''''''''

Update sd-core-5g-values.yaml file parameters as follows (along with any other changes
required with respect to the environment),

  .. code-block::

    diff --git a/sd-core-5g-values.yaml b/sd-core-5g-values.yaml
    index 58232ad..1c8893d 100644
    --- a/sd-core-5g-values.yaml
    +++ b/sd-core-5g-values.yaml
    @@ -224,7 +224,7 @@ omec-sub-provision:
    omec-user-plane:
      enable: true
      resources:
    -    enabled: false
    +    enabled: true
      images:
        repository: "registry.opennetworking.org/docker.io/"
        # uncomment below section to add update bess image tag
    @@ -234,12 +234,13 @@ omec-user-plane:
      config:
        upf:
          name: "oaisim"
    +      privileged: true
          sriov:
    -        enabled: false #default sriov is disabled in AIAB setup
    +        enabled: true #default sriov is disabled in AIAB setup
          hugepage:
    -        enabled: false #should be enabled if dpdk is enabled
    +        enabled: true #should be enabled if dpdk is enabled
          #can be any other plugin as well, remember this plugin dictates how IP address are assigned.
    -      cniPlugin: macvlan
    +      cniPlugin: vfioveth
          ipam: static
          routes:
            - to: ${NODE_IP}
    @@ -247,12 +248,16 @@ omec-user-plane:
          enb:
            subnet: ${RAN_SUBNET} #this is your gNB network
          access:
    -        iface: ${DATA_IFACE}
    +        resourceName: "intel.com/intel_sriov_vfio_access"
    +        ip: "192.168.252.3/24"
    +        gateway: "192.168.252.1"
          core:
    -        iface: ${DATA_IFACE}
    +        resourceName: "intel.com/intel_sriov_vfio_core"
    +        ip: "192.168.250.3/24"
    +        gateway: "192.168.250.1"
          cfgFiles:
            upf.json:
    -          mode: af_packet  #this mode means no dpdk
    +          mode: dpdk  #this mode means no dpdk

- Deploy the 5g-core (in the below case GNBSIM is disabled) as required,

  .. code-block::

    ENABLE_GNBSIM=false DATA_IFACE=ens801f0 CHARTS=latest make 5g-core

  UPF will be deployed with DPDK now and you can verify the traffic using UERANSIM (or any preferred method). If you want to deploy the Aether with RoC then use below command,

  .. code-block::

    ENABLE_GNBSIM=false DATA_IFACE=ens801f0 CHARTS=latest make roc-5g-models 5g-core

.. note::

 - This option should be preferred if performance is utmost important
 - Please refer to `UPF Installation Guide <https://docs.google.com/document/d/1-BT7XqVsL7ffBlD7aweYaScKDQH7Gv5tHKt-sJGuf6c/edit#>`_ guide for more details
