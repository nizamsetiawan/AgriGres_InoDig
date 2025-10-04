# Weather API Setup Guide

## OpenWeatherMap API Configuration

### 1. Get Free API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Get your API key from the dashboard

### 2. Configure API Key
Add your API key to the `.env` file:

```env
# OpenWeatherMap API Configuration
OPENWEATHER_API_KEY=your_actual_api_key_here
```

### 3. API Limits (Free Tier)
- **1,000 calls/day**
- **60 calls/minute**
- **Current weather data**
- **5-day forecast**

### 4. How It Works
- If API key is configured: Uses real weather data from OpenWeatherMap
- If API key is missing: Falls back to mock weather data
- Mock data changes based on time of day for realistic simulation

### 5. Supported Features
- Current weather by city name
- Weather by coordinates (GPS)
- 5-day weather forecast
- Indonesian language support
- Automatic fallback to mock data

### 6. Error Handling
- Network errors → Fallback to mock data
- API key invalid → Fallback to mock data
- Rate limit exceeded → Fallback to mock data
- No internet → Uses cached data or mock data

## Implementation Details

The weather system is designed to be robust:
- **Primary**: OpenWeatherMap API (if configured)
- **Fallback**: Mock data simulation
- **Offline**: Cached data or default values

This ensures the app always shows weather information, even without API access.


