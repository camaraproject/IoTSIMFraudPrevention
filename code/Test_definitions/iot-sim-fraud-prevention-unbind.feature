@iot_sim_fraud_prevention_unbind
  Feature: CAMARA IoT SIM Fraud Prevention API - Unbind Operations

  # Input to be provided by the implementation to the tests
  # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention.yaml

  Background: Common IoT SIM Fraud Prevention Unbind setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/v1/unbind"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  ######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_unbind_success_imei
  Scenario: Successfully unbind IMEI from device
    Given a valid unbind request body with unBindType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    And the device has existing IMEI binding
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/UnBindDeviceImeiResponse"
    And the response property "$.unbound" is "TRUE"

  @iot_sim_fraud_prevention_unbind_success_arealimit
  Scenario: Successfully unbind area restriction from device
    Given a valid unbind request body with unBindType "AREALIMIT"
    And the request body includes device identifier(s) supported by the implementation
    And the device has existing area restriction
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/UnBindDeviceImeiResponse"
    And the response property "$.unbound" is "TRUE"

  ############### Error response scenarios ###########################

  # 400 Error Scenarios for unbind
  @iot_sim_fraud_prevention_unbind_400_missing_unbindtype
  Scenario: Unbind operation with missing unBindType parameter
    Given the request body does not include property "$.unBindType"
    And the request body includes valid device identifier(s)
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "UnbindType must be specified"

  @iot_sim_fraud_prevention_unbind_400_invalid_unbindtype
  Scenario: Unbind operation with invalid unBindType value
    Given the request body property "$.unBindType" is set to an invalid value
    And the request body includes valid device identifier(s)
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "The value of unbindType can only be IMEIBIND,AREALIMIT"

  @iot_sim_fraud_prevention_unbind_400_missing_device
  Scenario: Unbind operation with missing device identifiers
    Given the request body property "$.device" is not included
    And the header "Authorization" is set to a valid access token which does not identify a single device
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "At least one of phoneNumber, networkAccessIdentifier, ipv4Address and ipv6Address must be specified"

  # 401 Error Scenarios
  @iot_sim_fraud_prevention_unbind_401_expired_token
  Scenario: Unbind operation with expired access token
    Given the header "Authorization" is set to an expired access token
    And a valid unbind request body
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # 403 Error Scenarios
  @iot_sim_fraud_prevention_unbind_403_permission_denied
  Scenario: Unbind operation without required scope
    Given the header "Authorization" is set to a valid access token without scope "iot-sim-fraud-prevention:unbind"
    And a valid unbind request body
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # 404 Error Scenarios
  @iot_sim_fraud_prevention_unbind_404_device_not_found
  Scenario: Unbind operation for unknown device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" includes identifiers that cannot be matched to a registered device
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # 422 Error Scenarios
  @iot_sim_fraud_prevention_unbind_422_unnecessary_identifier
  Scenario: Unbind operation with unnecessary device identifier when using 3-legged token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_unbind_422_missing_identifier
  Scenario: Unbind operation with missing device identifier when using 2-legged token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_unbind_422_unsupported_identifier
  Scenario: Unbind operation with unsupported device identifier
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_unbind_422_unnecessary_unbind_imei
  Scenario: Unbind IMEI when already unbound
    Given a valid unbind request body with unBindType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    And the device does not have existing IMEI binding
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_UNBIND_IMEI"
    And the response property "$.message" contains "The current device imei has been unbound"

  # 429 Error Scenarios
  @iot_sim_fraud_prevention_unbind_429_quota_exceeded
  Scenario: Unbind operation exceeding quota limit
    Given the API consumer has exceeded their quota limit
    And a valid unbind request body
    When the HTTP POST request "UnBindDeviceImei" is sent
    Then the response status code is 429
    And the response property "$.status" is 429
    And the response property "$.code" is "QUOTA_EXCEEDED"
    And the response property "$.message" contains a user friendly text
