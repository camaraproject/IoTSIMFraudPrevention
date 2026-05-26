<a href="https://github.com/camaraproject/IoTSIMFraudPrevention/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/IoTSIMFraudPrevention?style=plastic"></a>
<a href="https://github.com/camaraproject/IoTSIMFraudPrevention/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/IoTSIMFraudPrevention?style=plastic"></a>
<a href="https://github.com/camaraproject/IoTSIMFraudPrevention/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/IoTSIMFraudPrevention?style=plastic"></a>
<a href="https://github.com/camaraproject/IoTSIMFraudPrevention/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/IoTSIMFraudPrevention?style=plastic"></a>
<a href="https://github.com/camaraproject/IoTSIMFraudPrevention" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/IoTSIMFraudPrevention?style=plastic"></a>
<a href="https://github.com/camaraproject/IoTSIMFraudPrevention/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/IoTSIMFraudPrevention/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/IoTSIMFraudPrevention?style=plastic"></a>
<a href="https://github.com/camaraproject/Governance/blob/main/ProjectStructureAndRoles.md" title="Sandbox API Repository"><img src="https://img.shields.io/badge/Sandbox%20API%20Repository-yellow?style=plastic"></a>

# IoTSIMFraudPrevention

Sandbox API Repository to describe, develop, document, and test the IoT SIM Fraud Prevention Service API(s). The repository does not yet belong to a CAMARA Sub Project.

* API Repository [wiki page](https://lf-camaraproject.atlassian.net/wiki/x/xwKaBQ) 

## Scope

This repository contains two related APIs:

### 1. IoT SIM Fraud Prevention API (iot-sim-fraud-prevention)
* Provides real-time fraud detection capabilities for IoT SIM cards
* Allows querying fraud status and risk assessment for specific SIMs
* Manages device-card binding (IMEI binding/unbinding)
* Manages device-area binding (geographic restrictions)
* Queries risk control information related to IoT SIM cards

### 2. IoT SIM Fraud Prevention Subscriptions API (iot-sim-fraud-prevention-subscriptions)
* Enables subscription-based notifications for fraud events
* Supports webhook callbacks when fraud is detected on monitored SIMs
* Provides event-driven capabilities for real-time fraud monitoring
* Supports multiple transport protocols (MQTT, AMQP, Apache Kafka, NATS)
* Complements the main API with asynchronous notification capabilities

**Key Capabilities:**
* **Device-Card Binding**: Bind/unbind IMEI to SIM cards. When IMEI doesn't match binding information, operator blocks network access. When IMEI matches, network access is resumed.
* **Device-Area Binding**: Bind/unbind geographic areas to SIM cards. When device location doesn't match binding information, operator blocks network access. When location matches, network access is resumed.
* **Risk Control Query**: Query risk control information including machine-card binding status and region restrictions.
* **Event Notifications**: Subscribe to fraud detection events via multiple messaging protocols.

* Describe, develop, document, and test the API(s)
* Started: March 2025

<!-- CAMARA:RELEASE-INFO:START -->
<!-- The following section is automatically maintained by the CAMARA project-administration tooling: https://github.com/camaraproject/project-administration -->

## Release Information

> [!NOTE]
> Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.

* The latest public release is [r1.2](https://github.com/camaraproject/IoTSIMFraudPrevention/releases/tag/r1.2), with the following API versions:
  * **iot-sim-fraud-prevention 0.1.0**
  [[YAML]](https://github.com/camaraproject/IoTSIMFraudPrevention/blob/r1.2/code/API_definitions/iot-sim-fraud-prevention.yaml)  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention.yaml&nocors)  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention.yaml)
  * **iot-sim-fraud-prevention-subscriptions 0.1.0**
  [[YAML]](https://github.com/camaraproject/IoTSIMFraudPrevention/blob/r1.2/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml&nocors)  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)

* The latest public release is always available here: https://github.com/camaraproject/IoTSIMFraudPrevention/releases/latest
* Other releases of this repository are available in https://github.com/camaraproject/IoTSIMFraudPrevention/releases
* For changes see [CHANGELOG](https://github.com/camaraproject/IoTSIMFraudPrevention/tree/main/CHANGELOG)

_The above section is automatically synchronized by CAMARA project-administration._
<!-- CAMARA:RELEASE-INFO:END -->

## Contributing
* Meetings are held virtually
    * Schedule: Every 2 weeks on Wednesdays at 9:00 UTC (start from April 30th, 2025)
    * [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/92159554978?password=c5c63329-3b55-4fe0-94d9-9091c51f2ef9)
    * Minutes: Access [meeting minutes](https://lf-camaraproject.atlassian.net/wiki/x/GwCfBQ)
* Mailing List
    * Subscribe / Unsubscribe to the mailing list <https://lists.camaraproject.org/g/sp-iot-sim-fraud-prevention>.
    * A message to the community of this Sub Project can be sent using <sp-iot-sim-fraud-prevention@lists.camaraproject.org>.
