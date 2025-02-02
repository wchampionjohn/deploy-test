# DOOH SSP 整合指南

## DSP 整合規格

### 1. Endpoint 需求
- DSP 需提供接收 bid request 的固定 endpoint
- 使用 HTTPS 協議
- 支援 POST 請求
- 支援 OpenRTB 2.6 協議

### 2. Bid Request 範例
以全聯福利中心的數位看板為例：

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "imp": [{
    "id": "1",
    "tagid": "pxmart_taipei_neihu_01",
    "secure": 1,
    "bidfloor": 100.00,
    "bidfloorcur": "TWD",
    "dooh": {
      "venue": "RETAIL.SUPERMARKET",
      "physical": {
        "w": 1920,
        "h": 1080,
        "unit": "inches",
        "type": "LCD"
      },
      "playout": {
        "fps": 30,
        "minduration": 15,
        "maxduration": 30
      }
    }
  }],
  "device": {
    "geo": {
      "lat": 25.0780,
      "lon": 121.5757,
      "type": 1,
      "country": "TWN",
      "city": "Taipei",
      "zip": "114",
      "street": "港墘路"
    }
  },
  "dooh": {
    "venuetype": ["RETAIL.SUPERMARKET"],
    "publisher": {
      "id": "pxmart",
      "name": "全聯福利中心"
    },
    "venue": {
      "id": "TPE_114_01",
      "name": "全聯內湖港墘店",
      "traffic": 3000
    }
  }
}
```

### 3. Bid Response 規格
DSP 回應，格式如下：

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "seatbid": [{
    "bid": [{
      "id": "1",
      "impid": "1",
      "price": 150.00,
      "adm": {
        "video": {
          "content": "https://cdn.example.com/ads/video123.mp4",
          "duration": 15,
          "creative_id": "creative123",
          "advertiser_id": "adv123",
          "cache_ttl": 604800,  // 素材快取時間（秒）
          "attributes": {
            "delivery": 1,      // 1: Download and play
            "playback": 1,      // 1: Auto-play
            "mute": 1,          // 1: Auto-mute
            "preload": 1        // 1: 預載
          }
        },
        "fallback": {          // 備用素材
          "type": "image",
          "content": "https://cdn.example.com/ads/fallback123.jpg",
          "duration": 15
        }
      },
      "adomain": ["advertiser.com"],
      "crid": "creative123",
      "w": 1920,
      "h": 1080
    }]
  }]
}
```

### 4. 素材處理機制

#### 1. 素材預載機制

##### 1. 預載策略
- **定時預載**：系統每天凌晨 3:00 自動同步新素材
- **排程預載**：根據投放排程提前 24 小時預載
- **緊急預載**：新素材可透過 API 觸發立即預載
- **智能預載**：根據設備存儲空間動態調整預載量

##### 2. 素材生命週期
```
上傳 -> 驗證 -> 預載 -> 等待播放 -> 播放 -> 清理
```

##### 3. 預載優先順序
1. 已排程廣告素材
2. 高頻投放素材
3. 新上架素材
4. 備用素材

##### 4. 存儲管理
- 設備端保留至少 20% 可用空間
- 優先清理過期素材
- 保留近期播放素材
- 定期清理未使用素材

##### 5. 網路考量
- 支援斷點續傳
- 網路限速保護
- 備用 CDN 節點
- 本地快取機制

#### 2. 素材狀態查詢

##### 1. 查詢單個素材狀態
```
GET /api/v1/creative_status?creative_id=creative123
```

回應：
```json
{
  "creative_id": "creative123",
  "status": "ready",
  "devices": [{
    "device_id": "device123",
    "status": "downloaded",    // downloaded, downloading, pending, failed
    "progress": 100,           // 下載進度（%）
    "last_played": "2025-02-02T10:00:00Z",
    "play_count": 5,
    "storage": {
      "path": "/ads/creative123.mp4",
      "size": 15728640,        // 檔案大小（bytes）
      "downloaded_at": "2025-02-01T03:00:00Z"
    },
    "error": null             // 若失敗，顯示錯誤原因
  }]
}
```

##### 2. 批量查詢素材狀態
```
POST /api/v1/creative_status/batch
```

請求：
```json
{
  "creative_ids": ["creative123", "creative124"]
}
```

### 5. 回應狀態碼
- 200: 成功出價
- 204: 無出價（No bid）
- 400: 請求格式錯誤
- 422: 無法處理的請求
- 500: 系統錯誤

### 6. 測試流程
1. DSP 提供測試 endpoint
2. 我們發送測試 bid request
3. 確認回應格式和時間
4. 測試不同場域案例
5. 驗證廣告播放

## 離線播放支援

### 1. Bid Request 擴充欄位

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "imp": [{
    "id": "1",
    "tagid": "pxmart_taipei_neihu_01",
    "secure": 1,
    "bidfloor": 100.00,
    "bidfloorcur": "TWD",
    "dooh": {
      "venue": "RETAIL.SUPERMARKET",
      "physical": {
        "w": 1920,
        "h": 1080,
        "unit": "inches",
        "type": "LCD"
      },
      "playout": {
        "fps": 30,
        "minduration": 15,
        "maxduration": 30
      }
    }
  }],
  "device": {
    "geo": {
      "lat": 25.0780,
      "lon": 121.5757,
      "type": 1,
      "country": "TWN",
      "city": "Taipei",
      "zip": "114"
    },
    "storage": {
      "available": 1073741824,     // 可用儲存空間（bytes）
      "total": 4294967296          // 總儲存空間（bytes）
    },
    "network": {
      "type": "4g",                // network type: 4g, 3g, wifi
      "connection": "unstable"      // stable, unstable
    }
  },
  "cached_creatives": [            // 已緩存的素材列表
    "creative123",
    "creative124"
  ],
  "scheduled_slots": [             // 已排程的時段
    {
      "start_time": "2025-02-02T15:00:00Z",
      "end_time": "2025-02-02T16:00:00Z"
    }
  ]
}
```

### 2. 播放完成回報（ACK）機制

#### 回報 API
```
POST /api/v1/bid_requests/ack
Content-Type: application/json

{
  "impression_id": "imp123",
  "played_at": "2025-02-02T15:30:00Z",
  "duration": 15,
  "status": "completed",          // completed, partial, failed
  "device_status": {
    "storage": {
      "available": 1073741824
    },
    "network": {
      "type": "4g",
      "connection": "stable"
    },
    "error": null                 // 如果失敗，提供錯誤原因
  }
}
```

#### 回報時機
1. 廣告播放完成時
2. 廣告播放中斷時
3. 設備狀態改變時（如網路恢復）

#### 回報重試機制
- 離線狀態下儲存回報資訊
- 網路恢復後自動重試
- 最多重試 3 次
- 重試間隔：1分鐘、5分鐘、15分鐘

### 3. 離線播放處理流程

1. **請求階段**
   - 設備發送 bid request 時附加存儲和網路狀態
   - 提供已緩存素材清單和排程資訊
   - SSP 根據設備狀態決定是否需要新素材

2. **回應處理**
   - 設備接收 bid response 後立即下載素材
   - 將素材和播放資訊存入本地資料庫
   - 設置播放排程

3. **播放執行**
   - 按排程播放廣告
   - 記錄播放狀態
   - 準備回報資訊

4. **回報機制**
   - 播放完成後立即回報
   - 如果離線，將回報資訊存入佇列
   - 網路恢復後執行回報

### 4. 錯誤處理

#### 素材下載失敗
- 記錄失敗原因
- 使用備用素材
- 安排重新下載

#### 播放失敗
- 記錄錯誤原因
- 嘗試使用備用素材
- 回報播放狀態

#### 回報失敗
- 本地儲存回報資訊
- 實作重試機制
- 定期檢查未完成回報

## 聯絡方式

技術支援：
- Email: conector.support@kabob.io
- 文件網址: docs.conector.com
- API 狀態: status.conector.com
