Feature: CAMARA IoT SIM Fraud Prevention API, vwip - Unbind Operation
  Background:
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/wip/unbind"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value

  @iot_sim_unbind_01_successful
  Scenario: Successful IMEI unbind
    Given a device is currently bound
    And the request body property "$.device.phoneNumber" is set to that device's phoneNumber
    And the request body property "$.unBindType" is set to "IMEIBIND"
    When the request "UnBindDeviceImei" is sent
    Then the response status code is 200
    And the response property "$.unbound" is "TRUE"

  @iot_sim_unbind_02_area_restriction
  Scenario: Successful area restriction unbind
    Given a device has area restrictions
    And the request body property "$.device.ipv6Address" is set to that device's IPv6 address
    And the request body property "$.unBindType" is set to "AREALIMIT"
    When the request "UnBindDeviceImei" is sent
    Then the response status code is 200

  @iot_sim_unbind_404_device_not_found
  Scenario: Unbind non-existent device
    Given the request body property "$.device.phoneNumber" is set to a non-existent phoneNumber
    And the request body property "$.unBindType" is set to "IMEIBIND"
    When the request "UnBindDeviceImei" is sent
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"

  @iot_sim_unbind_422_already_unbound
  Scenario: Attempt to unbind already unbound device
    Given a device is not bound
    And the request body property "$.device.phoneNumber" is set to that device's phoneNumber
    And the request body property "$.unBindType" is set to "IMEIBIND"
    When the request "UnBindDeviceImei" is sent
    Then the response status code is 422
    And the response property "$.code" is "UNNECESSARY_UNBIND_IMEI"
