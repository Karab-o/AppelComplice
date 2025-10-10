// Trip Insights Backend Server
// Mock API server for development and testing

const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Mock data generators
class MockDataGenerator {
    static generateTripData(startDate, endDate, granularity = 'monthly') {
        const start = new Date(startDate);
        const end = new Date(endDate);
        const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
        
        const baseTrips = 1200000;
        const dailyVariation = 0.15; // 15% daily variation
        
        return {
            total_trips: Math.floor(baseTrips * (days / 30)),
            daily_average: Math.floor(baseTrips / 30),
            time_series: this.generateTimeSeries(start, end, granularity)
        };
    }

    static generateTimeSeries(startDate, endDate, granularity) {
        const data = [];
        const current = new Date(startDate);
        const end = new Date(endDate);
        
        while (current <= end) {
            const baseValue = 40000;
            const variation = (Math.random() - 0.5) * 0.3;
            const value = Math.floor(baseValue * (1 + variation));
            
            data.push({
                date: current.toISOString().split('T')[0],
                value: value,
                revenue: value * (15.50 + (Math.random() - 0.5) * 2)
            });
            
            // Increment based on granularity
            switch (granularity) {
                case 'daily':
                    current.setDate(current.getDate() + 1);
                    break;
                case 'weekly':
                    current.setDate(current.getDate() + 7);
                    break;
                case 'monthly':
                default:
                    current.setMonth(current.getMonth() + 1);
                    break;
            }
        }
        
        return data;
    }

    static generatePaymentMethodData() {
        return {
            cash: {
                count: 400000,
                percentage: 33.3
            },
            card: {
                count: 600000,
                percentage: 50.0
            },
            mobile: {
                count: 200000,
                percentage: 16.7
            }
        };
    }

    static generateBoroughData() {
        return {
            manhattan: {
                count: 450000,
                percentage: 37.5,
                average_fare: 18.20
            },
            brooklyn: {
                count: 350000,
                percentage: 29.2,
                average_fare: 14.80
            },
            queens: {
                count: 250000,
                percentage: 20.8,
                average_fare: 16.50
            },
            bronx: {
                count: 120000,
                percentage: 10.0,
                average_fare: 13.20
            },
            staten_island: {
                count: 30000,
                percentage: 2.5,
                average_fare: 22.10
            }
        };
    }

    static calculateChangePercentage(current, previous) {
        if (!previous || previous === 0) return 0;
        return ((current - previous) / previous * 100).toFixed(1);
    }
}

// Authentication middleware (simplified for demo)
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    
    // In production, validate the JWT token
    if (!token) {
        return res.status(401).json({
            status: 'error',
            error: {
                code: 'UNAUTHORIZED',
                message: 'Access token is required'
            }
        });
    }
    
    // Mock validation - in production, verify JWT
    if (token !== 'demo-token') {
        return res.status(401).json({
            status: 'error',
            error: {
                code: 'UNAUTHORIZED',
                message: 'Invalid access token'
            }
        });
    }
    
    next();
};

// Routes

// Health check
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: '1.0.0'
    });
});

// Historical analytics endpoint
app.get('/api/v1/analytics/historical', authenticateToken, (req, res) => {
    try {
        const {
            start_date_1,
            end_date_1,
            start_date_2,
            end_date_2,
            granularity = 'monthly'
        } = req.query;

        // Validate required parameters
        if (!start_date_1 || !end_date_1) {
            return res.status(400).json({
                status: 'error',
                error: {
                    code: 'INVALID_PARAMETERS',
                    message: 'start_date_1 and end_date_1 are required'
                }
            });
        }

        // Generate data for period 1
        const period1Data = MockDataGenerator.generateTripData(start_date_1, end_date_1, granularity);
        const paymentData = MockDataGenerator.generatePaymentMethodData();
        const boroughData = MockDataGenerator.generateBoroughData();

        const response = {
            status: 'success',
            data: {
                period_1: {
                    start_date: start_date_1,
                    end_date: end_date_1,
                    metrics: {
                        total_trips: {
                            value: period1Data.total_trips,
                            formatted_value: `${(period1Data.total_trips / 1000000).toFixed(1)}M`,
                            change_percentage: 5.2,
                            chart_data: {
                                labels: period1Data.time_series.map(d => {
                                    const date = new Date(d.date);
                                    return date.toLocaleDateString('en-US', { month: 'short' });
                                }),
                                values: period1Data.time_series.map(d => d.value)
                            }
                        },
                        average_fare: {
                            value: 15.50,
                            formatted_value: '$15.50',
                            change_percentage: -2.1,
                            chart_data: {
                                labels: period1Data.time_series.map(d => {
                                    const date = new Date(d.date);
                                    return date.toLocaleDateString('en-US', { month: 'short' });
                                }),
                                values: period1Data.time_series.map(d => 
                                    parseFloat((d.revenue / d.value).toFixed(2))
                                )
                            }
                        },
                        payment_methods: {
                            total_trips: period1Data.total_trips,
                            change_percentage: 5.0,
                            breakdown: paymentData
                        },
                        boroughs: {
                            total_trips: period1Data.total_trips,
                            change_percentage: -2.0,
                            breakdown: boroughData
                        }
                    }
                }
            },
            metadata: {
                generated_at: new Date().toISOString(),
                query_time_ms: Math.floor(Math.random() * 300) + 50
            }
        };

        // Add period 2 data if provided
        if (start_date_2 && end_date_2) {
            const period2Data = MockDataGenerator.generateTripData(start_date_2, end_date_2, granularity);
            response.data.period_2 = {
                start_date: start_date_2,
                end_date: end_date_2,
                metrics: {
                    // Similar structure with different values
                    total_trips: {
                        value: period2Data.total_trips,
                        formatted_value: `${(period2Data.total_trips / 1000000).toFixed(1)}M`,
                        change_percentage: -1.5
                    }
                    // ... other metrics
                }
            };
        }

        res.json(response);
    } catch (error) {
        console.error('Error in /analytics/historical:', error);
        res.status(500).json({
            status: 'error',
            error: {
                code: 'INTERNAL_ERROR',
                message: 'An internal server error occurred'
            }
        });
    }
});

// Trip metrics endpoint
app.get('/api/v1/analytics/trips', authenticateToken, (req, res) => {
    try {
        const { start_date, end_date, group_by = 'day', borough, payment_method } = req.query;

        if (!start_date || !end_date) {
            return res.status(400).json({
                status: 'error',
                error: {
                    code: 'INVALID_PARAMETERS',
                    message: 'start_date and end_date are required'
                }
            });
        }

        const tripData = MockDataGenerator.generateTripData(start_date, end_date, group_by);
        
        res.json({
            status: 'success',
            data: {
                total_trips: tripData.total_trips,
                total_revenue: tripData.total_trips * 15.50,
                average_fare: 15.50,
                time_series: tripData.time_series.map(d => ({
                    period: d.date,
                    trips: d.value,
                    revenue: d.revenue,
                    average_fare: parseFloat((d.revenue / d.value).toFixed(2))
                })),
                filters_applied: {
                    borough: borough || null,
                    payment_method: payment_method || null
                }
            }
        });
    } catch (error) {
        console.error('Error in /analytics/trips:', error);
        res.status(500).json({
            status: 'error',
            error: {
                code: 'INTERNAL_ERROR',
                message: 'An internal server error occurred'
            }
        });
    }
});

// Fare analysis endpoint
app.get('/api/v1/analytics/fares', authenticateToken, (req, res) => {
    try {
        const { start_date, end_date, breakdown } = req.query;

        if (!start_date || !end_date) {
            return res.status(400).json({
                status: 'error',
                error: {
                    code: 'INVALID_PARAMETERS',
                    message: 'start_date and end_date are required'
                }
            });
        }

        const fareDistribution = {
            '0-5': 50000,
            '5-10': 180000,
            '10-15': 420000,
            '15-20': 350000,
            '20-25': 150000,
            '25+': 50000
        };

        let breakdownData = {};
        if (breakdown === 'borough') {
            breakdownData = MockDataGenerator.generateBoroughData();
        } else if (breakdown === 'payment_method') {
            breakdownData = MockDataGenerator.generatePaymentMethodData();
        }

        res.json({
            status: 'success',
            data: {
                average_fare: 15.50,
                median_fare: 14.20,
                fare_distribution: fareDistribution,
                breakdown: breakdownData,
                period: {
                    start_date,
                    end_date
                }
            }
        });
    } catch (error) {
        console.error('Error in /analytics/fares:', error);
        res.status(500).json({
            status: 'error',
            error: {
                code: 'INTERNAL_ERROR',
                message: 'An internal server error occurred'
            }
        });
    }
});

// Real-time metrics endpoint
app.get('/api/v1/analytics/realtime', authenticateToken, (req, res) => {
    try {
        // Generate realistic real-time data
        const activeTrips = Math.floor(Math.random() * 5000) + 10000;
        const activeDrivers = Math.floor(activeTrips * 0.6);
        const avgWaitTime = parseFloat((Math.random() * 3 + 2).toFixed(1));
        
        let demandLevel = 'medium';
        if (activeTrips > 13000) demandLevel = 'high';
        if (activeTrips < 11000) demandLevel = 'low';

        res.json({
            status: 'success',
            data: {
                active_trips: activeTrips,
                active_drivers: activeDrivers,
                average_wait_time: avgWaitTime,
                current_demand_level: demandLevel,
                last_updated: new Date().toISOString()
            }
        });
    } catch (error) {
        console.error('Error in /analytics/realtime:', error);
        res.status(500).json({
            status: 'error',
            error: {
                code: 'INTERNAL_ERROR',
                message: 'An internal server error occurred'
            }
        });
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        status: 'error',
        error: {
            code: 'INTERNAL_ERROR',
            message: 'Something went wrong!'
        }
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        status: 'error',
        error: {
            code: 'NOT_FOUND',
            message: 'Endpoint not found'
        }
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`Trip Insights API Server running on port ${PORT}`);
    console.log(`Health check: http://localhost:${PORT}/health`);
    console.log(`API Base URL: http://localhost:${PORT}/api/v1`);
    console.log(`\nExample request:`);
    console.log(`curl -H "Authorization: Bearer demo-token" "http://localhost:${PORT}/api/v1/analytics/historical?start_date_1=2024-07-01&end_date_1=2024-07-31"`);
});

module.exports = app;