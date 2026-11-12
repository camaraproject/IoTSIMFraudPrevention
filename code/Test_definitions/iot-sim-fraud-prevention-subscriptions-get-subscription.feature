Feature: CAMARA IoT SIM Fraud Prevention Subscriptions, v0.2.0 - Operation getSubscription

    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * An existing subscription created by the API consumer, and its subscription ID
    # * A valid access token with scope "iot-sim-fraud-prevention-subscriptions:read"
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention-subscriptions.yaml

  Background: Common getSubscription setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention-subscriptions/v0.2/subscriptions/{subscriptionId}"
    And the path parameter "subscriptionId" is set to the ID of an existing subscription
    And the header "Authorization" is set to a valid access token with scope "iot-sim-fraud-prevention-subscriptions:read"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_subscriptions_get_success
  Scenario: Successfully retrieve an existing subscription
    Given an existing subscription created by the same API consumer
    When the HTTP GET request "getSubscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/Subscription"
    And the response property "$.id" is not empty
    And the response property "$.types[0]" is not empty

  @iot_sim_fraud_prevention_subscriptions_get_success_event_type
  Scenario: Successfully retrieve a subscription with its event type
    Given an existing subscription created by the same API consumer
    And the subscription was created for "org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change"
    When the HTTP GET request "getSubscription" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema defined by "#/components/schemas/Subscription"
    And the response property "$.id" is not empty
    And the response property "$.types[0]" is "org.camaraproject.iot-sim-fraud-prevention-subscriptions.v0.imei-change"
