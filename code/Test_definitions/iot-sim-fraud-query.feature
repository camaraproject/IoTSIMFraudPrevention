Feature: CAMARA IoT SIM Fraud Prevention API, vwip-Query Operation
  Background:
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/wip/query"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value

  @iot_sim_query_01_bound_status
  Scenario: Query bound device status
    Given a device is currently bound
    And the request body property "$.device.phoneNumber" is set to that device's phoneNumber
    And the request body property "$.queryType" is set to "IMEIBIND"
    When the request "query" is sent
    Then the response status code is 200
    And the response property "$.imeiBind.bindStatus" is "BOUND"
    And the response property "$.imeiBind.bindImei" exists

  @iot_sim_query_02_area_restriction
  Scenario: Query area restriction status
    Given a device has area restrictions
    And the request body property "$.device.ipv4Address" is set to that device's IPv4 address
    And the request body property "$.queryType" is set to "AREALIMIT"
    When the request "query" is sent
    Then the response status code is 200
    And the response property "$.areaLimit.areaLimitStatus" is "RESTRICTED"
    And the response property "$.areaLimit.limitArea" exists

  @iot_sim_query_400_invalid_query_type
  Scenario: Invalid query type
    Given the request body property "$.device.phoneNumber" is set to a valid phoneNumber
    And the request body property "$.queryType" is set to "INVALID_TYPE"
    When the request "query" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @iot_sim_query_403_insufficient_scope
  Scenario: Insufficient token scope
    Given the header "Authorization" is set to a token without required scope
    And valid query parameters
    When the request "query" is sent
    Then the response status code is 403
    And the response property "$.code" is "PERMISSION_DENIED"
