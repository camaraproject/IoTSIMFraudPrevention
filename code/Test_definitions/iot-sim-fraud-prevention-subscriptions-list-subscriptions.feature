Feature: CAMARA IoT SIM Fraud Prevention Subscriptions, vwip - Operation listSubscriptions

    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * At least one existing subscription for the device identified by the access token
    # * A valid access token with scope "iot-sim-fraud-prevention-subscriptions:read"
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention-subscriptions.yaml

  Background: Common listSubscriptions setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention-subscriptions/vwip/subscriptions"
    And the header "Authorization" is set to a valid access token with scope "iot-sim-fraud-prevention-subscriptions:read"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_subscriptions_list_success
  Scenario: Successfully list existing subscriptions
    Given at least one subscription exists for the device identified by the access token
    When the HTTP GET request "listSubscriptions" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" is not empty
    And the response property "$.subscriptions[0].id" is not empty
    And the response property "$.pagination" is not empty

  @iot_sim_fraud_prevention_subscriptions_list_success_paginated
  Scenario: Successfully list subscriptions with pagination parameters
    Given at least one subscription exists for the device identified by the access token
    And the query parameter "page" is set to 1
    And the query parameter "perPage" is set to 10
    When the HTTP GET request "listSubscriptions" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" is not empty
    And the response property "$.pagination" is not empty
