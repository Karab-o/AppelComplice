import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _medicalInfoController = TextEditingController();
  final _emergencyMessageController = TextEditingController();
  
  // Form key
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _medicalInfoController.dispose();
    _emergencyMessageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    if (_formKey.currentState?.validate() ?? false) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      
      // Create user profile
      final profile = UserProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        medicalInfo: _medicalInfoController.text.trim().isEmpty 
            ? null 
            : _medicalInfoController.text.trim(),
        emergencyMessage: _emergencyMessageController.text.trim().isEmpty 
            ? null 
            : _emergencyMessageController.text.trim(),
      );
      
      appState.setUserProfile(profile);
      appState.completeOnboarding();
      appState.initializeSampleData();
      
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < 2 ? 8 : 0,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentPage 
                            ? AppTheme.primaryBlue 
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildProfileSetupPage(),
                  _buildSecuritySetupPage(),
                ],
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        _currentPage == 2 ? 'Get Started' : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.security,
              size: 60,
              color: AppTheme.primaryBlue,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Welcome to SafeGuard',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Your personal safety companion that helps you stay connected with your loved ones in emergency situations.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          _buildFeatureItem(
            Icons.emergency,
            'Emergency SOS',
            'Quick access to emergency services and contacts',
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            Icons.contacts,
            'Emergency Contacts',
            'Manage your trusted contacts for emergencies',
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            Icons.location_on,
            'Location Sharing',
            'Share your location with emergency contacts',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSetupPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Up Your Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'This information will be shared with emergency contacts when needed.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: 32),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
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
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
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
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _medicalInfoController,
              decoration: const InputDecoration(
                labelText: 'Medical Information (Optional)',
                hintText: 'Allergies, medications, conditions...',
                prefixIcon: Icon(Icons.medical_services),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emergencyMessageController,
              decoration: const InputDecoration(
                labelText: 'Emergency Message (Optional)',
                hintText: 'Custom message for emergency contacts',
                prefixIcon: Icon(Icons.message),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySetupPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security & Privacy',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Configure your security preferences for the app.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          
          const SizedBox(height: 32),
          
          _buildSecurityOption(
            Icons.fingerprint,
            'Biometric Authentication',
            'Use fingerprint or face recognition to secure the app',
            true,
          ),
          
          const SizedBox(height: 16),
          
          _buildSecurityOption(
            Icons.location_on,
            'Location Services',
            'Allow the app to access your location for emergencies',
            true,
          ),
          
          const SizedBox(height: 16),
          
          _buildSecurityOption(
            Icons.volume_up,
            'Emergency Sounds',
            'Play sounds during emergency activation',
            true,
          ),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You can change these settings later in the Settings screen.',
                    style: TextStyle(
                      color: AppTheme.primaryBlue.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityOption(
    IconData icon,
    String title,
    String description,
    bool initialValue,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          Switch(
            value: initialValue,
            onChanged: (value) {
              // Handle switch changes
              setState(() {
                // Update state as needed
              });
            },
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }
}