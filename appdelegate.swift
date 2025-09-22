export default SignIn;

// ==========================================
// STEP 7: Enhanced SignUp Component
// ==========================================

// src/components/AuthPages/SignUp.js (Updated)
import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Alert,
  ActivityIndicator
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/FontAwesome5';
import { colors } from '../../utils/colors';
import { useAuth } from '../../contexts/AuthContext';
import InputField from '../common/InputField';
import Button from '../common/Button';

const SignUp = ({ navigation }) => {
  const { signUp, signInWithGoogle, loading, error, clearError } = useAuth();
  const [formData, setFormData] = useState({
    displayName: '',
    email: '',
    password: '',
    confirmPassword: '',
    phoneNumber: '',
    termsAccepted: false,
    twoFactorEnabled: false
  });
  const [step, setStep] = useState(1);
  const [passwordStrength, setPasswordStrength] = useState(null);

  React.useEffect(() => {
    clearError();
  }, []);

  const updateFormData = (key, value) => {
    setFormData(prev => ({ ...prev, [key]: value }));
    
    if (key === 'password') {
      setPasswordStrength(validatePassword(value));
    }
  };

  const validatePassword = (password) => {
    const minLength = password.length >= 8;
    const hasUppercase = /[A-Z]/.test(password);
    const hasLowercase = /[a-z]/.test(password);
    const hasNumbers = /\d/.test(password);
    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
    
    const score = [minLength, hasUppercase, hasLowercase, hasNumbers, hasSpecialChar]
      .reduce((acc, curr) => acc + (curr ? 1 : 0), 0);
    
    return {
      score,
      isValid: score >= 4,
      strength: score <= 2 ? 'weak' : score === 3 ? 'medium' : score === 4 ? 'good' : 'strong'
    };
  };

  const getPasswordStrengthColor = () => {
    if (!passwordStrength) return colors.secondary.lightGray;
    switch (passwordStrength.strength) {
      case 'weak': return colors.primary.dangerRed;
      case 'medium': return colors.primary.alertOrange;
      case 'good': return colors.primary.calmBlue;
      case 'strong': return colors.primary.safetyGreen;
      default: return colors.secondary.lightGray;
    }
  };

  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const handleNext = () => {
    const { displayName, email, password, confirmPassword, termsAccepted } = formData;
    
    if (!displayName.trim()) {
      Alert.alert('Error', 'Please enter your full name');
      return;
    }
    
    if (!validateEmail(email)) {
      Alert.alert('Error', 'Please enter a valid email address');
      return;
    }
    
    if (!passwordStrength?.isValid) {
      Alert.alert('Error', 'Password does not meet security requirements');
      return;
    }
    
    if (password !== confirmPassword) {
      Alert.alert('Error', 'Passwords do not match');
      return;
    }
    
    if (!termsAccepted) {
      Alert.alert('Error', 'Please accept the terms and conditions');
      return;
    }
    
    setStep(2);
  };

  const handleSignUp = async () => {
    try {
      await signUp(formData.email, formData.password, {
        displayName: formData.displayName,
        phoneNumber: formData.phoneNumber,
        twoFactorEnabled: formData.twoFactorEnabled,
      });
    } catch (error) {
      // Error is handled by AuthContext
    }
  };

  const handleGoogleSignUp = async () => {
    try {
      await signInWithGoogle();
    } catch (error) {
      // Error is handled by AuthContext
    }
  };

  const renderStep1 = () => (
    <>
      <InputField
        placeholder="Full Name"
        value={formData.displayName}
        onChangeText={(value) => updateFormData('displayName', value)}
        icon="user"
        validationIcon
        isValid={formData.displayName.length > 2}
      />

      <InputField
        placeholder="Email"
        value={formData.email}
        onChangeText={(value) => updateFormData('email', value)}
        keyboardType="email-address"
        autoCapitalize="none"
        icon="envelope"
        validationIcon
        isValid={validateEmail(formData.email)}
      />

      <InputField
        placeholder="Password"
        value={formData.password}
        onChangeText={(value) => updateFormData('password', value)}
        secureTextEntry
        showPasswordToggle
        icon="lock"
        validationIcon
        isValid={passwordStrength?.isValid}
      />
      
      {passwordStrength && formData.password.length > 0 && (
        <View style={styles.passwordStrengthContainer}>
          <View style={styles.strengthBar}>
            <View 
              style={[
                styles.strengthFill,
                { 
                  width: `${(passwordStrength.score / 5) * 100}%`,
                  backgroundColor: getPasswordStrengthColor()
                }
              ]} 
            />
          </View>
          <Text style={[styles.strengthText, { color: getPasswordStrengthColor() }]}>
            Password strength: {passwordStrength.strength.toUpperCase()}
          </Text>
        </View>
      )}

      <InputField
        placeholder="Confirm Password"
        value={formData.confirmPassword}
        onChangeText={(value) => updateFormData('confirmPassword', value)}
        secureTextEntry
        showPasswordToggle
        icon="lock"
        validationIcon
        isValid={formData.password === formData.confirmPassword && formData.confirmPassword.length > 0}
      />

      <TouchableOpacity
        style={styles.checkboxContainer}
        onPress={() => updateFormData('termsAccepted', !formData.termsAccepted)}
      >
        <View style={[styles.checkbox, formData.termsAccepted && styles.checkboxChecked]}>
          {formData.termsAccepted && <Icon name="check" size={12} color={colors.primary.safetyGreen} />}
        </View>
        <Text style={styles.checkboxText}>
          I agree to the <Text style={styles.linkText}>Terms & Privacy Policy</Text>
        </Text>
      </TouchableOpacity>

      <Button
        title="Next: Security Setup"
        onPress={handleNext}
        disabled={loading}
        style={styles.nextButton}
      />

      <View style={styles.divider}>
        <View style={styles.dividerLine} />
        <Text style={styles.dividerText}>OR</Text>
        <View style={styles.dividerLine} />
      </View>

      <Button
        title="Continue with Google"
        onPress={handleGoogleSignUp}
        variant="outline"
        disabled={loading}
        style={styles.googleButton}
        icon="🔍"
      />
    </>
  );

  const renderStep2 = () => (
    <>
      <Text style={styles.stepTitle}>Security Setup</Text>
      <Text style={styles.stepDescription}>
        Enhance your account security with additional options
      </Text>

      <InputField
        placeholder="Phone Number (Optional)"
        value={formData.phoneNumber}
        onChangeText={(value) => updateFormData('phoneNumber', value)}
        keyboardType="phone-pad"
        icon="mobile-alt"
      />

      <TouchableOpacity
        style={styles.checkboxContainer}
        onPress={() => updateFormData('twoFactorEnabled', !formData.twoFactorEnabled)}
      >
        <View style={[styles.checkbox, formData.twoFactorEnabled && styles.checkboxChecked]}>
          {formData.twoFactorEnabled && <Icon name="check" size={12} color={colors.primary.safetyGreen} />}
        </View>
        <Text style={styles.checkboxText}>
          Enable Two-Factor Authentication (Recommended)
        </Text>
      </TouchableOpacity>

      <View style={styles.securityTip}>
        <Icon name="shield-alt" size={16} color={colors.primary.safetyGreen} />
        <Text style={styles.securityTipText}>
          2FA adds an extra layer of security to your account
        </Text>
      </View>

      <View style={styles.buttonRow}>
        <Button
          title="Back"
          onPress={() => setStep(1)}
          variant="secondary"
          style={styles.backButton}
          disabled={loading}
        />
        <Button
          title={loading ? "Creating..." : "Create Account"}
          onPress={handleSignUp}
          loading={loading}
          style={styles.createButton}
        />
      </View>
    </>
  );

  return (
    <LinearGradient
      colors={colors.gradients.greenGray}
      style={styles.container}
    >
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.content}>
          <View style={styles.logoContainer}>
            <Text style={styles.logoText}>Join Complice</Text>
            <Text style={styles.tagline}>Stay safe together</Text>
          </View>

          <View style={styles.progressIndicator}>
            <View style={[styles.progressDot, step >= 1 && styles.progressDotActive]} />
            <View style={[styles.progressLine, step >= 2 && styles.progressLineActive]} />
            <View style={[styles.progressDot, step >= 2 && styles.progressDotActive]} />
          </View>

          <View style={styles.formContainer}>
            {error && (
              <View style={styles.errorContainer}>
                <Icon name="exclamation-triangle" size={16} color={colors.primary.dangerRed} />
                <Text style={styles.errorText}>{error}</Text>
              </View>
            )}

            {step === 1 ? renderStep1() : renderStep2()}

            <TouchableOpacity
              style={styles.linkContainer}
              onPress={() => navigation.navigate('SignIn')}
              disabled={loading}
            >
              <Text style={styles.linkText}>
                Already have an account? <Text style={styles.linkHighlight}>Sign In</Text>
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
      
      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color={colors.secondary.white} />
        </View>
      )}
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    flex: 1,
    paddingHorizontal: 30,
    paddingTop: 60,
    paddingBottom: 30,
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 30,
  },
  logoText: {
    fontSize: 32,
    fontWeight: '700',
    color: colors.secondary.white,
    fontFamily: 'Poppins-Bold',
  },
  tagline: {
    color: 'rgba(255, 255, 255, 0.8)',
    marginTop: 8,
    fontSize: 16,
    fontFamily: 'Poppins-Regular',
  },
  progressIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 30,
  },
  progressDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  progressDotActive: {
    backgroundColor: colors.secondary.white,
  },
  progressLine: {
    width: 50,
    height: 2,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    marginHorizontal: 8,
  },
  progressLineActive: {
    backgroundColor: colors.secondary.white,
  },
  formContainer: {
    flex: 1,
  },
  errorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(208, 2, 27, 0.1)',
    padding: 12,
    borderRadius: 8,
    marginBottom: 16,
  },
  errorText: {
    color: colors.primary.dangerRed,
    marginLeft: 8,
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  passwordStrengthContainer: {
    marginBottom: 16,
  },
  strengthBar: {
    height: 4,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    borderRadius: 2,
    marginBottom: 8,
  },
  strengthFill: {
    height: '100%',
    borderRadius: 2,
  },
  strengthText: {
    fontSize: 12,
    fontFamily: 'Poppins-Regular',
  },
  checkboxContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  checkbox: {
    width: 20,
    height: 20,
    borderWidth: 2,
    borderColor: 'rgba(255, 255, 255, 0.5)',
    borderRadius: 4,
    marginRight: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  checkboxChecked: {
    backgroundColor: colors.secondary.white,
    borderColor: colors.secondary.white,
  },
  checkboxText: {
    flex: 1,
    color: 'rgba(255, 255, 255, 0.9)',
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  nextButton: {
    marginTop: 20,
    marginBottom: 30,
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  dividerText: {
    color: 'rgba(255, 255, 255, 0.6)',
    marginHorizontal: 16,
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  googleButton: {
    marginBottom: 30,
  },
  stepTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: colors.secondary.white,
    textAlign: 'center',
    marginBottom: 8,
    fontFamily: 'Poppins-SemiBold',
  },
  stepDescription: {
    color: 'rgba(255, 255, 255, 0.8)',
    textAlign: 'center',
    marginBottom: 30,
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  securityTip: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(126, 211, 33, 0.1)',
    padding: 12,
    borderRadius: 8,
    marginBottom: 20,
  },
  securityTipText: {
    flex: 1,
    color: 'rgba(255, 255, 255, 0.9)',
    marginLeft: 8,
    fontSize: 13,
    fontFamily: 'Poppins-Regular',
  },
  buttonRow: {
    flexDirection: 'row',
    gap: 12,
    marginTop: 20,
    marginBottom: 30,
  },
  backButton: {
    flex: 1,
  },
  createButton: {
    flex: 1,
  },
  linkContainer: {
    alignItems: 'center',
    marginTop: 20,
  },
  linkText: {
    color: 'rgba(255, 255, 255, 0.7)',
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  linkHighlight: {
    color: colors.secondary.white,
    fontWeight: '600',
    fontFamily: 'Poppins-SemiBold',
  },
  loadingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default SignUp;

// ==========================================
// STEP 8: Protected Route Component
// ==========================================

// src/components/common/ProtectedRoute.js
import React from 'react';
import { View, ActivityIndicator } from 'react-native';
import { useAuth } from '../../contexts/AuthContext';
import { colors } from '../../utils/colors';

const ProtectedRoute = ({ children, fallback = null }) => {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color={colors.primary.calmBlue} />
      </View>
    );
  }

  if (!isAuthenticated) {
    return fallback;
  }

  return children;
};

export default ProtectedRoute;

// ==========================================
// STEP 9: Main App Component with Authentication
// ==========================================

// App.js (Updated)
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { StatusBar, View, ActivityIndicator } from 'react-native';
import { AuthProvider, useAuth } from './src/contexts/AuthContext';
import { colors } from './src/utils/colors';

// Auth Components
import SignIn from './src/components/AuthPages/SignIn';
import SignUp from './src/components/AuthPages/SignUp';

// Main App Components
import Navigation from './src/components/common/Navigation';
import ProtectedRoute from './src/components/common/ProtectedRoute';

const Stack = createStackNavigator();

const AuthStack = () => (
  <Stack.Navigator screenOptions={{ headerShown: false }}>
    <Stack.Screen name="SignIn" component={SignIn} />
    <Stack.Screen name="SignUp" component={SignUp} />
  </Stack.Navigator>
);

const AppNavigator = () => {
  const { isAuthenticated, loading, user } = useAuth();

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <ActivityIndicator size="large" color={colors.primary.calmBlue} />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <StatusBar barStyle="light-content" backgroundColor={colors.primary.calmBlue} />
      {isAuthenticated ? <Navigation user={user} /> : <AuthStack />}
    </NavigationContainer>
  );
};

const App = () => {
  return (
    <AuthProvider>
      <AppNavigator />
    </AuthProvider>
  );
};

export default App;

// ==========================================
// STEP 10: Firebase Security Rules
// ==========================================

/* 
Add these security rules in Firebase Console > Firestore Database > Rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Emergency contacts - only the user can read/write
    match /users/{userId}/emergencyContacts/{contactId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // User sessions - only the user can read/write
    match /users/{userId}/sessions/{sessionId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Safety reports - authenticated users can read, only owner can write
    match /safetyReports/{reportId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        (request.auth.uid == resource.data.userId || !('userId' in resource.data));
    }
    
    // Emergency alerts - only trusted contacts can read
    match /emergencyAlerts/{alertId} {
      allow read: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         request.auth.uid in resource.data.trustedContacts);
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
*/

// ==========================================
// STEP 11: Android Configuration
// ==========================================

/*
1. Add to android/app/build.gradle (at the bottom):
   apply plugin: 'com.google.gms.google-services'

2. Add to android/build.gradle (in dependencies):
   classpath 'com.google.gms:google-services:4.3.15'

3. Add to android/app/src/main/AndroidManifest.xml (in <application>):
   <meta-data
     android:name="com.google.firebase.messaging.default_notification_icon"
     android:resource="@drawable/ic_notification" />
   <meta-data
     android:name="com.google.firebase.messaging.default_notification_color"
     android:resource="@color/notification_color" />

4. For Google Sign-In, add to android/app/build.gradle:
   implementation 'com.google.android.gms:play-services-auth:20.6.0'
*/

// ==========================================
// STEP 12: iOS Configuration
// ==========================================

/*
1. Add GoogleService-Info.plist to ios/YourApp/

2. In ios/YourApp/AppDelegate.m, add at the top:
   #import <Firebase.h>

3. In ios/YourApp/AppDelegate.m, add to didFinishLaunchingWithOptions:
   [FIRApp configure];

4. For Google Sign-In, add to ios/YourApp/Info.plist:
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLName</key>
       <string>REVERSED_CLIENT_ID</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>

5. Run: cd ios && pod install
*/

// ==========================================
// STEP 13: Usage Instructions
// ==========================================

/*
SETUP CHECKLIST:

✅ 1. Create Firebase project
✅ 2. Enable Authentication methods
✅ 3. Download config files
✅ 4. Install packages
✅ 5. Configure Android/iOS
✅ 6. Set up Firestore rules
✅ 7. Configure Google Sign-In
✅ 8. Test authentication flow

FEATURES IMPLEMENTED:

✅ Email/Password authentication
✅ Google Sign-In
✅ Phone authentication (partial)
✅ Password validation & strength
✅ Email verification
✅ Password reset
✅ Secure session management
✅ Error handling
✅ Loading states
✅ Form validation
✅ Two-factor setup (UI)
✅ Profile management
✅ Firestore integration
✅ Security rules

NEXT STEPS:

1. Test on real devices
2. Add phone verification
3. Implement biometric auth
4. Add session timeout
5. Implement account recovery
6. Add audit logging
7. Test security thoroughly
*/// ==========================================
// STEP 1: Firebase Project Setup
// ==========================================
/*
1. Go to https://console.firebase.google.com/
2. Create a new project called "complice-safety-app"
3. Enable Authentication in Firebase Console
4. Enable sign-in methods: Email/Password, Google, Phone
5. Download google-services.json (Android) and GoogleService-Info.plist (iOS)
6. Place files in appropriate directories:
   - android/app/google-services.json
   - ios/YourApp/GoogleService-Info.plist
*/

// ==========================================
// STEP 2: Package Installation
// ==========================================
/*
Run these commands in your project root:

npm install @react-native-firebase/app
npm install @react-native-firebase/auth
npm install @react-native-firebase/firestore
npm install @react-native-firebase/messaging
npm install @react-native-google-signin/google-signin
npm install react-native-keychain
npm install @react-native-async-storage/async-storage

For iOS:
cd ios && pod install

For Android, add to android/app/build.gradle:
apply plugin: 'com.google.gms.google-services'

And in android/build.gradle:
classpath 'com.google.gms:google-services:4.3.15'
*/

// ==========================================
// STEP 3: Firebase Configuration
// ==========================================

// src/services/firebase/config.js
import { initializeApp, getApps } from '@react-native-firebase/app';
import auth from '@react-native-firebase/auth';
import firestore from '@react-native-firebase/firestore';
import messaging from '@react-native-firebase/messaging';

// Firebase config (get from Firebase Console)
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "complice-safety-app.firebaseapp.com",
  projectId: "complice-safety-app",
  storageBucket: "complice-safety-app.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:android:abcdef123456789",
};

// Initialize Firebase only if not already initialized
let app;
if (getApps().length === 0) {
  app = initializeApp(firebaseConfig);
} else {
  app = getApps()[0];
}

export { auth, firestore, messaging };
export default app;

// ==========================================
// STEP 4: Authentication Service
// ==========================================

// src/services/auth/AuthService.js
import auth from '@react-native-firebase/auth';
import firestore from '@react-native-firebase/firestore';
import { GoogleSignin } from '@react-native-google-signin/google-signin';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Keychain from 'react-native-keychain';
import { Alert } from 'react-native';

// Configure Google Sign-In
GoogleSignin.configure({
  webClientId: 'your-web-client-id.googleusercontent.com', // From Firebase Console
});

class AuthService {
  constructor() {
    this.user = null;
    this.authStateChangedListeners = [];
  }

  // Initialize authentication state listener
  initializeAuthListener() {
    return auth().onAuthStateChanged(async (user) => {
      if (user) {
        // User is signed in
        await this.handleUserSignedIn(user);
      } else {
        // User is signed out
        await this.handleUserSignedOut();
      }
      
      // Notify all listeners
      this.authStateChangedListeners.forEach(callback => callback(user));
    });
  }

  // Add auth state change listener
  addAuthStateListener(callback) {
    this.authStateChangedListeners.push(callback);
  }

  // Remove auth state change listener
  removeAuthStateListener(callback) {
    this.authStateChangedListeners = this.authStateChangedListeners.filter(
      listener => listener !== callback
    );
  }

  // Handle user signed in
  async handleUserSignedIn(firebaseUser) {
    try {
      // Get user document from Firestore
      const userDoc = await firestore()
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

      let userData = {
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
        phoneNumber: firebaseUser.phoneNumber,
        emailVerified: firebaseUser.emailVerified,
        isAnonymous: firebaseUser.isAnonymous,
        creationTime: firebaseUser.metadata.creationTime,
        lastSignInTime: firebaseUser.metadata.lastSignInTime,
      };

      if (userDoc.exists) {
        // Merge Firebase auth data with Firestore user data
        userData = { ...userData, ...userDoc.data() };
        
        // Update last login
        await this.updateLastLogin(firebaseUser.uid);
      } else {
        // Create new user document in Firestore
        await this.createUserDocument(userData);
      }

      this.user = userData;
      
      // Store user session securely
      await this.storeUserSession(userData);
      
      return userData;
    } catch (error) {
      console.error('Error handling user sign in:', error);
      throw error;
    }
  }

  // Handle user signed out
  async handleUserSignedOut() {
    this.user = null;
    await this.clearUserSession();
  }

  // Create user document in Firestore
  async createUserDocument(userData) {
    const userRef = firestore().collection('users').doc(userData.uid);
    
    const newUserData = {
      ...userData,
      createdAt: firestore.FieldValue.serverTimestamp(),
      updatedAt: firestore.FieldValue.serverTimestamp(),
      lastLogin: firestore.FieldValue.serverTimestamp(),
      profile: {
        isProfileComplete: false,
        hasEmergencyContacts: false,
        locationSharingEnabled: false,
        twoFactorEnabled: false,
      },
      settings: {
        notifications: {
          push: true,
          email: true,
          sms: false,
        },
        privacy: {
          locationSharing: 'contacts',
          profileVisibility: 'private',
        },
        emergency: {
          autoAlert: true,
          alertDelay: 10, // seconds
        }
      },
      emergencyContacts: [],
      sessions: [],
    };

    await userRef.set(newUserData);
    return newUserData;
  }

  // Update last login timestamp
  async updateLastLogin(uid) {
    await firestore()
      .collection('users')
      .doc(uid)
      .update({
        lastLogin: firestore.FieldValue.serverTimestamp(),
        updatedAt: firestore.FieldValue.serverTimestamp(),
      });
  }

  // Store user session securely
  async storeUserSession(userData) {
    try {
      // Store in Keychain (most secure)
      await Keychain.setInternetCredentials(
        'complice_user_session',
        userData.uid,
        JSON.stringify({
          uid: userData.uid,
          email: userData.email,
          sessionToken: await this.generateSessionToken(),
          expiresAt: Date.now() + (7 * 24 * 60 * 60 * 1000), // 7 days
        })
      );

      // Store basic info in AsyncStorage for quick access
      await AsyncStorage.setItem('user_authenticated', 'true');
      await AsyncStorage.setItem('user_uid', userData.uid);
    } catch (error) {
      console.error('Error storing user session:', error);
    }
  }

  // Clear user session
  async clearUserSession() {
    try {
      await Keychain.resetInternetCredentials('complice_user_session');
      await AsyncStorage.removeItem('user_authenticated');
      await AsyncStorage.removeItem('user_uid');
    } catch (error) {
      console.error('Error clearing user session:', error);
    }
  }

  // Generate session token
  async generateSessionToken() {
    const currentUser = auth().currentUser;
    if (currentUser) {
      return await currentUser.getIdToken();
    }
    return null;
  }

  // Check if user session is valid
  async isSessionValid() {
    try {
      const credentials = await Keychain.getInternetCredentials('complice_user_session');
      if (credentials && credentials.password) {
        const sessionData = JSON.parse(credentials.password);
        return Date.now() < sessionData.expiresAt;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  // Sign up with email and password
  async signUpWithEmail(email, password, additionalData = {}) {
    try {
      // Validate input
      if (!this.validateEmail(email)) {
        throw new Error('Invalid email format');
      }
      
      if (!this.validatePassword(password)) {
        throw new Error('Password does not meet security requirements');
      }

      // Create Firebase user
      const userCredential = await auth().createUserWithEmailAndPassword(email, password);
      const user = userCredential.user;

      // Update display name if provided
      if (additionalData.displayName) {
        await user.updateProfile({
          displayName: additionalData.displayName
        });
      }

      // Send email verification
      await user.sendEmailVerification();

      // Create user document with additional data
      const userData = {
        uid: user.uid,
        email: user.email,
        displayName: additionalData.displayName || '',
        phoneNumber: additionalData.phoneNumber || '',
        emailVerified: user.emailVerified,
        ...additionalData
      };

      await this.createUserDocument(userData);

      Alert.alert(
        'Account Created',
        'Please check your email to verify your account.',
        [{ text: 'OK' }]
      );

      return user;
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Sign in with email and password
  async signInWithEmail(email, password) {
    try {
      if (!this.validateEmail(email)) {
        throw new Error('Invalid email format');
      }

      const userCredential = await auth().signInWithEmailAndPassword(email, password);
      return userCredential.user;
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Sign in with Google
  async signInWithGoogle() {
    try {
      // Check if your device supports Google Play
      await GoogleSignin.hasPlayServices({ showPlayServicesUpdateDialog: true });
      
      // Get the users ID token
      const { idToken } = await GoogleSignin.signIn();
      
      // Create a Google credential with the token
      const googleCredential = auth.GoogleAuthProvider.credential(idToken);
      
      // Sign-in the user with the credential
      return auth().signInWithCredential(googleCredential);
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Sign in with phone number
  async signInWithPhoneNumber(phoneNumber) {
    try {
      const confirmation = await auth().signInWithPhoneNumber(phoneNumber);
      return confirmation;
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Verify phone number with code
  async verifyPhoneCode(confirmation, code) {
    try {
      const userCredential = await confirmation.confirm(code);
      return userCredential.user;
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Sign out
  async signOut() {
    try {
      // Sign out from Google if signed in
      if (await GoogleSignin.isSignedIn()) {
        await GoogleSignin.revokeAccess();
        await GoogleSignin.signOut();
      }
      
      // Sign out from Firebase
      await auth().signOut();
      
      Alert.alert('Signed Out', 'You have been signed out successfully.');
    } catch (error) {
      console.error('Error signing out:', error);
      throw error;
    }
  }

  // Reset password
  async resetPassword(email) {
    try {
      await auth().sendPasswordResetEmail(email);
      Alert.alert(
        'Password Reset',
        'Password reset email sent. Please check your inbox.',
        [{ text: 'OK' }]
      );
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Update password
  async updatePassword(newPassword) {
    try {
      const user = auth().currentUser;
      if (!user) throw new Error('No authenticated user');
      
      if (!this.validatePassword(newPassword)) {
        throw new Error('Password does not meet security requirements');
      }
      
      await user.updatePassword(newPassword);
      Alert.alert('Success', 'Password updated successfully.');
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Update profile
  async updateProfile(profileData) {
    try {
      const user = auth().currentUser;
      if (!user) throw new Error('No authenticated user');

      // Update Firebase Auth profile
      await user.updateProfile({
        displayName: profileData.displayName,
        photoURL: profileData.photoURL,
      });

      // Update Firestore user document
      await firestore()
        .collection('users')
        .doc(user.uid)
        .update({
          ...profileData,
          updatedAt: firestore.FieldValue.serverTimestamp(),
        });

      Alert.alert('Success', 'Profile updated successfully.');
    } catch (error) {
      this.handleAuthError(error);
      throw error;
    }
  }

  // Email validation
  validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  // Password validation
  validatePassword(password) {
    const minLength = password.length >= 8;
    const hasUppercase = /[A-Z]/.test(password);
    const hasLowercase = /[a-z]/.test(password);
    const hasNumbers = /\d/.test(password);
    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
    
    const score = [minLength, hasUppercase, hasLowercase, hasNumbers, hasSpecialChar]
      .reduce((acc, curr) => acc + (curr ? 1 : 0), 0);
    
    return score >= 4;
  }

  // Handle authentication errors
  handleAuthError(error) {
    let message = 'An error occurred. Please try again.';
    
    switch (error.code) {
      case 'auth/user-not-found':
        message = 'No account found with this email.';
        break;
      case 'auth/wrong-password':
        message = 'Incorrect password.';
        break;
      case 'auth/email-already-in-use':
        message = 'An account already exists with this email.';
        break;
      case 'auth/weak-password':
        message = 'Password is too weak.';
        break;
      case 'auth/invalid-email':
        message = 'Invalid email address.';
        break;
      case 'auth/too-many-requests':
        message = 'Too many failed attempts. Please try again later.';
        break;
      case 'auth/network-request-failed':
        message = 'Network error. Please check your connection.';
        break;
      default:
        console.error('Auth Error:', error);
        message = error.message || message;
    }
    
    Alert.alert('Authentication Error', message);
  }

  // Get current user
  getCurrentUser() {
    return this.user;
  }

  // Check if user is authenticated
  isAuthenticated() {
    return !!auth().currentUser;
  }

  // Get Firebase user
  getFirebaseUser() {
    return auth().currentUser;
  }
}

export default new AuthService();

// ==========================================
// STEP 5: Auth Context Provider
// ==========================================

// src/contexts/AuthContext.js
import React, { createContext, useContext, useReducer, useEffect } from 'react';
import AuthService from '../services/auth/AuthService';

const AuthContext = createContext();

const authReducer = (state, action) => {
  switch (action.type) {
    case 'LOADING':
      return { ...state, loading: true };
    case 'AUTHENTICATED':
      return {
        ...state,
        user: action.payload,
        isAuthenticated: true,
        loading: false,
        error: null,
      };
    case 'UNAUTHENTICATED':
      return {
        ...state,
        user: null,
        isAuthenticated: false,
        loading: false,
        error: null,
      };
    case 'ERROR':
      return {
        ...state,
        error: action.payload,
        loading: false,
      };
    case 'CLEAR_ERROR':
      return { ...state, error: null };
    default:
      return state;
  }
};

const initialState = {
  user: null,
  isAuthenticated: false,
  loading: true,
  error: null,
};

export const AuthProvider = ({ children }) => {
  const [state, dispatch] = useReducer(authReducer, initialState);

  useEffect(() => {
    // Initialize auth listener
    const unsubscribe = AuthService.initializeAuthListener();
    
    // Add auth state change listener
    AuthService.addAuthStateListener((user) => {
      if (user) {
        dispatch({ type: 'AUTHENTICATED', payload: AuthService.getCurrentUser() });
      } else {
        dispatch({ type: 'UNAUTHENTICATED' });
      }
    });

    return () => {
      unsubscribe();
    };
  }, []);

  const signUp = async (email, password, additionalData) => {
    dispatch({ type: 'LOADING' });
    try {
      await AuthService.signUpWithEmail(email, password, additionalData);
    } catch (error) {
      dispatch({ type: 'ERROR', payload: error.message });
      throw error;
    }
  };

  const signIn = async (email, password) => {
    dispatch({ type: 'LOADING' });
    try {
      await AuthService.signInWithEmail(email, password);
    } catch (error) {
      dispatch({ type: 'ERROR', payload: error.message });
      throw error;
    }
  };

  const signInWithGoogle = async () => {
    dispatch({ type: 'LOADING' });
    try {
      await AuthService.signInWithGoogle();
    } catch (error) {
      dispatch({ type: 'ERROR', payload: error.message });
      throw error;
    }
  };

  const signOut = async () => {
    dispatch({ type: 'LOADING' });
    try {
      await AuthService.signOut();
    } catch (error) {
      dispatch({ type: 'ERROR', payload: error.message });
      throw error;
    }
  };

  const resetPassword = async (email) => {
    try {
      await AuthService.resetPassword(email);
    } catch (error) {
      dispatch({ type: 'ERROR', payload: error.message });
      throw error;
    }
  };

  const clearError = () => {
    dispatch({ type: 'CLEAR_ERROR' });
  };

  const value = {
    ...state,
    signUp,
    signIn,
    signInWithGoogle,
    signOut,
    resetPassword,
    clearError,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

// ==========================================
// STEP 6: Enhanced SignIn Component
// ==========================================

// src/components/AuthPages/SignIn.js (Updated)
import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Animated,
  Alert,
  ActivityIndicator
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/FontAwesome5';
import { colors } from '../../utils/colors';
import { useAuth } from '../../contexts/AuthContext';
import InputField from '../common/InputField';
import Button from '../common/Button';

const SignIn = ({ navigation }) => {
  const { signIn, signInWithGoogle, resetPassword, loading, error, clearError } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showForgotPassword, setShowForgotPassword] = useState(false);

  const logoAnimation = new Animated.Value(0);

  React.useEffect(() => {
    // Clear any previous errors
    clearError();
    
    // Start logo animation
    Animated.loop(
      Animated.sequence([
        Animated.timing(logoAnimation, {
          toValue: 1,
          duration: 2000,
          useNativeDriver: true,
        }),
        Animated.timing(logoAnimation, {
          toValue: 0,
          duration: 2000,
          useNativeDriver: true,
        }),
      ])
    ).start();
  }, []);

  const bounceStyle = {
    transform: [
      {
        translateY: logoAnimation.interpolate({
          inputRange: [0, 0.5, 1],
          outputRange: [0, -10, 0],
        }),
      },
    ],
  };

  const handleSignIn = async () => {
    if (!email.trim() || !password.trim()) {
      Alert.alert('Error', 'Please enter both email and password');
      return;
    }

    try {
      await signIn(email, password);
    } catch (error) {
      // Error is handled by AuthContext
    }
  };

  const handleGoogleSignIn = async () => {
    try {
      await signInWithGoogle();
    } catch (error) {
      // Error is handled by AuthContext
    }
  };

  const handleForgotPassword = async () => {
    if (!email.trim()) {
      Alert.alert('Error', 'Please enter your email address first');
      return;
    }

    try {
      await resetPassword(email);
    } catch (error) {
      // Error is handled by AuthContext
    }
  };

  return (
    <LinearGradient
      colors={colors.gradients.blueGray}
      style={styles.container}
    >
      <View style={styles.content}>
        <Animated.View style={[styles.logoContainer, bounceStyle]}>
          <Text style={styles.logoText}>Complice</Text>
          <Text style={styles.tagline}>Your safety companion</Text>
        </Animated.View>

        <View style={styles.formContainer}>
          {error && (
            <View style={styles.errorContainer}>
              <Icon name="exclamation-triangle" size={16} color={colors.primary.dangerRed} />
              <Text style={styles.errorText}>{error}</Text>
            </View>
          )}

          <InputField
            placeholder="Email"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
            icon="envelope"
            validationIcon
            isValid={/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)}
          />

          <InputField
            placeholder="Password"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            showPasswordToggle
            icon="lock"
          />

          <TouchableOpacity
            style={styles.forgotPasswordButton}
            onPress={handleForgotPassword}
          >
            <Text style={styles.forgotPasswordText}>Forgot Password?</Text>
          </TouchableOpacity>

          <Button
            title={loading ? "Signing In..." : "Sign In"}
            onPress={handleSignIn}
            loading={loading}
            disabled={!email || !password || loading}
            style={styles.signInButton}
          />

          <View style={styles.divider}>
            <View style={styles.dividerLine} />
            <Text style={styles.dividerText}>OR</Text>
            <View style={styles.dividerLine} />
          </View>

          <Button
            title="Continue with Google"
            onPress={handleGoogleSignIn}
            variant="outline"
            disabled={loading}
            style={styles.googleButton}
            icon="🔍"
          />

          <TouchableOpacity
            style={styles.linkContainer}
            onPress={() => navigation.navigate('SignUp')}
            disabled={loading}
          >
            <Text style={styles.linkText}>
              Don't have an account? <Text style={styles.linkHighlight}>Sign Up</Text>
            </Text>
          </TouchableOpacity>
        </View>
      </View>
      
      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color={colors.secondary.white} />
        </View>
      )}
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    paddingHorizontal: 30,
    paddingTop: 80,
    paddingBottom: 30,
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 60,
  },
  logoText: {
    fontSize: 36,
    fontWeight: '700',
    color: colors.secondary.white,
    fontFamily: 'Poppins-Bold',
  },
  tagline: {
    color: 'rgba(255, 255, 255, 0.8)',
    marginTop: 8,
    fontSize: 16,
    fontFamily: 'Poppins-Regular',
  },
  formContainer: {
    flex: 1,
  },
  errorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(208, 2, 27, 0.1)',
    padding: 12,
    borderRadius: 8,
    marginBottom: 16,
  },
  errorText: {
    color: colors.primary.dangerRed,
    marginLeft: 8,
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  forgotPasswordButton: {
    alignSelf: 'flex-end',
    marginBottom: 20,
  },
  forgotPasswordText: {
    color: 'rgba(255, 255, 255, 0.8)',
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  signInButton: {
    marginBottom: 30,
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  dividerText: {
    color: 'rgba(255, 255, 255, 0.6)',
    marginHorizontal: 16,
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  googleButton: {
    marginBottom: 30,
  },
  linkContainer: {
    alignItems: 'center',
    marginTop: 20,
  },
  linkText: {
    color: 'rgba(255, 255, 255, 0.7)',
    fontSize: 14,
    fontFamily: 'Poppins-Regular',
  },
  linkHighlight: {
    color: colors.secondary.white,
    fontWeight: '600',
    fontFamily: 'Poppins-SemiBold',
  },
  loadingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default SignIn;