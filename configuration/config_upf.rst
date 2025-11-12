..
   SPDX-FileCopyrightText: © 2022 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

UPF Configuration
=================

Below you may find some of the upf override configuration.

Bess default values `can be found here <https://github.com/omec-project/sdcore-helm-charts/blob/main/bess-upf/values.yaml>`_

For an example of enabling PFCP raw-dump (values.yaml snippets) for the
``pfcp-agent`` see the "PFCP Dump Examples" section below.


PFCP Dump Examples
------------------

This file contains example ``values.yaml`` snippets to enable the PFCP raw-dump
feature for debugging parse errors in the ``pfcp-agent`` container.


Use transient storage (empty dir)
--------------------------------------------------

.. code-block:: yaml

  upfDump:
    enabled: true
    dir: /var/log/upf/pfcp_dumps
    upfName: my-upf-instance
    maxBytes: 104857600  # 100 MiB total per-instance
    maxFiles: 1000
    toLog: false
    persistence:
      enabled: false

This will mount an ``emptyDir`` into the pod at ``/var/log/upf/pfcp_dumps`` and
the runtime will prune files when the directory exceeds ``maxBytes`` or
``maxFiles``.

Use persistent storage (PVC)
-----------------------------------------------

.. code-block:: yaml

  upfDump:
    enabled: true
    dir: /var/log/upf/pfcp_dumps
    upfName: upf-01
    maxBytes: 1073741824  # 1 GiB
    maxFiles: 10000
    toLog: false
    persistence:
      enabled: true
      size: 10Gi
      storageClass: fast-ssd

This configuration will cause the chart to create a PersistentVolumeClaim named
``<release>-pfcp-dump-pvc`` and mount it into the ``pfcp-agent`` container at
the configured ``dir``.

Notes
-----

- ``maxBytes`` and ``maxFiles`` are enforced by the UPF process (pruning).
  Set either to ``0`` to disable that limit.
- ``toLog=true`` will also emit base64-encoded dumps to application logs — be
  careful in high-throughput environments.

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
