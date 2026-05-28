# Changelog IoTSIMFraudPrevention

<!-- TOC:START -->
## Table of Contents
- **[r1.2](#r12)**
- [r1.1](#r11)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r1.2

## Release Notes

This public release contains the definition and documentation of
* iot-sim-fraud-prevention 0.1.0
* iot-sim-fraud-prevention-subscriptions 0.1.0

The API definition(s) are based on
* Commonalities 0.6.1
* Identity and Consent Management 0.4.0

## iot-sim-fraud-prevention 0.1.0

**iot-sim-fraud-prevention 0.1.0 is the first initial public version of the IoT SIM Fraud Prevention API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/IoTSIMFraudPrevention/blob/r1.2/code/API_definitions/iot-sim-fraud-prevention.yaml)

### Added

* Initial API definition for IoT SIM Fraud Prevention
* First draft of test definition following CAMARA Testing Guidelines
* API documentation with inline examples and descriptions

### Changed

* Updated API naming convention to follow CAMARA standards (IoTSIMFraudPrevention → iot-sim-fraud-prevention)
* Updated OperationId and URL structure for consistency
* Enhanced CloudEvents compliance for event notifications
* Updated bound parameter type from string to boolean

### Fixed

* Fixed boolean type definition for bound parameter (string → boolean)
* Aligned .feature Feature line with CAMARA Testing Guidelines
* Corrected API documentation links and references

### Removed

* Removed placeholder README.MD file from API_definitions directory

## iot-sim-fraud-prevention-subscriptions 0.1.0

**iot-sim-fraud-prevention-subscriptions 0.1.0 is the companion API for subscription-based notifications for IoT SIM fraud prevention events**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/r1.2/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/IoTSIMFraudPrevention/blob/r1.2/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)

### Added

* Initial API definition for IoT SIM Fraud Prevention Subscriptions
* Event subscription endpoints for fraud detection notifications
* Tags and metadata for API categorization and discovery
* CloudEvents-compliant notification payload structure

### Changed

* Renamed API definition file to follow CAMARA naming conventions
* Updated API structure to align with Commonalities 0.6.1 and Identity and Consent Management 0.4.0

### Fixed

* Corrected API documentation links and references
* Fixed YAML syntax and formatting issues in the specification file

### Removed

* Removed redundant configuration files and placeholders

**Full Changelog**: https://github.com/camaraproject/IoTSIMFraudPrevention/commits/r1.2

# r1.1

## Release Notes

This release candidate contains the definition and documentation of
* iot-sim-fraud-prevention 0.1.0-rc.1
* iot-sim-fraud-prevention-subscriptions 0.1.0-rc.1

The API definition(s) are based on
* Commonalities r3.4
* ICM (Identity and Consent Management) r3.3

## iot-sim-fraud-prevention 0.1.0-rc.1

**iot-sim-fraud-prevention 0.1.0-rc.1 is the first release candidate for the IoT SIM Fraud Prevention API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/main/code/API_definitions/iot-sim-fraud-prevention.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/main/code/API_definitions/iot-sim-fraud-prevention.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/IoTSIMFraudPrevention/blob/main/code/API_definitions/iot-sim-fraud-prevention.yaml)

## iot-sim-fraud-prevention-subscriptions 0.1.0-rc.1

**iot-sim-fraud-prevention-subscriptions 0.1.0-rc.1 is the companion API for subscription-based notifications.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/main/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/IoTSIMFraudPrevention/main/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/IoTSIMFraudPrevention/blob/main/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)

**Full Changelog**: https://github.com/camaraproject/IoTSIMFraudPrevention/commits/r1.1
