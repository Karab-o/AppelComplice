# Trip Insights API Documentation

## Overview
This document outlines the backend API endpoints required for the Trip Insights analytics dashboard. The API provides historical data analysis for taxi trip metrics including trip counts, fare analysis, payment methods, and geographical distribution.

## Base URL
```
https://api.tripinsights.com/v1
```

## Authentication
All API endpoints require authentication using Bearer tokens:
```
Authorization: Bearer <your-api-token>
```

## Endpoints

### 1. Analytics Data Endpoint

#### GET /analytics/historical
Retrieves historical analytics data for specified date ranges.

**Query Parameters:**
- `start_date_1` (required): Start date for first period (YYYY-MM-DD)
- `end_date_1` (required): End date for first period (YYYY-MM-DD)
- `start_date_2` (optional): Start date for second period (YYYY-MM-DD)
- `end_date_2` (optional): End date for second period (YYYY-MM-DD)
- `granularity` (optional): Data granularity - 'daily', 'weekly', 'monthly' (default: 'monthly')

**Example Request:**
```http
GET /analytics/historical?start_date_1=2024-07-01&end_date_1=2024-07-31&start_date_2=2024-06-01&end_date_2=2024-06-30
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "period_1": {
      "start_date": "2024-07-01",
      "end_date": "2024-07-31",
      "metrics": {
        "total_trips": {
          "value": 1200000,
          "formatted_value": "1.2M",
          "change_percentage": 5.2,
          "chart_data": {
            "labels": ["Jul 1", "Jul 8", "Jul 15", "Jul 22", "Jul 29"],
            "values": [180000, 165000, 175000, 190000, 210000]
          }
        },
        "average_fare": {
          "value": 15.50,
          "formatted_value": "$15.50",
          "change_percentage": -2.1,
          "chart_data": {
            "labels": ["Jul 1", "Jul 8", "Jul 15", "Jul 22", "Jul 29"],
            "values": [16.20, 15.80, 15.90, 15.70, 15.50]
          }
        },
        "payment_methods": {
          "total_trips": 1200000,
          "change_percentage": 5.0,
          "breakdown": {
            "cash": {
              "count": 400000,
              "percentage": 33.3
            },
            "card": {
              "count": 600000,
              "percentage": 50.0
            },
            "mobile": {
              "count": 200000,
              "percentage": 16.7
            }
          }
        },
        "boroughs": {
          "total_trips": 1200000,
          "change_percentage": -2.0,
          "breakdown": {
            "manhattan": {
              "count": 450000,
              "percentage": 37.5
            },
            "brooklyn": {
              "count": 350000,
              "percentage": 29.2
            },
            "queens": {
              "count": 250000,
              "percentage": 20.8
            },
            "bronx": {
              "count": 120000,
              "percentage": 10.0
            },
            "staten_island": {
              "count": 30000,
              "percentage": 2.5
            }
          }
        }
      }
    },
    "period_2": {
      // Similar structure for comparison period if provided
    }
  },
  "metadata": {
    "generated_at": "2024-10-10T12:00:00Z",
    "query_time_ms": 245
  }
}
```

### 2. Trip Metrics Endpoint

#### GET /analytics/trips
Retrieves detailed trip metrics for a specific time period.

**Query Parameters:**
- `start_date` (required): Start date (YYYY-MM-DD)
- `end_date` (required): End date (YYYY-MM-DD)
- `group_by` (optional): Grouping dimension - 'hour', 'day', 'week', 'month'
- `borough` (optional): Filter by specific borough
- `payment_method` (optional): Filter by payment method

**Response:**
```json
{
  "status": "success",
  "data": {
    "total_trips": 1200000,
    "total_revenue": 18600000,
    "average_fare": 15.50,
    "time_series": [
      {
        "period": "2024-07-01",
        "trips": 38000,
        "revenue": 589000,
        "average_fare": 15.50
      }
    ]
  }
}
```

### 3. Fare Analysis Endpoint

#### GET /analytics/fares
Retrieves fare distribution and analysis data.

**Query Parameters:**
- `start_date` (required): Start date (YYYY-MM-DD)
- `end_date` (required): End date (YYYY-MM-DD)
- `breakdown` (optional): 'borough', 'payment_method', 'time_of_day'

**Response:**
```json
{
  "status": "success",
  "data": {
    "average_fare": 15.50,
    "median_fare": 14.20,
    "fare_distribution": {
      "0-5": 50000,
      "5-10": 180000,
      "10-15": 420000,
      "15-20": 350000,
      "20-25": 150000,
      "25+": 50000
    },
    "breakdown": {
      // Breakdown data based on query parameter
    }
  }
}
```

### 4. Real-time Metrics Endpoint

#### GET /analytics/realtime
Retrieves current real-time metrics for dashboard display.

**Response:**
```json
{
  "status": "success",
  "data": {
    "active_trips": 15420,
    "active_drivers": 8950,
    "average_wait_time": 4.2,
    "current_demand_level": "high",
    "last_updated": "2024-10-10T12:00:00Z"
  }
}
```

## Error Responses

All endpoints return consistent error responses:

```json
{
  "status": "error",
  "error": {
    "code": "INVALID_DATE_RANGE",
    "message": "End date must be after start date",
    "details": {
      "start_date": "2024-07-31",
      "end_date": "2024-07-01"
    }
  }
}
```

### Common Error Codes:
- `INVALID_DATE_RANGE`: Date range validation failed
- `UNAUTHORIZED`: Invalid or missing authentication token
- `RATE_LIMIT_EXCEEDED`: API rate limit exceeded
- `INTERNAL_ERROR`: Server-side error occurred
- `INVALID_PARAMETERS`: Request parameters are invalid

## Rate Limits
- 1000 requests per hour per API key
- 100 requests per minute per API key
- Rate limit headers are included in all responses

## Data Freshness
- Historical data: Updated every 15 minutes
- Real-time metrics: Updated every 30 seconds
- Analytics aggregations: Updated hourly

## SDK Examples

### JavaScript/Node.js
```javascript
const TripInsightsAPI = require('trip-insights-sdk');

const client = new TripInsightsAPI({
  apiKey: 'your-api-key',
  baseURL: 'https://api.tripinsights.com/v1'
});

// Get historical analytics
const analytics = await client.analytics.getHistorical({
  startDate1: '2024-07-01',
  endDate1: '2024-07-31',
  startDate2: '2024-06-01',
  endDate2: '2024-06-30'
});
```

### Python
```python
from trip_insights import TripInsightsClient

client = TripInsightsClient(api_key='your-api-key')

# Get historical analytics
analytics = client.analytics.get_historical(
    start_date_1='2024-07-01',
    end_date_1='2024-07-31',
    start_date_2='2024-06-01',
    end_date_2='2024-06-30'
)
```

### cURL
```bash
curl -H "Authorization: Bearer your-api-key" \
  "https://api.tripinsights.com/v1/analytics/historical?start_date_1=2024-07-01&end_date_1=2024-07-31"
```

## Webhooks (Optional)

### Data Update Notifications
Register webhooks to receive notifications when new data is available:

```http
POST /webhooks/register
{
  "url": "https://your-app.com/webhook",
  "events": ["data_updated", "analytics_ready"],
  "secret": "your-webhook-secret"
}
```

## Support
For API support and questions:
- Email: api-support@tripinsights.com
- Documentation: https://docs.tripinsights.com
- Status Page: https://status.tripinsights.com