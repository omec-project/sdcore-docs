Configuration Overview
======================

Reference helm chart
--------------------

    - `SD-Core Helm Chart Repository <https://gerrit.opencord.org/admin/repos/sdcore-helm-charts>`_

Configuration Methods
---------------------
SD-Core supports 2 ways to configure network functions and micro services.

    - Helm Chart

        - Each individual network function and microservice has its own helm chart.
        - User needs to provide override values and deploy the network functions as per their need.

    - REST Config Interface

        - Basic static configuration is passed through helm chart
        - Dynamic slice creation APIs are provided through REST interface.
        - REST APIs are defined to create/modify/delete network slice.
        - REST APIs are also provided to provision subscribers and grouping the subscribers under device Group.

Configuration
-------------
This Configuration describes what to configure at high level from RoC/SIMAPP. ConfigPod stores this configuration
and publish to respective clients over grpc.

    - Network Slice Configuration

        - Configuration to create a slice of network
        - Slice contains the QoS configuration
        - Group of devices assigned to network slice
        - Site configuration including UPF, eNBs/gNBs assigned to the slice

    - Device Group Configuration

        - Configuration of group of Devices/Subscribers
        - QoS required for the device group
        - IP domain configuration for the device group

    - Device/Subscriber Provisioning

        - Security keys for a subscriber or group of subscribers

Sample Configuration
--------------------
Sample Network Slice Configuration through REST Interface
  - Post:
    URL: `http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>`
    Ex: `http://config5g:8080/network-slice/slice1`
    Request Body:
    {
    "slice-id": {
    "sst": "1",
    "sd": "010203"
    },
    "qos": {
    "uplink": 4000000,
    "downlink": 20000000,
    "bitrate-unit": "Mbps",
    "traffic-class": "platinum"
    },
    "site-device-group": [
    "iot-camera"
    ],
    "site-info": {
    "site-name": "menlo",
    "plmn": {
    "mcc": "315",
    "mnc": "010"
    },
    "gNodeBs": [
    {
    "name": "menlo-gnb1",
    "tac": 1
    }
    ],
    "upf": {
    "upf-name": "upf.menlo.aetherproject.org",
    "upf-port": 8805
    }
    },
    "deny-applications": [
    "iot-app2"
    ],
    "permit-applications": [
    "iot-app"
    ],
    "applications-information": [
    {
    "app-name": "iot-app",
    "endpoint": "1.1.1.1/32",
    "start-port": 40000,
    "end-port": 40000,
    "protocol": 17
    }
    ]
    }

  - Delete
    URL: `http://<config-service-name-or-ip>:<port>/network-slice/<slice-name>`
    Ex: `http://config5g:8080/network-slice/slice1`

Sample Device Group Configuration through REST Interface
  - Post:
    URL: `http://<config-service-name-or-ip>:<port>/device-group/<group-name>`
    Ex: `http://config5g:8080/device-group/iot-camera`
    Request Body:
    {
    "imsis": [
    "123456789123456"
    "123456789123457"
    "123456789123458"
    ],
    "site-info": "menlo",
    "ip-domain-name": "pool1",
    "ip-domain-expanded": {
    "dnn": "internet",
    "ue-ip-pool": "10.91.0.0/16",
    "dns-primary": "8.8.8.8",
    "dns-secondary": "8.8.4.4",
    "mtu": 1460,
    "ue-dnn-qos": {
    "dnn-mbr-uplink": 4000000,
    "dnn-mbr-downlink": 20000000,
    "bitrate-unit": "Mbps",
    "traffic-class": "platinum"
    }
    }
    }

  - Delete
    URL: `http://<config-service-name-or-ip>:<port>/device-group/<group-name>`
    Ex: `http://config5g:8080/device-group/iot-camera`
