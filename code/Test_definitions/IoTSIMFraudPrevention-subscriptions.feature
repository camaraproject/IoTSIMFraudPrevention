Feature: CAMARA IoT SIM Fraud Prevention API, vwip - Operation SubscribeFraudPrevention
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * Valid device identifiers (phoneNumber, IPv4/IPv6 addresses)
  # * Valid callback URLs
  # * Access tokens with appropriate scopes
  # * Test devices with known IMEIs and locations

  Background: Common subscription setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention/wip/subscribe"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/parameters/x-correlator"

  # Success scenarios
  @iot_sim_subscribe_01_phone_number_2legged
  Scenario: Subscribe with phoneNumber using 2-legged token
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.config.subscriptionDetail.device.phoneNumber" is set to a valid phoneNumber
    And the request body property "$.types" is set to ["IMEIBIND"]
    And the request body property "$.sink" is set to a valid callback URL
    And the request body property "$.protocol" is set to "HTTP"
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"
    And the response property "$.id" exists

  @iot_sim_subscribe_02_ipv4_address
  Scenario: Subscribe with IPv4 address
    Given the request body property "$.config.subscriptionDetail.device.ipv4Address" is set to a valid IPv4 address
    And valid subscription parameters
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 201
    And the response property "$.protocol" is "HTTP"

  # Error scenarios - Authentication
  @iot_sim_subscribe_401.1_no_auth
  Scenario: Missing authentication
    Given the header "Authorization" is not sent
    And valid subscription parameters
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  # Error scenarios - Device identification
  @iot_sim_subscribe_422.1_missing_device_id
  Scenario: Missing device identifier with 2-legged token
    Given the header "Authorization" is set to a valid 2-legged access token
    And the request body property "$.config.subscriptionDetail.device" is an empty object
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"

  @iot_sim_subscribe_422.2_unnecessary_device_id
  Scenario: Unnecessary device identifier with 3-legged token
    Given the header "Authorization" is set to a valid 3-legged access token
    And the request body property "$.config.subscriptionDetail.device.phoneNumber" is set
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"

  # Error scenarios - Invalid inputs
  @iot_sim_subscribe_400.1_invalid_phone
  Scenario: Invalid phone number format
    Given the request body property "$.config.subscriptionDetail.device.phoneNumber" is set to "invalid-format"
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @iot_sim_subscribe_400.2_invalid_protocol
  Scenario: Unsupported protocol
    Given the request body property "$.protocol" is set to "UNSUPPORTED"
    When the request "SubscribeFraudPrevention" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  # Notification testing
  @iot_sim_subscribe_03_notification_reception
  Scenario: Verify notification reception
    Given a successful subscription exists
    When an IMEI_CHANGE event occurs for the subscribed device
    Then a notification is received at the callback URL
    And the notification body complies with the OAS schema at "/components/schemas/NoticeEvent"
    And the notification property "$.type" is "IMEI_CHANGE"

  # Subscription lifecycle
  @iot_sim_subscribe_04_subscription_expiry
  Scenario: Subscription expires correctly
    Given a subscription with near-term expiration exists
    When the expiration time passes
    Then a SUBSCRIBE_END notification is received
    And subsequent queries return 404 for the subscription
