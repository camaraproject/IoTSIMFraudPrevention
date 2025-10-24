# IoT SIM Fraud Prevention Subscriptions API

## Overview
This API enables enterprise customers to subscribe to risk control information for IoT SIM cards. It provides mechanisms to detect and respond to unauthorized device (IMEI) or location changes through event notifications.

## Key Features
- **SIM Card Binding**: Bind SIM cards to specific devices (IMEI) to prevent unauthorized usage
- **Regional Restrictions**: Define geographical areas where devices are permitted to operate
- **Real-time Notifications**: Receive alerts when bound devices change or move outside permitted areas
- **Flexible Subscription Model**: Configure expiration times and maximum event thresholds

## API Endpoints

### `POST /subscribe`
Create a new subscription for monitoring IMEI or area changes. Returns subscription details including a unique subscription ID.

## Authentication
- **2-legged tokens**: Require explicit device identification in requests
- **3-legged tokens**: Derive device identity from the token (user-consented)

## Event Types
- `IMEI_CHANGE`: Triggered when device IMEI changes
- `AREA_CHANGE`: Triggered when device moves outside permitted area
- `SUBSCRIBE_END`: Automatic notification when subscription ends

## Notification Callback
Implement `POST /{$request.body#/sink}` endpoint to receive event notifications in CloudEvents format.

## Error Handling
The API returns standardized error responses including:
- 400: Invalid requests
- 401: Authentication failures  
- 403: Permission issues
- 404: Resource not found
- 422: Unprocessable content
- 429: Rate limiting

## Getting Started

### Prerequisites
- Valid access token with appropriate scopes
- Callback endpoint for receiving notifications
- Device identifiers (phone number, IP address, etc.)

### Example Request
```json
POST /subscribe
{
  "config": {
    "subscriptionExpireTime": "2024-03-22T05:40:58.469Z",
    "initialEvent": true,
    "subscriptionMaxEvents": 10,
    "subscriptionDetail": {
      "device": {
        "phoneNumber": "+123456789"
      }
    }
  },
  "types": ["IMEIBIND"],
  "sink": "http://your-callback-server.com/notifications",
  "protocol": "HTTP",
  "sinkCredential": "PLAIN"
}
