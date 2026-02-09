

# Changelog IoT Fraud Prevention

## Table of Contents
- **[r1.1](#r11)**  
*(Release Candidate for Spring 2026 MetaRelease)*

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release  
* for the first release-candidate, all changes since the last public release  
* for subsequent release-candidate(s), only the delta to the previous release-candidate  
* for a public release, the consolidated changes since the previous public release  

---

# r1.1

## Release Notes

This release contains the definition and documentation of  
* **iot-fraud-prevention v0.1.0-rc.1**

The API definition(s) are based on  
* Commonalities [r3.4](https://github.com/camaraproject/Commonalities/releases/tag/r3.4)  
* Identity and Consent Management [r3.4](https://github.com/camaraproject/IdentityAndConsentManagement/releases/tag/r3.4)  

> ℹ️ *This is the first Release Candidate for the IoT Fraud Prevention API targeting the Spring 2026 Camara MetaRelease. Public release (r1.2) is planned pending certification and community feedback.*

## iot-fraud-prevention v0.1.0-rc.1

**iot-fraud-prevention v0.1.0-rc.1 is the first release-candidate version for v0.1.0 of the IoT Fraud Prevention API.**

API definition **with inline documentation**:  
(https://github.com/camaraproject/IoTSIMFraudPrevention/blob/233f9f568111b26ed5b490058702b3beab188413/code/API_definitions/iot-sim-fraud-prevention.yaml)  
(https://github.com/camaraproject/IoTSIMFraudPrevention/blob/233f9f568111b26ed5b490058702b3beab188413/code/API_definitions/iot-sim-fraud-prevention-subscriptions.yaml)  

**Initial contribution of API definitions for IoT Fraud Prevention**.

## Added
* Initial YAML definition for IoT Fraud Prevention API
* API documentations, including user story and API-Readiness-Checklist


## Changed
* Removed generic `AUTHENTICATION_REQUIRED` error code in API definition files.
