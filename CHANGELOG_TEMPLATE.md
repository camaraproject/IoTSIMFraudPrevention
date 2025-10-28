# Changelog IoTSIMFraudPrevention

## Table of contents

- **[r1.2](#r12) (Fall25 public release)**
- **[r1.1 - rc](#r11---rc)**

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

- for an alpha release, the delta with respect to the previous release
- for the first release-candidate, all changes since the last public release
- for subsequent release-candidate(s), only the delta to the previous release-candidate
- for a public release, the consolidated changes since the previous public release

# r1.2

## Release Notes

This public release contains the definition and documentation of

- iot-sim-fraud-prevention v0.1.0
- iot-sim-fraud-prevention-subscriptions v0.1.0

The API definition(s) are based on

- Commonalities v0.5.0
- Identity and Consent Management v1.0.0

## iot-sim-fraud-prevention v0.1.0

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ApplicationEndpointDiscovery/blob/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  
**NOTE: there is no significant changes compared to r1.1-rc version.**

## iot-sim-fraud-prevention-subscriptions v0.1.0

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ApplicationEndpointDiscovery/blob/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  
**NOTE: there is no significant changes compared to r1.1-rc version.**

# r1.1 - rc

## Release Notes

This pre-release contains the definition and documentation of

- iot-sim-fraud-prevention v0.1.0-rc.1
- iot-sim-fraud-prevention-subscriptions v0.1.0-rc.1

The API definition(s) are based on

- Commonalities v0.5.0
- Identity and Consent Management v1.0.0

## iot-sim-fraud-prevention v0.1.0-rc.1

**iot-sim-fraud-prevention v0.1.0-rc.1 is the initial new release candidate version of this API, including initial documentation.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ApplicationEndpointDiscovery/blob/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  
### Added

- Initial release of IoT SIM Fraud Prevention API
- `/bind` endpoint for binding device IMEI or area restrictions
- `/unbind` endpoint for unbinding device IMEI or area restrictions  
- `/query` endpoint for querying risk control information
- Support for multiple device identifiers (IPv4, IPv6, phone number, network access identifier)
- Comprehensive error handling with specific error codes
- Security scheme with OpenID Connect authentication
- Device identification from access token (2-legged and 3-legged tokens)

## iot-sim-fraud-prevention-subscriptions v0.1.0-rc.1

**iot-sim-fraud-prevention-subscriptions v0.1.0-rc.1 is the initial new release candidate version of this API, including initial documentation.**
- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ApplicationEndpointDiscovery/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ApplicationEndpointDiscovery/blob/r1.1/code/API_definitions/application-endpoint-discovery.yaml)
  
### Added

- Initial release of IoT SIM Fraud Prevention Subscriptions API
- `/subscribe` endpoint for subscribing to risk control events
- Support for IMEI_CHANGE and AREA_CHANGE event types
- Callback mechanism for event notifications
- Subscription management with expiration and event limits
- Multiple protocol support (HTTP, MQTT3, MQTT5, AMQP, NATS, KAFKA)
- Sink credential management for secure event delivery
- Subscription status tracking (ACTIVE, INACTIVE, EXPIRED, etc.)
