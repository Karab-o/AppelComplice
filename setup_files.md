# SafeGuard App - Quick Setup Guide

## 📁 File Creation Checklist

After creating your Flutter project, create these files in VS Code:

### 1. Replace `lib/main.dart`
```dart
// Copy the main.dart content from the provided files
```

### 2. Create `lib/utils/app_theme.dart`
```dart
// Copy the app_theme.dart content
```

### 3. Create `lib/providers/app_state_provider.dart`
```dart
// Copy the app_state_provider.dart content
```

### 4. Create `lib/screens/splash_screen.dart`
```dart
// Copy the splash_screen.dart content
```

### 5. Create `lib/screens/onboarding_screen.dart`
```dart
// Copy the onboarding_screen.dart content
```

### 6. Create `lib/screens/home_screen.dart`
```dart
// Copy the home_screen.dart content
```

### 7. Create `lib/screens/contacts_screen.dart`
```dart
// Copy the contacts_screen.dart content
```

### 8. Create `lib/screens/alerts_history_screen.dart`
```dart
// Copy the alerts_history_screen.dart content
```

### 9. Create `lib/screens/settings_screen.dart`
```dart
// Copy the settings_screen.dart content
```

## 🚀 Quick VS Code Tips

### Keyboard Shortcuts:
- `Ctrl+Shift+P`: Command Palette
- `Ctrl+``: Open Terminal
- `Ctrl+S`: Save file
- `F5`: Run app in debug mode
- `Ctrl+Shift+E`: Explorer panel
- `Ctrl+Shift+X`: Extensions panel

### Flutter-specific shortcuts:
- `r`: Hot reload (in debug terminal)
- `R`: Hot restart (in debug terminal)
- `q`: Quit app (in debug terminal)

### VS Code Flutter Extensions:
1. **Flutter** - Main Flutter support
2. **Dart** - Dart language support
3. **Flutter Widget Snippets** - Code snippets
4. **Awesome Flutter Snippets** - More snippets
5. **Flutter Tree** - Widget tree visualization

## 🎯 Step-by-Step Process:

1. **Open VS Code**
2. **Create Flutter project**: `Ctrl+Shift+P` → "Flutter: New Project"
3. **Create folder structure**: Right-click in Explorer to create folders
4. **Copy files**: Create each file and paste the provided content
5. **Install dependencies**: `flutter pub get` in terminal
6. **Run app**: `F5` or `flutter run`

## 🔧 Troubleshooting:

### Common Issues:
- **Import errors**: Make sure all files are created
- **Dependency errors**: Run `flutter pub get`
- **Device not found**: Connect device or start emulator
- **Build errors**: Check for typos in file names/content

### VS Code Flutter Doctor:
```bash
flutter doctor -v
```

### Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```