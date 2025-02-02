# OpenRTB Implementation Guide

## Overview

This document outlines the OpenRTB 2.6 implementation for our DOOH SSP platform, focusing on DOOH-specific extensions and requirements.

## Bid Request Specification

### Basic Structure
```json
{
  "id": "1234567890",
  "at": 2,
  "cur": ["USD"],
  "imp": [{
    "id": "1",
    "tagid": "screen123",
    "secure": 1,
    "bidfloor": 10.0,
    "bidfloorcur": "USD",
    "dooh": {
      "venue": "MALL.INDOOR",
      "physical": {
        "w": 1920,
        "h": 1080,
        "unit": "inches",
        "type": "display"
      },
      "playout": {
        "fps": 30,
        "minduration": 5,
        "maxduration": 30
      }
    }
  }],
  "device": {
    "ua": "Mozilla/5.0...",
    "ip": "192.168.1.1",
    "geo": {
      "lat": 25.0330,
      "lon": 121.5654,
      "type": 1,
      "country": "TWN",
      "city": "Taipei",
      "zip": "100"
    },
    "devicetype": 7
  }
}
```

### DOOH-Specific Fields

#### Venue Types
- MALL.INDOOR
- MALL.OUTDOOR
- OFFICE.LOBBY
- TRANSIT.STATION
- STREET.BILLBOARD

#### Physical Specifications
- Width and height in pixels
- Screen dimensions in inches
- Display type (LED, LCD, etc.)

#### Playout Requirements
- FPS (frames per second)
- Minimum and maximum duration
- Supported media formats

## Bid Response Specification

```json
{
  "id": "1234567890",
  "seatbid": [{
    "bid": [{
      "id": "1",
      "impid": "1",
      "price": 15.00,
      "nurl": "http://example.com/win",
      "adm": "creative_markup",
      "adomain": ["advertiser.com"],
      "crid": "creative123"
    }]
  }]
}
```

## Private Marketplace (PMP) Deals

### Deal Types
1. Private Auction
2. Preferred Deals
3. Programmatic Guaranteed

### Deal ID Format
- Format: `DOOH-{venue_type}-{deal_type}-{id}`
- Example: `DOOH-MALL-PA-123`

## Error Handling

### HTTP Status Codes
- 200: Success
- 204: No bid
- 400: Bad request
- 401: Unauthorized
- 403: Forbidden
- 422: Unprocessable entity
- 500: Internal server error

### Error Response Format
```json
{
  "error": {
    "code": 1,
    "message": "Invalid bid floor currency"
  }
}
```
