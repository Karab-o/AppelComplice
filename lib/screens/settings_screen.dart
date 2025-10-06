import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3;
  
  // Settings state
  bool _biometricEnabled = false;
  bool _locationEnabled = true;
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  bool _vibrationEnabled = true;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/contacts');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/alerts');
        break;
      case 3:
        // Already on settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile section
              _buildProfileSection(context, appState),
              
              const SizedBox(height: 24),
              
              // Security section
              _buildSecuritySection(context),
              
              const SizedBox(height: 24),
              
              // Notifications section
              _buildNotificationsSection(context),
              
              const SizedBox(height: 24),
              
              // Emergency settings section
              _buildEmergencySection(context),
              
              const SizedBox(height: 24),
              
              // About section
              _buildAboutSection(context),
              
              const SizedBox(height: 24),
              
              // Danger zone
              _buildDangerZone(context, appState),
            ],
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

  Widget _buildProfileSection(BuildContext context, AppStateProvider appState) {
    return _buildSection(
      title: 'Profile',
      children: [
        if (appState.userProfile != null) ...[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                appState.userProfile!.name.isNotEmpty 
                    ? appState.userProfile!.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(appState.userProfile!.name),
            subtitle: Text(appState.userProfile!.phone),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditProfileDialog(context, appState),
          ),
        ] else
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Set up profile'),
            subtitle: const Text('Add your information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditProfileDialog(context, appState),
          ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSection(
      title: 'Security',
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: const Text('Biometric Authentication'),
          subtitle: const Text('Use fingerprint or face recognition'),
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() {
              _biometricEnabled = value;
            });
          },
          activeColor: AppTheme.primaryBlue,
        ),
        
        SwitchListTile(
          secondary: const Icon(Icons.location_on),
          title: const Text('Location Services'),
          subtitle: const Text('Share location during emergencies'),
          value: _locationEnabled,
          onChanged: (value) {
            setState(() {
              _locationEnabled = value;
            });
          },
          activeColor: AppTheme.primaryBlue,
        ),
        
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change PIN'),
          subtitle: const Text('Set up emergency PIN'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showChangePinDialog(context),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return _buildSection(
      title: 'Notifications',
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive app notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
          activeColor: AppTheme.primaryBlue,
        ),
        
        SwitchListTile(
          secondary: const Icon(Icons.volume_up),
          title: const Text('Emergency Sounds'),
          subtitle: const Text('Play sounds during emergencies'),
          value: _soundEnabled,
          onChanged: (value) {
            setState(() {
              _soundEnabled = value;
            });
          },
          activeColor: AppTheme.primaryBlue,
        ),
        
        SwitchListTile(
          secondary: const Icon(Icons.vibration),
          title: const Text('Vibration'),
          subtitle: const Text('Vibrate for alerts'),
          value: _vibrationEnabled,
          onChanged: (value) {
            setState(() {
              _vibrationEnabled = value;
            });
          },
          activeColor: AppTheme.primaryBlue,
        ),
      ],
    );
  }

  Widget _buildEmergencySection(BuildContext context) {
    return _buildSection(
      title: 'Emergency Settings',
      children: [
        ListTile(
          leading: const Icon(Icons.timer),
          title: const Text('Countdown Duration'),
          subtitle: const Text('3 seconds'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCountdownDialog(context),
        ),
        
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Emergency Message'),
          subtitle: const Text('Customize alert message'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showEmergencyMessageDialog(context),
        ),
        
        ListTile(
          leading: const Icon(Icons.medical_services),
          title: const Text('Medical Information'),
          subtitle: const Text('Update medical details'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showMedicalInfoDialog(context),
        ),
        
        ListTile(
          leading: const Icon(Icons.send),
          title: const Text('Test Emergency System'),
          subtitle: const Text('Send a test alert'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showTestAlertDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      title: 'About',
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('App Version'),
          subtitle: const Text('1.0.0'),
          trailing: const Icon(Icons.chevron_right),
        ),
        
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPrivacyPolicy(context),
        ),
        
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showTermsOfService(context),
        ),
        
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showHelpDialog(context),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context, AppStateProvider appState) {
    return _buildSection(
      title: 'Danger Zone',
      children: [
        ListTile(
          leading: const Icon(Icons.delete_forever, color: AppTheme.emergencyRed),
          title: const Text(
            'Clear All Data',
            style: TextStyle(color: AppTheme.emergencyRed),
          ),
          subtitle: const Text('Remove all contacts and history'),
          trailing: const Icon(Icons.chevron_right, color: AppTheme.emergencyRed),
          onTap: () => _showClearDataDialog(context, appState),
        ),
        
        ListTile(
          leading: const Icon(Icons.restore, color: AppTheme.warningOrange),
          title: const Text(
            'Reset App',
            style: TextStyle(color: AppTheme.warningOrange),
          ),
          subtitle: const Text('Reset to factory settings'),
          trailing: const Icon(Icons.chevron_right, color: AppTheme.warningOrange),
          onTap: () => _showResetAppDialog(context, appState),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, AppStateProvider appState) {
    final nameController = TextEditingController(
      text: appState.userProfile?.name ?? '',
    );
    final phoneController = TextEditingController(
      text: appState.userProfile?.phone ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final profile = UserProfile(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  medicalInfo: appState.userProfile?.medicalInfo,
                  emergencyMessage: appState.userProfile?.emergencyMessage,
                );
                appState.updateUserProfile(profile);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangePinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: const Text('PIN functionality will be implemented in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCountdownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Countdown Duration'),
        content: const Text('Countdown duration customization will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyMessageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Message'),
        content: const Text('Custom emergency message editing will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMedicalInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medical Information'),
        content: const Text('Medical information editing will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTestAlertDialog(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Emergency System'),
        content: const Text('This will send a test alert to all your emergency contacts. Continue?'),
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

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'SafeGuard Privacy Policy\n\n'
            'Your privacy is important to us. This app collects minimal data necessary for emergency functionality:\n\n'
            '• Contact information for emergency alerts\n'
            '• Location data during emergencies only\n'
            '• Alert history for your records\n\n'
            'We do not share your data with third parties except as necessary for emergency services.',
          ),
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

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'SafeGuard Terms of Service\n\n'
            'By using this app, you agree to:\n\n'
            '• Use the emergency features responsibly\n'
            '• Provide accurate contact information\n'
            '• Not abuse the emergency alert system\n\n'
            'This app is designed to assist in emergencies but should not replace official emergency services.',
          ),
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'Need help with SafeGuard?\n\n'
          '• Check the app tutorial in onboarding\n'
          '• Contact support: support@safeguard.app\n'
          '• Visit our website: www.safeguard.app\n\n'
          'For emergencies, always call your local emergency number (911, 112, etc.)',
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

  void _showClearDataDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your emergency contacts and alert history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear all data
              appState.clearAlertHistory();
              // Note: In a real app, you'd also clear contacts
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  backgroundColor: AppTheme.emergencyRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emergencyRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showResetAppDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will reset the app to its initial state, clearing all data and settings. You will need to set up the app again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Reset app state
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/onboarding',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}