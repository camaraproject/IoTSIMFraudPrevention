Feature: IoT SIM Fraud Prevention Subscriptions - Notification Delivery (wip)

  This feature tests the end‑to‑end delivery of notifications for the explicit subscriptions model.
  It assumes the existence of:
    - A mock sink endpoint that can capture and verify incoming HTTP requests.
    - A test hook to trigger events (IMEI change, area change) for a given device.
    - The ability to control time or use short‑lived subscriptions for expiration tests.

  Background: Common setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention-subscriptions/vwip/subscribe"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token with scope "iot-sim-fraud-prevention-subscriptions:subscribe"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And a mock sink is available at "https://mock-sink.example.com/notify"

  @happy_path_imei_change
  Scenario: Receive notification when IMEI changes
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "IMEIBIND"
    And the sink is set to "https://mock-sink.example.com/notify"
    And the sink uses an access token "valid-bearer-token"
    When an IMEI change event is triggered for the same device
    Then a notification is received at the mock sink
    And the notification uses the Bearer token "valid-bearer-token"
    And the notification payload complies with the schema "#/components/schemas/NoticeEvent"
    And the payload property "$.type" is "IMEI_CHANGE"
    And the payload property "$.data.imei" matches the new IMEI

  @happy_path_area_change
  Scenario: Receive notification when area changes
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "AREALIMIT"
    And the sink is set to "https://mock-sink.example.com/notify"
    And the sink uses an access token "valid-bearer-token"
    When an area change event (enter/leave) is triggered for the same device
    Then a notification is received at the mock sink
    And the notification uses the Bearer token "valid-bearer-token"
    And the notification payload complies with the schema "#/components/schemas/NoticeEvent"
    And the payload property "$.type" is "AREA_CHANGE"
    And the payload property "$.data.area" is present

  @expiration_time
  Scenario: No notification after subscription expires
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "IMEIBIND"
    And subscriptionExpireTime is set to "2024-01-01T00:00:00Z" (a past date)
    And the sink is set to "https://mock-sink.example.com/notify"
    When an IMEI change event is triggered for the same device
    Then no notification is received at the mock sink

  @max_events_first_event
  Scenario: First event triggers a notification (below limit)
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "IMEIBIND"
    And subscriptionMaxEvents is set to 2
    And the sink is set to "https://mock-sink.example.com/notify"
    When an IMEI change event is triggered (first event)
    Then a notification is received at the mock sink

  @max_events_second_event
  Scenario: Second event triggers a notification (still below limit)
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "IMEIBIND"
    And subscriptionMaxEvents is set to 2
    And the sink is set to "https://mock-sink.example.com/notify"
    And one event has already been triggered (the count is 1)
    When an IMEI change event is triggered (second event)
    Then a notification is received at the mock sink

  @max_events_third_event
  Scenario: Third event does not trigger a notification (limit exceeded)
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "IMEIBIND"
    And subscriptionMaxEvents is set to 2
    And the sink is set to "https://mock-sink.example.com/notify"
    And two events have already been triggered (the limit is reached)
    When an IMEI change event is triggered (third event)
    Then no notification is received at the mock sink

  @deletion
  Scenario: No notification after subscription deleted
    Given a subscription for device with phoneNumber "+123456789"
    And the subscription type is "IMEIBIND"
    And the sink is set to "https://mock-sink.example.com/notify"
    And the subscription has been deleted
    When an IMEI change event is triggered for the same device
    Then no notification is received at the mock sink
