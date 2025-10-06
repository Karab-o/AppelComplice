import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.setBottomNavIndex(index);
    
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.of(context).pushNamed('/contacts');
        break;
      case 2:
        Navigator.of(context).pushNamed('/alerts');
        break;
      case 3:
        Navigator.of(context).pushNamed('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SafeGuard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  _showProfileDialog(context, appState);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome message
                if (appState.userProfile != null) ...[
                  Text(
                    'Hello, ${appState.userProfile!.name.split(' ').first}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay safe and connected',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                
                // Emergency status
                if (appState.isEmergencyActive) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.emergencyRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.emergencyRed,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.warning,
                          color: AppTheme.emergencyRed,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'EMERGENCY ALERT ACTIVE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.emergencyRed,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sending alert in ${appState.countdownSeconds} seconds',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.emergencyRed,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: appState.cancelEmergency,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.safeGreen,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('CANCEL ALERT'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                
                // Emergency SOS Button
                Center(
                  child: GestureDetector(
                    onTap: appState.isEmergencyActive 
                        ? null 
                        : appState.startEmergencyCountdown,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: appState.isEmergencyActive 
                              ? 1.0 
                              : _pulseAnimation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appState.isEmergencyActive 
                                  ? Colors.grey 
                                  : AppTheme.emergencyRed,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.emergencyRed.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emergency,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'SOS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'EMERGENCY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  appState.isEmergencyActive 
                      ? 'Emergency alert is being sent...' 
                      : 'Press and hold for 3 seconds to send emergency alert',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // Quick actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.contacts,
                        title: 'Contacts',
                        subtitle: '${appState.emergencyContacts.length} contacts',
                        onTap: () => Navigator.of(context).pushNamed('/contacts'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.history,
                        title: 'History',
                        subtitle: '${appState.alertHistory.length} alerts',
                        onTap: () => Navigator.of(context).pushNamed('/alerts'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.send,
                        title: 'Test Alert',
                        subtitle: 'Send test message',
                        onTap: () => _showTestAlertDialog(context, appState),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.settings,
                        title: 'Settings',
                        subtitle: 'App preferences',
                        onTap: () => Navigator.of(context).pushNamed('/settings'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Safety tips
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.primaryBlue,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Safety Tip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Always let someone know your plans when going out alone. Share your location with trusted contacts.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryBlue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onBottomNavTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appState.userProfile != null) ...[
              Text('Name: ${appState.userProfile!.name}'),
              Text('Phone: ${appState.userProfile!.phone}'),
              if (appState.userProfile!.medicalInfo != null)
                Text('Medical Info: ${appState.userProfile!.medicalInfo}'),
            ] else
              const Text('No profile information available'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTestAlertDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Test Alert'),
        content: const Text(
          'This will send a test message to all your emergency contacts. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.sendTestAlert();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test alert sent successfully!'),
                  backgroundColor: AppTheme.safeGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Test'),
          ),
        ],
      ),
    );
  }
}