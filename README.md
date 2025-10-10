# Trip Insights - Historical Data Analysis Dashboard

A modern, responsive analytics dashboard for taxi trip data analysis, featuring interactive charts, real-time metrics, and comprehensive historical data comparison.

## 🚀 Features

- **Historical Data Analysis**: Compare different time periods side-by-side
- **Interactive Charts**: Dynamic visualizations using Chart.js
- **Real-time Metrics**: Live trip and driver statistics
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **Modern UI**: Clean, professional interface matching the latest design trends
- **API Integration**: Complete backend API with mock data for development

## 📊 Analytics Included

1. **Total Trips Over Time** - Track trip volume trends with percentage changes
2. **Average Fare Analysis** - Monitor fare patterns and variations
3. **Payment Method Distribution** - Breakdown by Cash, Card, and Mobile payments
4. **Borough Analysis** - Geographic distribution across NYC boroughs

## 🛠 Technology Stack

### Frontend
- **HTML5** - Semantic markup structure
- **CSS3** - Modern styling with Flexbox and Grid
- **JavaScript (ES6+)** - Interactive functionality and API integration
- **Chart.js** - Data visualization library

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web application framework
- **CORS** - Cross-origin resource sharing

## 📁 Project Structure

```
trip-insights-dashboard/
├── index.html              # Main HTML file
├── styles.css              # CSS styles
├── script.js               # Frontend JavaScript
├── backend-server.js       # Mock API server
├── api-documentation.md    # Complete API documentation
├── package.json           # Node.js dependencies
└── README.md             # This file
```

## 🚀 Quick Start

### Prerequisites
- Node.js (v14 or higher)
- npm (comes with Node.js)

### Installation

1. **Clone or download the project files**

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start the backend API server**
   ```bash
   npm start
   ```
   The API server will run on `http://localhost:3001`

4. **Serve the frontend** (in a new terminal)
   ```bash
   npm run serve
   ```
   The dashboard will be available at `http://localhost:8080`

5. **Or run both simultaneously**
   ```bash
   npm run dev-full
   ```

### Alternative Setup (Static Files Only)

If you only want to run the frontend without the backend:

1. Open `index.html` directly in your browser
2. The dashboard will work with mock data generated in JavaScript

## 🔧 Configuration

### API Configuration

The frontend is configured to work with the mock API server. To connect to a real API:

1. Update the API base URL in `script.js`:
   ```javascript
   const API_BASE_URL = 'https://your-api-domain.com/api/v1';
   ```

2. Add your authentication token:
   ```javascript
   const API_TOKEN = 'your-actual-api-token';
   ```

### Customization

#### Colors and Styling
- Edit `styles.css` to modify colors, fonts, and layout
- The design uses CSS custom properties for easy theming

#### Chart Configuration
- Modify chart settings in `script.js`
- Chart.js options can be customized for different visualizations

#### Data Sources
- Update the mock data generators in `backend-server.js`
- Modify API endpoints to match your data structure

## 📱 Responsive Design

The dashboard is fully responsive and includes:
- Mobile-first CSS approach
- Flexible grid layouts
- Touch-friendly interactive elements
- Optimized charts for small screens

## 🔌 API Integration

### Authentication
All API requests require a Bearer token:
```javascript
headers: {
  'Authorization': 'Bearer your-api-token'
}
```

### Key Endpoints
- `GET /api/v1/analytics/historical` - Historical data comparison
- `GET /api/v1/analytics/trips` - Detailed trip metrics
- `GET /api/v1/analytics/fares` - Fare analysis
- `GET /api/v1/analytics/realtime` - Real-time metrics

See `api-documentation.md` for complete API reference.

## 🎨 Design Features

- **Modern UI**: Clean, professional design
- **Interactive Elements**: Hover effects and smooth transitions
- **Data Visualization**: Clear, informative charts
- **Accessibility**: Semantic HTML and keyboard navigation support
- **Performance**: Optimized loading and rendering

## 📊 Sample Data

The mock server generates realistic taxi trip data including:
- Trip volumes ranging from 1M-1.5M per month
- Average fares between $13-$22 depending on borough
- Payment method distribution (50% card, 33% cash, 17% mobile)
- Geographic distribution across NYC boroughs

## 🔄 Development Workflow

### Adding New Features

1. **Frontend Changes**: Edit `index.html`, `styles.css`, or `script.js`
2. **Backend Changes**: Modify `backend-server.js` for new API endpoints
3. **Testing**: Use the browser developer tools for debugging

### API Development

1. Add new endpoints to `backend-server.js`
2. Update `api-documentation.md`
3. Test with curl or Postman:
   ```bash
   curl -H "Authorization: Bearer demo-token" \
     "http://localhost:3001/api/v1/analytics/historical?start_date_1=2024-07-01&end_date_1=2024-07-31"
   ```

## 🚀 Deployment

### Frontend Deployment
- Deploy static files (`index.html`, `styles.css`, `script.js`) to any web server
- Configure API endpoints for production environment

### Backend Deployment
- Deploy `backend-server.js` to Node.js hosting (Heroku, AWS, etc.)
- Set environment variables for production configuration
- Update CORS settings for your domain

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For questions or issues:
- Check the API documentation in `api-documentation.md`
- Review the code comments in each file
- Open an issue in the repository

## 🔮 Future Enhancements

- Real-time data streaming with WebSockets
- Advanced filtering and search capabilities
- Export functionality for reports
- User authentication and role-based access
- Additional chart types and visualizations
- Mobile app integration