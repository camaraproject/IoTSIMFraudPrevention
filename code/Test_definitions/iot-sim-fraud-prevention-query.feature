Feature: CAMARA IoT SIM Fraud Prevention API v1.0.0 - Operation query

    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * A device with an existing IMEI binding
    # * A device with an active area restriction
    # * A valid access token with scope "iot-sim-fraud-prevention:query"
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention.yaml, version 1.0.0

  Background: Common query setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/vwip/query"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_query_success_imei_bound
  Scenario: Successfully query IMEI binding status - BOUND
    Given a valid query request body with queryType "IMEIBIND"
    And the request body includes device identifier(s) supported by the implementation
    And the device has existing IMEI binding
    When the HTTP POST request "query" is sent
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
    When the HTTP POST request "query" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/QueryFraudPreventionResponse"
    And the response property "$.areaLimit.areaLimitStatus" is "RESTRICTED"

############### Error response scenarios ###########################

  @iot_sim_fraud_prevention_query_400_missing_querytype
  Scenario: Query operation with missing queryType parameter
    Given the request body does not include property "$.queryType"
    And the request body includes valid device identifier(s)
    When the HTTP POST request "query" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "QueryType must be specified"

  @iot_sim_fraud_prevention_query_400_invalid_querytype
  Scenario: Query operation with invalid queryType value
    Given the request body property "$.queryType" is set to an invalid value
    And the request body includes valid device identifier(s)
    When the HTTP POST request "query" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "The value of queryType can only be IMEIBIND,AREALIMIT"

  @iot_sim_fraud_prevention_query_400_missing_device
  Scenario: Query operation with missing device identifiers
    Given the request body property "$.device" is not included
    And the header "Authorization" is set to a valid access token which does not identify a single device
    When the HTTP POST request "query" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "At least one of phoneNumber, networkAccessIdentifier, ipv4Address and ipv6Address must be specified"

  @iot_sim_fraud_prevention_query_401_expired_token
  Scenario: Query operation with expired access token
    Given the header "Authorization" is set to an expired access token
    And a valid query request body
    When the HTTP POST request "query" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @iot_sim_fraud_prevention_query_403_permission_denied
  Scenario: Query operation without required scope
    Given the header "Authorization" is set to a valid access token without scope "iot-sim-fraud-prevention:query"
    And a valid query request body
    When the HTTP POST request "query" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @iot_sim_fraud_prevention_query_404_device_not_found
  Scenario: Query operation for unknown device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" includes identifiers that cannot be matched to a registered device
    When the HTTP POST request "query" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @iot_sim_fraud_prevention_query_422_unnecessary_identifier
  Scenario: Query operation with unnecessary device identifier when using 3-legged token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the HTTP POST request "query" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_query_422_missing_identifier
  Scenario: Query operation with missing device identifier when using 2-legged token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the HTTP POST request "query" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_query_422_unsupported_identifier
  Scenario: Query operation with unsupported device identifier
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTP POST request "query" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @iot_sim_fraud_prevention_query_429_quota_exceeded
  Scenario: Query operation exceeding quota limit
    Given the API consumer has exceeded their quota limit
    And a valid query request body
    When the HTTP POST request "query" is sent
    Then the response status code is 429
    And the response property "$.status" is 429
    And the response property "$.code" is "QUOTA_EXCEEDED"
    And the response property "$.message" contains a user friendly text
