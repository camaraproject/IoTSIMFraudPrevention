Feature: IoT SIM Fraud Prevention Subscriptions Callback Handling (v1.0.0)

    # This file tests the API consumer's callback endpoint.
    # It validates that the consumer correctly handles incoming notifications.

    # Input to be provided by the implementation to the tester
    #
    # Testing assets:
    # * A valid notification payload for IMEI_CHANGE event
    # * A valid notification payload for AREA_CHANGE event
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention-subscriptions.yaml, version 1.0.0

  Background: Common IoT SIM Fraud Prevention Callbacks setup
    Given an environment at the callback sink URL
    And the resource "/iot-sim-fraud-prevention-subscriptions/vwip/subscribe"
    And the header "Content-Type" is set to "application/json"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_callback_success_imei_change
  Scenario: Successfully handle IMEI change notification
    Given a valid notification event with type "IMEI_CHANGE"
    And the notification includes required fields: id, type, time, data
    And the data includes subscriptionId, imei and device information
    When the HTTP POST request "SubscribeFraudPrevention" is sent to the callback endpoint
    Then the response code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # Additional payload validation (optional for consumer, but ensures correct handling)
    And the received notification body complies with the schema "#/components/schemas/NoticeEvent"
    And the payload property "$.type" is "IMEI_CHANGE"
    And the payload property "$.data.imei" is not empty

  @iot_sim_fraud_prevention_callback_success_area_change
  Scenario: Successfully handle area change notification
    Given a valid notification event with type "AREA_CHANGE"
    And the notification includes required fields: id, type, time, data
    And the data includes subscriptionId, area information and device information
    When the HTTP POST request "SubscribeFraudPrevention" is sent to the callback endpoint
    Then the response code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the received notification body complies with the schema "#/components/schemas/NoticeEvent"
    And the payload property "$.type" is "AREA_CHANGE"
    And the payload property "$.data.area" is not empty

############### Error response scenarios ###########################

  @iot_sim_fraud_prevention_callback_400_missing_id
  Scenario: Callback with missing id parameter
    Given the notification event does not include property "$.id"
    And the notification includes other required fields
    When the HTTP POST request "SubscribeFraudPrevention" is sent to the callback endpoint
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "Id must be specified"

  @iot_sim_fraud_prevention_callback_400_missing_type
  Scenario: Callback with missing type parameter
    Given the notification event does not include property "$.type"
    And the notification includes other required fields
    When the HTTP POST request "SubscribeFraudPrevention" is sent to the callback endpoint
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "Type must be specified"

  @iot_sim_fraud_prevention_callback_400_invalid_type
  Scenario: Callback with invalid type value
    Given the notification event property "$.type" is set to an invalid value
    And the notification includes other required fields
    When the HTTP POST request "SubscribeFraudPrevention" is sent to the callback endpoint
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "The value of type can only be IMEI_CHANGE,AREA_CHANGE"

  @iot_sim_fraud_prevention_callback_410_gone
  Scenario: Callback endpoint no longer available
    Given the callback endpoint is no longer available
    And a valid notification event
    When the HTTP POST request "SubscribeFraudPrevention" is sent to the callback endpoint
    Then the response status code is 410
    And the response property "$.status" is 410
    And the response property "$.code" is "GONE"
    And the response property "$.message" contains "Access to the target resource is no longer available"
