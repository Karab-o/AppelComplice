# SafeGuard - Personal Safety Companion App

A comprehensive Flutter application designed to help users stay safe and connected with their loved ones during emergency situations.

## 🚨 Features

### Core Functionality
- **Emergency SOS Button**: Large, prominent button with 3-second countdown safety mechanism
- **Emergency Contacts Management**: Full CRUD operations for trusted contacts
- **Alert History**: Detailed log of all emergency alerts with expandable cards
- **User Profile**: Complete profile setup with medical information
- **Settings**: Comprehensive app configuration options

### Design Highlights
- **Emergency-focused Color Palette**: 
  - Emergency Red (#E53935) for panic button
  - Safe Green (#43A047) for confirmations
  - Warning Orange (#FF9800) for alerts
  - Primary Blue (#1E88E5) for navigation
- **Accessibility**: Large touch targets (56dp buttons) and high contrast
- **Intuitive UX**: Bottom navigation and visual feedback animations
- **Beautiful UI**: Modern Material Design 3 with custom theming

## 📱 Screenshots

The app includes:
1. **Splash Screen** - Beautiful loading screen with app branding
2. **Onboarding** - 3-step guided setup with profile creation
3. **Home Screen** - Prominent SOS button with countdown animation
4. **Contacts Screen** - Emergency contacts management
5. **Alerts History** - Detailed alert logs
6. **Settings Screen** - Complete app configuration

## 🛠 Setup Instructions

### Prerequisites
1. **Flutter SDK** (3.1.0 or higher)
2. **Dart SDK** (included with Flutter)
3. **VS Code** with Flutter extension
4. **Android Studio** or **Xcode** (for device testing)

### Installation Steps

1. **Create Flutter Project**
   ```bash
   flutter create safeguard_app
   cd safeguard_app
   ```

2. **Replace Default Files**
   - Copy all the provided code files to their respective locations:
     - `lib/main.dart`
     - `lib/utils/app_theme.dart`
     - `lib/providers/app_state_provider.dart`
     - `lib/screens/splash_screen.dart`
     - `lib/screens/onboarding_screen.dart`
     - `lib/screens/home_screen.dart`
     - `lib/screens/contacts_screen.dart`
     - `lib/screens/alerts_history_screen.dart`
     - `lib/screens/settings_screen.dart`
     - `pubspec.yaml`

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

### VS Code Setup

1. **Install Extensions**
   - Flutter
   - Dart
   - Flutter Widget Snippets (optional)

2. **Configure Launch**
   - Press `F5` to run in debug mode
   - Use `Ctrl+Shift+P` → "Flutter: Select Device" to choose target

3. **Hot Reload**
   - Save any file (`Ctrl+S`) to see changes instantly
   - Press `r` in terminal for manual hot reload
   - Press `R` for hot restart

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── utils/
│   └── app_theme.dart       # Theme configuration
├── providers/
│   └── app_state_provider.dart  # State management
└── screens/
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── home_screen.dart
    ├── contacts_screen.dart
    ├── alerts_history_screen.dart
    └── settings_screen.dart
```

## 🔧 Dependencies

- **provider**: State management
- **intl**: Date formatting for alert history
- **cupertino_icons**: iOS-style icons

## 🚀 Production Integrations

For a production-ready app, consider adding:

### Location Services
```yaml
geolocator: ^10.1.0
geocoding: ^2.1.1
```

### Communication
```yaml
url_launcher: ^6.2.1  # Phone dialer
flutter_sms: ^2.3.3   # SMS alerts
```

### Security
```yaml
local_auth: ^2.1.7    # Biometric authentication
flutter_secure_storage: ^9.0.0  # Secure data storage
```

### Push Notifications
```yaml
firebase_messaging: ^14.7.6
firebase_core: ^2.24.2
```

### Data Persistence
```yaml
shared_preferences: ^2.2.2
sqflite: ^2.3.0  # Local database
```

## 🔒 Security Features

- **3-Second Countdown**: Prevents accidental emergency alerts
- **Biometric Authentication**: Secure app access (ready for implementation)
- **PIN Protection**: Additional security layer (ready for implementation)
- **Data Encryption**: Secure storage of sensitive information (ready for implementation)

## 📱 Platform Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to send your location during emergencies.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to send your location during emergencies.</string>
<key>NSContactsUsageDescription</key>
<string>This app needs access to contacts to set up emergency contacts.</string>
<key>NSFaceIDUsageDescription</key>
<string>This app uses Face ID for secure authentication.</string>
```

## 🎨 Customization

### Colors
Modify `lib/utils/app_theme.dart` to change the color scheme:
- Emergency Red: `#E53935`
- Safe Green: `#43A047`
- Warning Orange: `#FF9800`
- Primary Blue: `#1E88E5`

### Features
- Add new screens in `lib/screens/`
- Extend `AppStateProvider` for new functionality
- Customize onboarding steps
- Add new settings options

## 🧪 Testing

```bash
# Run tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Analyze code
flutter analyze
```

## 📦 Building for Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Email: support@safeguard.app
- Website: www.safeguard.app
- Issues: GitHub Issues

## ⚠️ Important Notice

This app is designed to assist in emergencies but should not replace official emergency services. Always call your local emergency number (911, 112, etc.) for immediate assistance.

---

**Made with ❤️ for personal safety and peace of mind.**