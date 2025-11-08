..
   SPDX-FileCopyrightText: © 2022 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

UPF Configuration
=================

Below you may find some of the upf override configuration.

Bess default values `can be found here <https://github.com/omec-project/sdcore-helm-charts/blob/main/bess-upf/values.yaml>`_

For an example of enabling PFCP raw-dump (values.yaml snippets) for the
``pfcp-agent`` see :doc:`pfcp-dump-examples`.

UPF Address Pool
-----------------

Below config is basic minimal config which has UE address pool configuration
.. code-block::

  config:
    upf:
      cfgFiles:
        upf.jsonc:
          mode: af_packet  #this mode means no dpdk
          hwcksum: true
          log_level: "trace"
          gtppsc: true #extension header is enabled in 5G. Sending QFI in pdu session extension header
          measure_upf: false #enable packet processing time
          cpiface:
            dnn: "internet" #keep it matching with Slice dnn
            hostname: "upf"
            #http_port: "8080"
            enable_ue_ip_alloc: true # if true then it means UPF allocates address from below pool
            ue_ip_pool: "172.250.0.0/16" # UE ip pool is used if enable_ue_ip_alloc is set to true


Slice rate Configuration
------------------------

.. code-block::

  config:
    upf:
      cfgFiles:
        upf.jsonc:
          # Default global rate limits. Can be changed at runtime via BESS gRPC.
          slice_rate_limit_config:
            # Uplink
            n6_bps: 1000000000 # 1Gbps
            n6_burst_bytes: 12500000 # 10ms * 1Gbps
            # Downlink
            n3_bps: 1000000000 # 1Gbps
            n3_burst_bytes: 12500000 # 10ms * 1Gbps

.. note::
  TBD : add REST api documentation to change slice QoS rates.

UPF Enable dpdk & sriov
------------------------

.. code-block::

  config:
    upf:
      # Enable privileged when run from VM with sriov support
      privileged: false
      hugepage:
        enabled: true
      sriov:
        enabled: true
      cniPlugin: vfioveth
      access:
        # Provide sriov resource name when sriov is enabled
        resourceName: "intel.com/intel_sriov_vfio"
      core:
        # Provide sriov resource name when sriov is enabled
        resourceName: "intel.com/intel_sriov_vfio"
      cfgFiles:
        upf.jsonc:
          mode: dpdk
