@iot_sim_fraud_prevention_subscriptions_notifications
@notification-delivery
Feature: CAMARA IoT SIM Fraud Prevention Subscriptions API v1.0.0 - Notification Delivery Validation

    This feature validates that the API server correctly sends notifications to the registered callback sink
    when subscribed events occur. It also verifies that subscription constraints (expiration time, maximum events)
    and lifecycle operations (deletion) are honoured.

    These tests require a controllable test environment where:
    - A mock sink endpoint can be started to receive and inspect notifications.
    - The API server can be triggered to generate events (e.g., IMEI change, area boundary crossing).
    - Time can be advanced artificially (or tests wait for expiration) to verify expiry behaviour.

    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * A subscription creation endpoint as defined in the subscriptions API.
    # * Ability to simulate events for a given device (e.g., via internal test hooks or network simulators).
    # * A mock sink endpoint that can capture notifications and verify headers, payload, and authentication.
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention-subscriptions.yaml, version 1.0.0

  Background: Common setup for notification delivery tests
    Given a mock sink is running at a known URL "http://mock-sink.example.com/notify"
    And the mock sink is configured to accept notifications with the expected sinkCredential
    And the API server is configured to send notifications to that sink

######### Notification Delivery – Basic Functionality #################################

  @notification_delivery_imei_change
  Scenario: IMEI change notification is delivered to the sink
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sink               | http://mock-sink.example.com/notify |
      | sinkCredential     | ACCESSTOKEN with token "valid-token" |
    When an IMEI change event occurs for the subscribed device
    Then the mock sink receives a POST request
    And the request has header "Authorization" set to "Bearer valid-token"
    And the request header "x-correlator" matches the one sent by the server
    And the request body complies with the schema "#/components/schemas/NoticeEvent"
    And the request body property "$.type" is "IMEI_CHANGE"
    And the request body property "$.data.imei" is present
    And the response status code returned by the sink is 204

  @notification_delivery_area_change
  Scenario: Area change notification is delivered to the sink
    Given a subscription for AREA_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sink               | http://mock-sink.example.com/notify |
      | sinkCredential     | ACCESSTOKEN with token "valid-token" |
    When an area change event (enter/leave) occurs for the subscribed device
    Then the mock sink receives a POST request
    And the request has header "Authorization" set to "Bearer valid-token"
    And the request header "x-correlator" matches the one sent by the server
    And the request body complies with the schema "#/components/schemas/NoticeEvent"
    And the request body property "$.type" is "AREA_CHANGE"
    And the request body property "$.data.area" is present
    And the response status code returned by the sink is 204

  @notification_delivery_multiple_events
  Scenario: Multiple events are delivered as they occur
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sink               | http://mock-sink.example.com/notify |
    When 3 IMEI change events occur for the subscribed device
    Then the mock sink receives exactly 3 POST requests
    And each request body property "$.type" is "IMEI_CHANGE"

######### Notification Delivery – Constraints ##########################################

  @notification_delivery_expiration_time
  Scenario: Notifications stop after subscriptionExpireTime
    Given the current time is "2025-01-01T12:00:00Z"
    And a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber      | +123456789 |
      | subscriptionExpireTime  | 2025-01-01T12:05:00Z |
      | sink                    | http://mock-sink.example.com/notify |
    When an IMEI change event occurs at "2025-01-01T12:04:00Z" (before expiration)
    Then the mock sink receives the notification
    When an IMEI change event occurs at "2025-01-01T12:06:00Z" (after expiration)
    Then the mock sink receives no further notifications

  @notification_delivery_max_events
  Scenario: Notifications stop after subscriptionMaxEvents is reached
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber      | +123456789 |
      | subscriptionMaxEvents   | 3 |
      | sink                    | http://mock-sink.example.com/notify |
    When 3 IMEI change events occur for the subscribed device
    Then the mock sink receives 3 notifications
    When a 4th IMEI change event occurs
    Then the mock sink receives no notification for the 4th event

  @notification_delivery_delete_subscription
  Scenario: Notifications stop after subscription is deleted
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sink               | http://mock-sink.example.com/notify |
    When an IMEI change event occurs
    Then the mock sink receives the notification
    When the subscription is deleted (e.g., via a DELETE endpoint if available, or through an administrative action)
    And another IMEI change event occurs
    Then the mock sink receives no further notifications

######### Notification Delivery – Sink Credential Handling #############################

  @notification_delivery_credential_plain
  Scenario: Notification uses PLAIN credential (Basic Auth)
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sinkCredential     | PLAIN with username "user" and password "pass" |
      | sink               | http://mock-sink.example.com/notify |
    When an IMEI change event occurs
    Then the mock sink receives a request with header "Authorization" set to "Basic dXNlcjpwYXNz" (Base64 of "user:pass")

  @notification_delivery_credential_accesstoken
  Scenario: Notification uses ACCESSTOKEN credential (Bearer token)
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sinkCredential     | ACCESSTOKEN with token "abc123" and tokenType "bearer" |
      | sink               | http://mock-sink.example.com/notify |
    When an IMEI change event occurs
    Then the mock sink receives a request with header "Authorization" set to "Bearer abc123"

  @notification_delivery_credential_refreshtoken
  Scenario: Notification uses REFRESHTOKEN credential – access token is used
    Given a subscription for IMEI_CHANGE events is created with:
      | device.phoneNumber | +123456789 |
      | sinkCredential     | REFRESHTOKEN with accessToken "def456", accessTokenType "bearer", refreshToken "refresh", refreshTokenEndpoint "https://auth.example.com/token" |
      | sink               | http://mock-sink.example.com/notify |
    When an IMEI change event occurs
    Then the mock sink receives a request with header "Authorization" set to "Bearer def456"
    # Note: Token refresh behaviour is not tested here; it would require the access token to expire.

######### Notification Delivery – Sink Modification (if update endpoint exists) #########
# These scenarios are placeholders for future API versions that support subscription updates.
# They are marked as @future and may be skipped in current test runs.

  @future @notification_delivery_sink_modification
  Scenario: Notifications are sent to the modified sink after sink URL is updated
    Given a subscription exists with sink "http://old-sink.example.com"
    When the subscription sink is updated to "http://mock-sink.example.com/notify"
    And an IMEI change event occurs
    Then the mock sink receives the notification (at the new URL)

  @future @notification_delivery_sink_nullified
  Scenario: Notifications cease when sink is set to null
    Given a subscription exists with sink "http://mock-sink.example.com/notify"
    When the subscription sink is set to null (i.e., webhook disabled)
    And an IMEI change event occurs
    Then the mock sink receives no notification

  @future @notification_delivery_credential_modification
  Scenario: New credential is used after sinkCredential update
    Given a subscription exists with sinkCredential ACCESSTOKEN token "old-token"
    When the subscription sinkCredential is updated to ACCESSTOKEN token "new-token"
    And an IMEI change event occurs
    Then the mock sink receives a request with Authorization header "Bearer new-token"