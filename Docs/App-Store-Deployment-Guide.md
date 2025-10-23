# 📱 App Store Deployment Guide

## 🎯 **Deploy StoryDoku to Google Play Store & Apple App Store**

### **Android APK → Google Play Store**

#### **Step 1: Configure Android App**
```yaml
# android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.perfeasy.storydoku"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "0.0.1"
    }
}
```

#### **Step 2: Create App Icons**
```bash
# Generate app icons from 1024x1024 source
flutter packages pub run flutter_launcher_icons:main
```

#### **Step 3: Build Release APK**
```bash
# Build signed APK for Play Store
flutter build apk --release
flutter build appbundle --release  # For Play Store
```

#### **Step 4: Google Play Console Setup**
1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app: "StoryDoku - Classic Sudoku"
3. Upload APK/AAB file
4. Fill store listing details
5. Submit for review

---

### **iOS App → Apple App Store**

#### **Step 1: Configure iOS App**
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>StoryDoku</string>
<key>CFBundleIdentifier</key>
<string>com.perfeasy.storydoku</string>
<key>CFBundleVersion</key>
<string>0.0.1</string>
```

#### **Step 2: Build iOS App**
```bash
# Build iOS app (requires macOS)
flutter build ios --release
```

#### **Step 3: App Store Connect Setup**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app: "StoryDoku"
3. Upload build via Xcode
4. Fill app information
5. Submit for review

---

## 🛠 **Production Build Commands**

### **For Android:**
```bash
# 1. Build release APK
flutter build apk --release

# 2. Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# 3. Build with specific target
flutter build apk --target-platform android-arm64 --release
```

### **For iOS (requires macOS):**
```bash
# 1. Build iOS app
flutter build ios --release

# 2. Archive for App Store
flutter build ipa --release
```

---

## 📋 **App Store Requirements**

### **Google Play Store:**
- [ ] **App Bundle** (.aab file) - preferred over APK
- [ ] **App Icon**: 512x512 PNG
- [ ] **Feature Graphic**: 1024x500 PNG
- [ ] **Screenshots**: Phone (1080x1920), Tablet (1200x1920)
- [ ] **Privacy Policy**: Required for data collection
- [ ] **Content Rating**: Age-appropriate rating
- [ ] **Store Listing**: Description, keywords, category

### **Apple App Store:**
- [ ] **App Icon**: 1024x1024 PNG
- [ ] **Screenshots**: iPhone (6.7", 6.5", 5.5"), iPad (12.9", 11")
- [ ] **App Description**: Detailed description
- [ ] **Keywords**: Search optimization
- [ ] **Privacy Policy**: Required
- [ ] **Age Rating**: 4+ for puzzle games

---

## 🎨 **App Store Assets Needed**

### **Icons:**
- **App Icon**: 1024x1024 (iOS), 512x512 (Android)
- **Feature Graphic**: 1024x500 (Android)
- **Screenshots**: Multiple device sizes

### **Store Listing:**
- **App Name**: "StoryDoku - Classic Sudoku"
- **Short Description**: "Clean, fast Sudoku puzzle game"
- **Full Description**: Detailed features and benefits
- **Keywords**: "sudoku, puzzle, game, brain, logic"
- **Category**: Games > Puzzle

---

## 💰 **App Store Costs**

| Store | Developer Fee | Revenue Share |
|-------|---------------|---------------|
| **Google Play** | $25 (one-time) | 15% (first $1M), 30% (after) |
| **Apple App Store** | $99/year | 15% (first $1M), 30% (after) |

---

## 🚀 **Deployment Timeline**

### **Week 1: Preparation**
- [ ] Create developer accounts
- [ ] Design app icons and screenshots
- [ ] Write store descriptions
- [ ] Set up app signing

### **Week 2: Build & Test**
- [ ] Build release versions
- [ ] Test on real devices
- [ ] Fix any issues
- [ ] Prepare store assets

### **Week 3: Store Submission**
- [ ] Upload to Google Play Console
- [ ] Upload to App Store Connect
- [ ] Submit for review
- [ ] Wait for approval (1-7 days)

### **Week 4: Launch**
- [ ] App goes live
- [ ] Monitor downloads
- [ ] Respond to reviews
- [ ] Plan updates

---

## 🔧 **Quick Start Commands**

```bash
# 1. Build Android APK
flutter build apk --release

# 2. Build Android App Bundle (for Play Store)
flutter build appbundle --release

# 3. Check build output
ls build/app/outputs/flutter-apk/
ls build/app/outputs/bundle/release/
```

**Your app will be installable from Google Play Store and Apple App Store! 🎉**

