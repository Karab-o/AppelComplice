// Trip Insights Analytics Dashboard JavaScript

class TripAnalytics {
    constructor() {
        this.charts = {};
        this.currentData = {};
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.loadInitialData();
        this.initializeCharts();
    }

    setupEventListeners() {
        // Tab navigation
        const tabButtons = document.querySelectorAll('.tab-btn');
        tabButtons.forEach(btn => {
            btn.addEventListener('click', (e) => this.switchTab(e.target.dataset.tab));
        });

        // Date selectors
        const dateSelectors = document.querySelectorAll('.date-select');
        dateSelectors.forEach(selector => {
            selector.addEventListener('change', () => this.handleDateChange());
        });

        // Navigation items
        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                this.handleNavigation(e.target.textContent.trim());
            });
        });
    }

    switchTab(tabName) {
        // Update tab buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

        // Update tab content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('active');
        });
        document.getElementById(`${tabName}-tab`).classList.add('active');
    }

    handleNavigation(navText) {
        console.log(`Navigating to: ${navText}`);
        // In a real app, this would handle routing
        if (navText !== 'History') {
            alert(`Navigation to ${navText} would be implemented in a full application.`);
        }
    }

    handleDateChange() {
        console.log('Date range changed, refreshing data...');
        this.loadAnalyticsData();
    }

    async loadInitialData() {
        try {
            const data = await this.fetchAnalyticsData();
            this.currentData = data;
            this.updateMetrics(data);
        } catch (error) {
            console.error('Error loading initial data:', error);
            this.showError('Failed to load analytics data');
        }
    }

    async loadAnalyticsData() {
        const startDate1 = document.getElementById('start-date-1').value;
        const endDate1 = document.getElementById('end-date-1').value;
        const startDate2 = document.getElementById('start-date-2').value;
        const endDate2 = document.getElementById('end-date-2').value;

        if (!startDate1 || !endDate1) {
            console.log('Please select both start and end dates for the first period');
            return;
        }

        try {
            const data = await this.fetchAnalyticsData({
                period1: { start: startDate1, end: endDate1 },
                period2: { start: startDate2, end: endDate2 }
            });
            
            this.currentData = data;
            this.updateMetrics(data);
            this.updateCharts(data);
        } catch (error) {
            console.error('Error loading analytics data:', error);
            this.showError('Failed to refresh analytics data');
        }
    }

    async fetchAnalyticsData(dateRanges = null) {
        // Simulate API call - in real app, this would be an actual API endpoint
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve(this.generateMockData(dateRanges));
            }, 500);
        });
    }

    generateMockData(dateRanges) {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
        
        return {
            totalTrips: {
                value: '1.2M',
                change: 5,
                chartData: {
                    labels: months,
                    data: [180000, 165000, 175000, 190000, 205000, 195000, 210000]
                }
            },
            averageFare: {
                value: '$15.50',
                change: -2,
                chartData: {
                    labels: months,
                    data: [16.20, 15.80, 15.90, 15.70, 15.60, 15.40, 15.50]
                }
            },
            paymentMethods: {
                value: '1.2M',
                change: 5,
                chartData: {
                    labels: ['Cash', 'Card', 'Mobile'],
                    data: [400000, 600000, 200000]
                }
            },
            boroughs: {
                value: '1.2M',
                change: -2,
                chartData: {
                    labels: ['Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island'],
                    data: [450000, 350000, 250000, 120000, 30000]
                }
            }
        };
    }

    updateMetrics(data) {
        // Update metric values and changes
        const metrics = [
            { selector: '.analytics-card:nth-child(1)', data: data.totalTrips },
            { selector: '.analytics-card:nth-child(2)', data: data.averageFare },
            { selector: '.analytics-card:nth-child(3)', data: data.paymentMethods },
            { selector: '.analytics-card:nth-child(4)', data: data.boroughs }
        ];

        metrics.forEach(metric => {
            const card = document.querySelector(metric.selector);
            if (card) {
                const valueEl = card.querySelector('.metric-value');
                const changeEl = card.querySelector('.change-value');
                const changeContainer = card.querySelector('.metric-change');

                if (valueEl) valueEl.textContent = metric.data.value;
                if (changeEl) changeEl.textContent = `${metric.data.change > 0 ? '+' : ''}${metric.data.change}%`;
                
                if (changeContainer) {
                    changeContainer.classList.remove('positive', 'negative');
                    changeContainer.classList.add(metric.data.change >= 0 ? 'positive' : 'negative');
                }
            }
        });
    }

    initializeCharts() {
        this.createTripsOverTimeChart();
        this.createAverageFareChart();
        this.createPaymentMethodChart();
        this.createBoroughChart();
    }

    createTripsOverTimeChart() {
        const ctx = document.getElementById('tripsOverTimeChart');
        if (!ctx) return;

        this.charts.tripsOverTime = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    data: [180000, 165000, 175000, 190000, 205000, 195000, 210000],
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 0,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        display: true,
                        grid: { display: false },
                        ticks: { color: '#64748b', font: { size: 11 } }
                    },
                    y: {
                        display: false,
                        grid: { display: false }
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                }
            }
        });
    }

    createAverageFareChart() {
        const ctx = document.getElementById('averageFareChart');
        if (!ctx) return;

        this.charts.averageFare = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                datasets: [{
                    data: [16.20, 15.80, 15.90, 15.70, 15.60, 15.40, 15.50],
                    backgroundColor: '#e2e8f0',
                    borderRadius: 4,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        display: true,
                        grid: { display: false },
                        ticks: { color: '#64748b', font: { size: 11 } }
                    },
                    y: {
                        display: false,
                        grid: { display: false }
                    }
                }
            }
        });
    }

    createPaymentMethodChart() {
        const ctx = document.getElementById('paymentMethodChart');
        if (!ctx) return;

        this.charts.paymentMethod = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Cash', 'Card', 'Mobile'],
                datasets: [{
                    data: [400000, 600000, 200000],
                    backgroundColor: ['#e2e8f0', '#cbd5e1', '#94a3b8'],
                    borderRadius: 4,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        display: true,
                        grid: { display: false },
                        ticks: { color: '#64748b', font: { size: 11 } }
                    },
                    y: {
                        display: false,
                        grid: { display: false }
                    }
                }
            }
        });
    }

    createBoroughChart() {
        const ctx = document.getElementById('boroughChart');
        if (!ctx) return;

        this.charts.borough = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island'],
                datasets: [{
                    data: [450000, 350000, 250000, 120000, 30000],
                    backgroundColor: ['#3b82f6', '#60a5fa', '#93c5fd', '#bfdbfe', '#dbeafe'],
                    borderRadius: 4,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    x: {
                        display: true,
                        grid: { display: false },
                        ticks: { 
                            color: '#64748b', 
                            font: { size: 10 },
                            maxRotation: 45
                        }
                    },
                    y: {
                        display: false,
                        grid: { display: false }
                    }
                }
            }
        });
    }

    updateCharts(data) {
        // Update charts with new data
        if (this.charts.tripsOverTime && data.totalTrips.chartData) {
            this.charts.tripsOverTime.data.datasets[0].data = data.totalTrips.chartData.data;
            this.charts.tripsOverTime.update();
        }

        if (this.charts.averageFare && data.averageFare.chartData) {
            this.charts.averageFare.data.datasets[0].data = data.averageFare.chartData.data;
            this.charts.averageFare.update();
        }

        if (this.charts.paymentMethod && data.paymentMethods.chartData) {
            this.charts.paymentMethod.data.datasets[0].data = data.paymentMethods.chartData.data;
            this.charts.paymentMethod.update();
        }

        if (this.charts.borough && data.boroughs.chartData) {
            this.charts.borough.data.datasets[0].data = data.boroughs.chartData.data;
            this.charts.borough.update();
        }
    }

    showError(message) {
        // Simple error display - in a real app, you'd use a proper notification system
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #ef4444;
            color: white;
            padding: 1rem;
            border-radius: 0.5rem;
            z-index: 1000;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        `;
        errorDiv.textContent = message;
        
        document.body.appendChild(errorDiv);
        
        setTimeout(() => {
            errorDiv.remove();
        }, 5000);
    }
}

// Utility functions
const utils = {
    formatNumber(num) {
        if (num >= 1000000) {
            return (num / 1000000).toFixed(1) + 'M';
        } else if (num >= 1000) {
            return (num / 1000).toFixed(1) + 'K';
        }
        return num.toString();
    },

    formatCurrency(amount) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    },

    formatDate(date) {
        return new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(new Date(date));
    },

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
};

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.tripAnalytics = new TripAnalytics();
});

// Handle window resize for responsive charts
window.addEventListener('resize', utils.debounce(() => {
    if (window.tripAnalytics && window.tripAnalytics.charts) {
        Object.values(window.tripAnalytics.charts).forEach(chart => {
            if (chart) chart.resize();
        });
    }
}, 250));