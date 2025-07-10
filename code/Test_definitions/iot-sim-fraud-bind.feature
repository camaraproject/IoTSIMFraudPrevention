Feature: CAMARA IoT SIM Fraud Prevention API, vwip - Bind Operation
  Background:
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/wip/bind"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value

  @iot_sim_bind_01_phone_number
  Scenario: Successful IMEI bind with phone number
    Given the request body property "$.device.phoneNumber" is set to a valid phoneNumber
    And the request body property "$.bindType" is set to "IMEIBIND"
    When the request "BindDeviceImei" is sent
    Then the response status code is 200
    And the response property "$.bound" is "TRUE"

  @iot_sim_bind_02_ipv4_address
  Scenario: Successful IMEI bind with IPv4 address
    Given the request body property "$.device.ipv4Address" is set to a valid IPv4 address
    And the request body property "$.bindType" is set to "IMEIBIND"
    When the request "BindDeviceImei" is sent
    Then the response status code is 200

  @iot_sim_bind_400_missing_bindType
  Scenario: Missing bindType parameter
    Given the request body property "$.device.phoneNumber" is set to a valid phoneNumber
    And the request body does not contain "$.bindType"
    When the request "BindDeviceImei" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @iot_sim_bind_422_unnecessary_identifier
  Scenario: Unnecessary device identifier with 3-legged token
    Given the header "Authorization" is set to a valid 3-legged access token
    And the request body property "$.device.phoneNumber" is set to a valid phoneNumber
    And the request body property "$.bindType" is set to "IMEIBIND"
    When the request "BindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"

  @iot_sim_bind_422_already_bound
  Scenario: Attempt to bind already bound device
    Given a device is already bound
    And the request body property "$.device.phoneNumber" is set to that device's phoneNumber
    And the request body property "$.bindType" is set to "IMEIBIND"
    When the request "BindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.code" is "UNNECESSARY_BIND_IMEI"
