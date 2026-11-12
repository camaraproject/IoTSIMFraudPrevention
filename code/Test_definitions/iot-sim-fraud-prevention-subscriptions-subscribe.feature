Feature: CAMARA IoT SIM Fraud Prevention Subscriptions, v0.2.0 - Operation subscribeFraudPrevention

    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * A valid device identifier for subscription
    # * A valid sink URL and protocol (e.g., HTTP)
    # * A valid access token with scope "iot-sim-fraud-prevention-subscriptions:org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change:create"
    # * A valid access token with scope "iot-sim-fraud-prevention-subscriptions:org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.area-change:create"
    # * An access token that requires new authentication
    # * An access token without the required scope
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention-subscriptions.yaml

  Background: Common subscribeFraudPrevention setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention-subscriptions/v0.2/subscriptions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token with scope "iot-sim-fraud-prevention-subscriptions:org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change:create"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_subscribe_success_imei_change
  Scenario: Successfully subscribe to IMEI change events
    Given a valid subscription request body with types including "org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change"
    And the request body includes valid device identifier(s) in subscriptionDetail
    And the request body includes valid sink and protocol parameters
    And the request property "$.protocol" is set to "HTTP"
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/Subscription"
    And the response contains a valid subscription ID
    And the response property "$.types[0]" is "org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change"

  @iot_sim_fraud_prevention_subscribe_success_arealimit_change
  Scenario: Successfully subscribe to area limit change events
    Given a valid subscription request body with types including "org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.area-change"
    And the header "Authorization" is set to a valid access token with scope "iot-sim-fraud-prevention-subscriptions:org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.area-change:create"
    And the request body includes valid device identifier(s) in subscriptionDetail
    And the request body includes valid sink and protocol parameters
    And the request property "$.protocol" is set to "HTTP"
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/Subscription"
    And the response contains a valid subscription ID
    And the response property "$.types[0]" is "org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.area-change"

  @iot_sim_fraud_prevention_subscribe_async_success
  Scenario: Successfully create subscription asynchronously
    Given a valid subscription request body
    And the subscription is processed asynchronously
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/SubscriptionAsync"
    And the response property "$.id" is not empty

############### Error response scenarios ###########################

  @iot_sim_fraud_prevention_subscribe_400_missing_types
  Scenario: Subscribe operation with missing types parameter
    Given the request body does not include property "$.types"
    And the request body includes valid device identifier(s) in subscriptionDetail
    And the request body includes valid sink and protocol parameters
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "SubscriptionType must be specified"

  @iot_sim_fraud_prevention_subscribe_400_missing_sink
  Scenario: Subscribe operation with missing sink parameter
    Given the request body does not include property "$.sink"
    And the request body includes valid device identifier(s) in subscriptionDetail
    And the request body includes valid types and protocol parameters
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains "The sink field must be an accessible client address in order to notify the other end when an event occurs"

  @iot_sim_fraud_prevention_subscribe_400_invalid_protocol
  Scenario: Subscribe operation with invalid protocol value
    Given the request body property "$.protocol" is set to an invalid value
    And the request body includes valid device identifier(s) in subscriptionDetail
    And the request body includes valid types and sink parameters
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains "Only HTTP is supported"

  @iot_sim_fraud_prevention_subscribe_400_out_of_range_maxevents
  Scenario: Subscribe operation with out of range subscriptionMaxEvents
    Given the request body property "$.config.subscriptionMaxEvents" is set to a value out of range
    And the request body includes valid device identifier(s) in subscriptionDetail
    And the request body includes valid types, sink and protocol parameters
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains "The value of SubscriptionMaxEvents out of range"

  @iot_sim_fraud_prevention_subscribe_401_authentication_required
  Scenario: Subscribe operation requiring new authentication
    Given the header "Authorization" is set to an access token that requires new authentication
    And a valid subscription request body
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains "A new authentication is required"

  @iot_sim_fraud_prevention_subscribe_403_permission_denied
  Scenario: Subscribe operation without required scope
    Given the header "Authorization" is set to a valid access token without scope "iot-sim-fraud-prevention-subscriptions:org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change:create"
    And a valid subscription request body
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains "Client does not have sufficient permissions to perform this action"

  @iot_sim_fraud_prevention_subscribe_422_missing_identifier
  Scenario: Subscribe operation with missing device identifier when using 2-legged token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.config.subscriptionDetail.device" is not included
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains "An identifier is not included in the request and the device cannot be identified from the 2-legged access token"
  @iot_sim_fraud_prevention_subscriptions_subscribe_422_service_not_applicable
  Scenario: Subscribe operation for a device the service does not apply to
    Given a device identifier for which the IoT SIM Fraud Prevention service is not applicable
    When the HTTP POST request "subscribeFraudPrevention" is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user-friendly text
