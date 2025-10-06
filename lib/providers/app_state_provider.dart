import 'package:flutter/material.dart';

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'isPrimary': isPrimary,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      relationship: json['relationship'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }

  EmergencyContact copyWith({
    String? name,
    String? phone,
    String? relationship,
    bool? isPrimary,
  }) {
    return EmergencyContact(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}

class AlertRecord {
  final String id;
  final DateTime timestamp;
  final String type;
  final String location;
  final String status;
  final List<String> contactsNotified;
  final String? notes;

  AlertRecord({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.location,
    required this.status,
    required this.contactsNotified,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'location': location,
      'status': status,
      'contactsNotified': contactsNotified,
      'notes': notes,
    };
  }

  factory AlertRecord.fromJson(Map<String, dynamic> json) {
    return AlertRecord(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      location: json['location'],
      status: json['status'],
      contactsNotified: List<String>.from(json['contactsNotified']),
      notes: json['notes'],
    );
  }
}

class UserProfile {
  final String name;
  final String phone;
  final String? medicalInfo;
  final String? emergencyMessage;
  final bool biometricEnabled;
  final bool locationEnabled;
  final bool soundEnabled;

  UserProfile({
    required this.name,
    required this.phone,
    this.medicalInfo,
    this.emergencyMessage,
    this.biometricEnabled = false,
    this.locationEnabled = true,
    this.soundEnabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'medicalInfo': medicalInfo,
      'emergencyMessage': emergencyMessage,
      'biometricEnabled': biometricEnabled,
      'locationEnabled': locationEnabled,
      'soundEnabled': soundEnabled,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      phone: json['phone'],
      medicalInfo: json['medicalInfo'],
      emergencyMessage: json['emergencyMessage'],
      biometricEnabled: json['biometricEnabled'] ?? false,
      locationEnabled: json['locationEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
    );
  }

  UserProfile copyWith({
    String? name,
    String? phone,
    String? medicalInfo,
    String? emergencyMessage,
    bool? biometricEnabled,
    bool? locationEnabled,
    bool? soundEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      emergencyMessage: emergencyMessage ?? this.emergencyMessage,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}

class AppStateProvider with ChangeNotifier {
  // App state
  bool _isFirstLaunch = true;
  bool _isEmergencyActive = false;
  int _countdownSeconds = 0;
  UserProfile? _userProfile;
  
  // Emergency contacts
  final List<EmergencyContact> _emergencyContacts = [];
  
  // Alert history
  final List<AlertRecord> _alertHistory = [];
  
  // Bottom navigation
  int _currentBottomNavIndex = 0;

  // Getters
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isEmergencyActive => _isEmergencyActive;
  int get countdownSeconds => _countdownSeconds;
  UserProfile? get userProfile => _userProfile;
  List<EmergencyContact> get emergencyContacts => List.unmodifiable(_emergencyContacts);
  List<AlertRecord> get alertHistory => List.unmodifiable(_alertHistory);
  int get currentBottomNavIndex => _currentBottomNavIndex;

  // App lifecycle methods
  void completeOnboarding() {
    _isFirstLaunch = false;
    notifyListeners();
  }

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  // Bottom navigation
  void setBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }

  // Emergency functionality
  void startEmergencyCountdown() {
    if (_isEmergencyActive) return;
    
    _isEmergencyActive = true;
    _countdownSeconds = 3;
    notifyListeners();
    
    _runCountdown();
  }

  void cancelEmergency() {
    _isEmergencyActive = false;
    _countdownSeconds = 0;
    notifyListeners();
  }

  void _runCountdown() async {
    while (_countdownSeconds > 0 && _isEmergencyActive) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isEmergencyActive) {
        _countdownSeconds--;
        notifyListeners();
      }
    }
    
    if (_isEmergencyActive && _countdownSeconds == 0) {
      _triggerEmergencyAlert();
    }
  }

  void _triggerEmergencyAlert() {
    // Create alert record
    final alert = AlertRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: 'Emergency Alert',
      location: 'Current Location', // In production, use real GPS
      status: 'Sent',
      contactsNotified: _emergencyContacts.map((c) => c.name).toList(),
      notes: 'Emergency alert triggered by user',
    );
    
    _alertHistory.insert(0, alert);
    _isEmergencyActive = false;
    _countdownSeconds = 0;
    
    notifyListeners();
    
    // In production, this would:
    // 1. Send SMS to emergency contacts
    // 2. Make emergency calls
    // 3. Send location data
    // 4. Notify emergency services if configured
  }

  // Emergency contacts management
  void addEmergencyContact(EmergencyContact contact) {
    _emergencyContacts.add(contact);
    notifyListeners();
  }

  void updateEmergencyContact(String id, EmergencyContact updatedContact) {
    final index = _emergencyContacts.indexWhere((c) => c.id == id);
    if (index != -1) {
      _emergencyContacts[index] = updatedContact;
      notifyListeners();
    }
  }

  void removeEmergencyContact(String id) {
    _emergencyContacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void setPrimaryContact(String id) {
    for (int i = 0; i < _emergencyContacts.length; i++) {
      _emergencyContacts[i] = _emergencyContacts[i].copyWith(
        isPrimary: _emergencyContacts[i].id == id,
      );
    }
    notifyListeners();
  }

  // Alert history management
  void clearAlertHistory() {
    _alertHistory.clear();
    notifyListeners();
  }

  void removeAlert(String id) {
    _alertHistory.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // Test alert (for demonstration)
  void sendTestAlert() {
    final alert = AlertRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: 'Test Alert',
      location: 'Current Location',
      status: 'Sent',
      contactsNotified: _emergencyContacts.map((c) => c.name).toList(),
      notes: 'This was a test alert',
    );
    
    _alertHistory.insert(0, alert);
    notifyListeners();
  }

  // Initialize with sample data for demonstration
  void initializeSampleData() {
    if (_emergencyContacts.isEmpty) {
      _emergencyContacts.addAll([
        EmergencyContact(
          id: '1',
          name: 'John Doe',
          phone: '+1234567890',
          relationship: 'Emergency Contact',
          isPrimary: true,
        ),
        EmergencyContact(
          id: '2',
          name: 'Jane Smith',
          phone: '+0987654321',
          relationship: 'Family',
        ),
      ]);
    }

    if (_alertHistory.isEmpty) {
      _alertHistory.addAll([
        AlertRecord(
          id: '1',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: 'Test Alert',
          location: 'Home',
          status: 'Sent',
          contactsNotified: ['John Doe', 'Jane Smith'],
          notes: 'Monthly test of emergency system',
        ),
        AlertRecord(
          id: '2',
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          type: 'Emergency Alert',
          location: 'Downtown',
          status: 'Sent',
          contactsNotified: ['John Doe'],
          notes: 'Felt unsafe walking alone',
        ),
      ]);
    }
  }
}