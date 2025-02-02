# API Documentation

## Authentication

### Bearer Token Authentication
All API requests must include a Bearer token in the Authorization header:
```
Authorization: Bearer <your_api_token>
```

## Endpoints

### 1. Bid Request Endpoint

```
POST /api/v1/bid_requests
```

#### Request Headers
```
Content-Type: application/json
Authorization: Bearer <your_api_token>
```

#### Request Body
```json
{
  "bid_request": {
    "ad_unit_id": "123",                  // Required, 廣告單元 ID
    "device_id": "456",                   // Required, 裝置 ID
    "ip": "192.168.1.1",                  // Optional, 裝置 IP 地址
    "user_agent": "Mozilla/5.0",          // Optional, User Agent
    "timestamp": "2025-02-02T10:00:00Z",  // Optional, 請求時間
    "dt": 1738484000,                     // Optional, 預計播放時間 (Unix timestamp in seconds)
    "geo": {                              // Optional, 地理位置
      "lat": 25.0330,                     // Optional, 緯度
      "lon": 121.5654                     // Optional, 經度
    }
  }
}
```

#### Response
- Success Response (200 OK):
```json
{
  "id": "bid-123",
  "seatbid": [{
    "bid": [{
      "id": "1",
      "impid": "1",
      "price": 2.5,
      "nurl": "http://example.com/win",
      "burl": "http://example.com/billing",
      "adm": "<VAST>...</VAST>"
    }]
  }]
}
```

- Error Response (422 Unprocessable Entity):
```json
{
  "error": "Error message"
}
```

See [OpenRTB Implementation Guide](openrtb_guide.md) for detailed bid response format.

### 2. Creative Approval Endpoint

```
POST /api/v1/creatives
```

Submit creatives for approval before using them in bid responses.

#### Request Body
```json
{
  "creative": {
    "id": "creative123",
    "name": "Summer Campaign",
    "advertiser_id": "adv123",
    "type": "video",
    "duration": 15,
    "url": "https://example.com/creative.mp4",
    "width": 1920,
    "height": 1080
  }
}
```

## Rate Limiting

- Rate limit: 100 requests per second per token
- Rate limit headers included in response:
  ```
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 99
  X-RateLimit-Reset: 1580576923
  ```

## Testing

### Test Endpoints
- Staging: `https://staging-ssp.conector.com`
- Production: `https://ssp.conector.com`

### Test Credentials
Contact our support team to obtain test credentials.

## Support

For technical support:
- Email: support@conector.com
- Technical documentation: https://docs.conector.com
- API status: https://status.conector.com
