@iot_sim_fraud_prevention
Feature: CAMARA IoT SIM Fraud Prevention API, wip - Operations for SIM Card Binding and Area Restrictions

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention.yaml

  Background: Common IoT SIM Fraud Prevention setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/wip"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_bind_success_imei
  Scenario: Successfully bind IMEI to device
    Given a valid bind request body with bindType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/BindDeviceImeiResponse"
    And the response property "$.bound" is "TRUE"

  @iot_sim_fraud_prevention_bind_success_arealimit
  Scenario: Successfully bind area restriction to device
    Given a valid bind request body with bindType "AREALIMIT"
    And the request body includes device identifier(s) supported by the implementation
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/BindDeviceImeiResponse"
    And the response property "$.bound" is "TRUE"

  @iot_sim_fraud_prevention_unbind_success_imei
  Scenario: Successfully unbind IMEI from device
    Given a valid unbind request body with unBindType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    And the device has existing IMEI binding
    When the HTTP POST request "UnBindDeviceImei" is sent to "/unbind"
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
    When the HTTP POST request "UnBindDeviceImei" is sent to "/unbind"
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/UnBindDeviceImeiResponse"
    And the response property "$.unbound" is "TRUE"

  @iot_sim_fraud_prevention_query_success_imei_bound
  Scenario: Successfully query IMEI binding status - BOUND
    Given a valid query request body with queryType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    And the device has existing IMEI binding
    When the HTTP POST request "query" is sent to "/query"
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/QueryFraudPreventionResponse"
    And the response property "$.imeiBind.bindStatus" is "BOUND"

  @iot_sim_fraud_prevention_query_success_arealimit_restricted
  Scenario: Successfully query area restriction status - RESTRICTED
    Given a valid query request body with queryType "AREALIMIT"
    And the request body includes device identifier(s) supported by the implementation
    And the device has active area restriction
    When the HTTP POST request "query" is sent to "/query"
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/QueryFraudPreventionResponse"
    And the response property "$.areaLimit.areaLimitStatus" is "RESTRICTED"

############### Error response scenarios ###########################

  # 400 Error Scenarios for bind
  @iot_sim_fraud_prevention_bind_400_missing_bindtype
  Scenario: Bind operation with missing bindType parameter
    Given the request body does not include property "$.bindType"
    And the request body includes valid device identifier(s)
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "BindType must be specified"

  @iot_sim_fraud_prevention_bind_400_invalid_bindtype
  Scenario: Bind operation with invalid bindType value
    Given the request body property "$.bindType" is set to an invalid value
    And the request body includes valid device identifier(s)
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "The value of bindType can only be IMEIBIND,AREALIMIT"

  @iot_sim_fraud_prevention_bind_400_missing_device
  Scenario: Bind operation with missing device identifiers
    Given the request body property "$.device" is not included
    And the header "Authorization" is set to a valid access token which does not identify a single device
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "At least one of phoneNumber, networkAccessIdentifier, ipv4Address and ipv6Address must be specified"

  # 401 Error Scenarios
  @iot_sim_fraud_prevention_bind_401_expired_token
  Scenario: Bind operation with expired access token
    Given the header "Authorization" is set to an expired access token
    And a valid bind request body
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # 403 Error Scenarios
  @iot_sim_fraud_prevention_bind_403_permission_denied
  Scenario: Bind operation without required scope
    Given the header "Authorization" is set to a valid access token without scope "device-imei-areaLimit:bind"
    And a valid bind request body
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # 404 Error Scenarios
  @iot_sim_fraud_prevention_bind_404_device_not_found
  Scenario: Bind operation for unknown device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" includes identifiers that cannot be matched to a registered device
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # 422 Error Scenarios
  @iot_sim_fraud_prevention_bind_422_unnecessary_identifier
  Scenario: Bind operation with unnecessary device identifier when using 3-legged token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_bind_422_missing_identifier
  Scenario: Bind operation with missing device identifier when using 2-legged token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_bind_422_unsupported_identifier
  Scenario: Bind operation with unsupported device identifier
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_unbind_422_unnecessary_unbind_imei
  Scenario: Unbind IMEI when already unbound
    Given a valid unbind request body with unBindType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    And the device does not have existing IMEI binding
    When the HTTP POST request "UnBindDeviceImei" is sent to "/unbind"
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_UNBIND_IMEI"
    And the response property "$.message" contains "The current device imei has been unbound"

  # 429 Error Scenarios
  @iot_sim_fraud_prevention_bind_429_quota_exceeded
  Scenario: Bind operation exceeding quota limit
    Given the API consumer has exceeded their quota limit
    And a valid bind request body
    When the HTTP POST request "BindDeviceImei" is sent to "/bind"
    Then the response status code is 429
    And the response property "$.status" is 429
    And the response property "$.code" is "QUOTA_EXCEEDED"
    And the response property "$.message" contains a user friendly text