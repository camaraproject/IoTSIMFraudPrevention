Feature: CAMARA IoT SIM Fraud Prevention Subscriptions, vwip - Operation deleteSubscription

    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * An existing subscription created by the API consumer, and its subscription ID
    # * A valid access token with scope "iot-sim-fraud-prevention-subscriptions:delete"
    #
    # References to OAS spec schemas refer to schemas specified in iot-sim-fraud-prevention-subscriptions.yaml

  Background: Common deleteSubscription setup
    Given an environment at "apiRoot"
    And the resource "/iot-sim-fraud-prevention-subscriptions/vwip/subscriptions/{subscriptionId}"
    And the path parameter "subscriptionId" is set to the ID of an existing subscription
    And the header "Authorization" is set to a valid access token with scope "iot-sim-fraud-prevention-subscriptions:delete"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

######### Happy Path Scenarios #################################

  @iot_sim_fraud_prevention_subscriptions_delete_success
  Scenario: Successfully delete an existing subscription
    Given an existing subscription created by the same API consumer
    When the HTTP DELETE request "deleteSubscription" is sent
    Then the response code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And no further notifications are sent to the sink of the deleted subscription

  @iot_sim_fraud_prevention_subscriptions_delete_async_success
  Scenario: Successfully accept an asynchronous subscription deletion
    Given an existing subscription created by the same API consumer
    And the subscription deletion is processed asynchronously
    When the HTTP DELETE request "deleteSubscription" is sent
    Then the response code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the schema defined by "#/components/schemas/SubscriptionAsync"
    And the response property "$.id" is not empty
