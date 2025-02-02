# 系統架構文件

## 系統概述

本文件描述 Conector DOOH SSP 平台的系統架構，供內部技術團隊參考。

## 核心元件

### 1. Bid Request 處理器
- 接收 DSP 請求
- 驗證請求格式
- 處理競價邏輯
- 回應處理

### 2. 廣告空間管理
- 場域管理
- 螢幕管理
- 排程系統
- 播放控制

### 3. 報表系統
- 即時統計
- 曝光追蹤
- 收益分析
- 場域分析

## 資料庫結構

### Ad Spaces（廣告版位）
```ruby
create_table "ad_spaces" do |t|
  t.string   "name"
  t.string   "venue_type"
  t.integer  "width"
  t.integer  "height"
  t.decimal  "floor_price"
  t.jsonb    "targeting"
  t.boolean  "is_active"
  t.timestamps
end
```

### Ad Units（廣告單元）
```ruby
create_table "ad_units" do |t|
  t.references :ad_space
  t.string     "size"
  t.integer    "fps"
  t.integer    "min_duration"
  t.integer    "max_duration"
  t.string     "supported_formats", array: true
  t.jsonb      "settings"
  t.timestamps
end
```

## API 端點

### 內部 API
- `POST /api/internal/v1/ad_spaces`
- `GET /api/internal/v1/analytics`
- `POST /api/internal/v1/schedules`

### 外部 API
- `POST /api/v1/bid_requests`
- `POST /api/v1/creatives`
- `GET /api/v1/venues`

## 部署架構

### 生產環境
- Load Balancer: AWS ALB
- Application: ECS Fargate
- Database: RDS PostgreSQL
- Cache: Redis
- Storage: S3

### 測試環境
- 獨立的測試資料庫
- 模擬的場域資料
- 測試用 DSP 端點

## 監控與警報

### 系統監控
- CPU 使用率
- 記憶體使用率
- 資料庫連接數
- API 回應時間

### 業務監控
- 每分鐘請求數
- 競價成功率
- 廣告播放狀態
- 收益追蹤

## 開發流程

### Git 工作流程
1. 功能分支（feature/*）
2. 開發分支（develop）
3. 測試分支（staging）
4. 主分支（main）

### 部署流程
1. 程式碼審查
2. 自動化測試
3. 測試環境部署
4. 生產環境部署
