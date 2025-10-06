import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import '../providers/app_provider.dart';
import '../models/user_profile.dart';
import '../widgets/custom_button.dart';

/// Settings screen for app preferences and user profile
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final userProfile = appProvider.userProfile;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                _buildProfileSection(userProfile, appProvider),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Emergency Settings
                _buildEmergencySettings(userProfile, appProvider),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Notification Settings
                _buildNotificationSettings(userProfile, appProvider),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Security Settings
                _buildSecuritySettings(userProfile, appProvider),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // App Settings
                _buildAppSettings(appProvider),
                
                const SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(UserProfile? profile, AppProvider appProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.emergencyRedLight,
                  child: Text(
                    profile?.name?.isNotEmpty == true 
                        ? profile!.name![0].toUpperCase() 
                        : 'U',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.emergencyRed,
                    ),
                  ),
                ),
                
                const SizedBox(width: AppDimensions.paddingM),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.name ?? 'User',
                        style: AppTextStyles.h3,
                      ),
                      
                      if (profile?.phoneNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          profile!.phoneNumber!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      
                      if (profile?.email != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          profile!.email!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditProfileDialog(profile, appProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySettings(UserProfile? profile, AppProvider appProvider) {
    final preferences = profile?.preferences ?? UserPreferences();
    
    return _buildSettingsSection(
      title: 'Emergency Settings',
      icon: Icons.emergency,
      children: [
        _buildSwitchTile(
          title: 'Location Sharing',
          subtitle: 'Share location automatically during emergencies',
          value: preferences.enableLocationSharing,
          onChanged: (value) => _updatePreferences(
            appProvider,
            preferences.copyWith(enableLocationSharing: value),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Auto Contact Police',
          subtitle: 'Automatically contact emergency services',
          value: preferences.autoContactPolice,
          onChanged: (value) => _updatePreferences(
            appProvider,
            preferences.copyWith(autoContactPolice: value),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Share Location with Contacts',
          subtitle: 'Include location in emergency messages',
          value: preferences.shareLocationWithContacts,
          onChanged: (value) => _updatePreferences(
            appProvider,
            preferences.copyWith(shareLocationWithContacts: value),
          ),
        ),
        
        ListTile(
          title: const Text('Alert Delay'),
          subtitle: Text('${preferences.alertDelaySeconds} seconds countdown'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAlertDelayDialog(preferences, appProvider),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings(UserProfile? profile, AppProvider appProvider) {
    final preferences = profile?.preferences ?? UserPreferences();
    
    return _buildSettingsSection(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive app notifications',
          value: preferences.enablePushNotifications,
          onChanged: (value) => _updatePreferences(
            appProvider,
            preferences.copyWith(enablePushNotifications: value),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Sound Alerts',
          subtitle: 'Play sound for emergency alerts',
          value: preferences.enableSoundAlerts,
          onChanged: (value) => _updatePreferences(
            appProvider,
            preferences.copyWith(enableSoundAlerts: value),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Vibration',
          subtitle: 'Vibrate for notifications and alerts',
          value: preferences.enableVibration,
          onChanged: (value) => _updatePreferences(
            appProvider,
            preferences.copyWith(enableVibration: value),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySettings(UserProfile? profile, AppProvider appProvider) {
    final security = profile?.security ?? SecuritySettings();
    
    return _buildSettingsSection(
      title: 'Security',
      icon: Icons.security,
      children: [
        _buildSwitchTile(
          title: 'PIN Protection',
          subtitle: 'Require PIN to open app',
          value: security.requirePinOnStartup,
          onChanged: (value) => _updateSecurity(
            appProvider,
            security.copyWith(requirePinOnStartup: value),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face unlock',
          value: security.enableBiometricAuth,
          onChanged: (value) => _updateSecurity(
            appProvider,
            security.copyWith(enableBiometricAuth: value),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Stealth Mode',
          subtitle: 'Hide app from recent apps list',
          value: security.enableStealthMode,
          onChanged: (value) => _updateSecurity(
            appProvider,
            security.copyWith(enableStealthMode: value),
          ),
        ),
        
        ListTile(
          title: const Text('Auto Lock'),
          subtitle: Text('Lock app after ${security.autoLockMinutes} minutes'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAutoLockDialog(security, appProvider),
        ),
      ],
    );
  }

  Widget _buildAppSettings(AppProvider appProvider) {
    return _buildSettingsSection(
      title: 'App Settings',
      icon: Icons.settings,
      children: [
        ListTile(
          title: const Text('Test Emergency System'),
          subtitle: const Text('Send test alert to verify setup'),
          leading: const Icon(Icons.test_outlined),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _testEmergencySystem(appProvider),
        ),
        
        ListTile(
          title: const Text('Export Data'),
          subtitle: const Text('Backup your emergency contacts and settings'),
          leading: const Icon(Icons.download),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _exportData(appProvider),
        ),
        
        ListTile(
          title: const Text('Reset Onboarding'),
          subtitle: const Text('Go through setup process again'),
          leading: const Icon(Icons.refresh),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _resetOnboarding(appProvider),
        ),
        
        ListTile(
          title: const Text('Clear All Data'),
          subtitle: const Text('Delete all contacts and settings'),
          leading: const Icon(Icons.delete_forever, color: AppColors.error),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showClearDataDialog(appProvider),
        ),
        
        const Divider(),
        
        ListTile(
          title: const Text('About'),
          subtitle: const Text('App version and information'),
          leading: const Icon(Icons.info),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showAboutDialog,
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.emergencyRed),
                const SizedBox(width: AppDimensions.paddingS),
                Text(title, style: AppTextStyles.h3),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.safeGreen,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showEditProfileDialog(UserProfile? profile, AppProvider appProvider) {
    final nameController = TextEditingController(text: profile?.name ?? '');
    final phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
    final emailController = TextEditingController(text: profile?.email ?? '');
    final medicalController = TextEditingController(text: profile?.emergencyMedicalInfo ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              TextField(
                controller: medicalController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Medical Info',
                  prefixIcon: Icon(Icons.medical_services),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
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
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                final updatedProfile = (profile ?? UserProfile()).copyWith(
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim().isEmpty 
                      ? null 
                      : phoneController.text.trim(),
                  email: emailController.text.trim().isEmpty 
                      ? null 
                      : emailController.text.trim(),
                  emergencyMedicalInfo: medicalController.text.trim().isEmpty 
                      ? null 
                      : medicalController.text.trim(),
                );
                
                await appProvider.updateUserProfile(updatedProfile);
                
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                      backgroundColor: AppColors.safeGreen,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAlertDelayDialog(UserPreferences preferences, AppProvider appProvider) {
    int selectedDelay = preferences.alertDelaySeconds;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Delay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose countdown time before sending emergency alert:'),
            const SizedBox(height: 16),
            ...([5, 10, 15, 30, 60].map((seconds) => RadioListTile<int>(
              title: Text('$seconds seconds'),
              value: seconds,
              groupValue: selectedDelay,
              onChanged: (value) {
                if (value != null) {
                  selectedDelay = value;
                  Navigator.of(context).pop();
                  _updatePreferences(
                    appProvider,
                    preferences.copyWith(alertDelaySeconds: selectedDelay),
                  );
                }
              },
            ))),
          ],
        ),
      ),
    );
  }

  void _showAutoLockDialog(SecuritySettings security, AppProvider appProvider) {
    int selectedMinutes = security.autoLockMinutes;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto Lock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose when to automatically lock the app:'),
            const SizedBox(height: 16),
            ...([1, 5, 10, 15, 30].map((minutes) => RadioListTile<int>(
              title: Text('$minutes minutes'),
              value: minutes,
              groupValue: selectedMinutes,
              onChanged: (value) {
                if (value != null) {
                  selectedMinutes = value;
                  Navigator.of(context).pop();
                  _updateSecurity(
                    appProvider,
                    security.copyWith(autoLockMinutes: selectedMinutes),
                  );
                }
              },
            ))),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your emergency contacts, alert history, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await appProvider.clearAllData();
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Personal Safety'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A personal safety app designed to help you stay connected with trusted contacts during emergencies.'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Emergency alerts with location sharing'),
            Text('• Trusted contact management'),
            Text('• Alert history and tracking'),
            Text('• Security and privacy settings'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePreferences(AppProvider appProvider, UserPreferences preferences) async {
    await appProvider.updateUserPreferences(preferences);
  }

  Future<void> _updateSecurity(AppProvider appProvider, SecuritySettings security) async {
    await appProvider.updateSecuritySettings(security);
  }

  Future<void> _testEmergencySystem(AppProvider appProvider) async {
    if (appProvider.activeContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add emergency contacts first'),
          backgroundColor: AppColors.warningOrange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Emergency System'),
        content: const Text(
          'This will send a test message to your first emergency contact. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send Test'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await appProvider.testEmergencySystem();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test message sent successfully'),
            backgroundColor: AppColors.safeGreen,
          ),
        );
      }
    }
  }

  Future<void> _exportData(AppProvider appProvider) async {
    // TODO: Implement data export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Future<void> _resetOnboarding(AppProvider appProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Onboarding'),
        content: const Text(
          'This will take you through the setup process again. Your data will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await appProvider.resetOnboarding();
    }
  }
}