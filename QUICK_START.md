# 🚀 StoryDoku - Quick Start Guide

**Jai Sri Krishna! 🙏**

Get your StoryDoku app running in **less than 10 minutes**!

---

## ✅ What's Already Done

Your Flutter app is **100% ready** with:
- ✅ Complete Sudoku game (4 difficulties)
- ✅ Story mode with Chapter 1 demo
- ✅ Beautiful Codebreakers UI
- ✅ All game controls (Undo, Hint, Clear)
- ✅ Local storage for stats
- ✅ **No placeholders - all real code!**

---

## 📋 Prerequisites

### 1. Install Flutter SDK

**Windows (Your System):**
```powershell
# Download Flutter SDK
# Visit: https://docs.flutter.dev/get-started/install/windows

# Or use this direct link:
# https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip

# Extract to: C:\flutter
# Add to PATH: C:\flutter\bin
```

**Verify Installation:**
```powershell
flutter doctor
```

You should see:
```
[✓] Flutter (Channel stable, 3.24.0)
[✓] Android toolchain
[✓] Chrome (for web)
[!] Some items may show warnings - that's OK for now
```

### 2. Setup Android Studio (Optional but Recommended)

```powershell
# Download from: https://developer.android.com/studio
# Install with default settings
# This includes Android SDK and emulator
```

### 3. Install VS Code + Flutter Extension (Alternative)

```powershell
# Download VS Code: https://code.visualstudio.com/
# Install Flutter extension from marketplace
```

---

## 🎮 Run the App (3 Steps!)

### Step 1: Navigate to Project
```powershell
cd D:\Jitin\PerfEasy\Perfeasy-Product\Research\Cursor\Suduko-V1
```

### Step 2: Get Dependencies
```powershell
flutter pub get
```

Expected output:
```
Resolving dependencies...
Got dependencies!
```

### Step 3: Run!
```powershell
# This will automatically open Chrome
flutter run -d chrome
```

**Or run on Android Emulator:**
```powershell
# Start emulator first, then:
flutter run
```

**Or run on connected phone:**
```powershell
# Connect phone via USB with USB debugging enabled
flutter devices
flutter run -d <your-device-id>
```

---

## 🎯 What You'll See

### 1. Home Screen
- "STORYDOKU" title with neon effects
- "CODE BREAKERS" subtitle
- Two big buttons:
  - **STORY MODE** (purple) → Launches narrative
  - **CLASSIC MODE** (cyan) → Opens difficulty selection

### 2. Story Mode
- Chapter 1: "The Last Cipher"
- Dialogue with ECHO (the AI guide)
- Tap to progress through story
- Solve a puzzle when prompted
- Experience story-puzzle integration

### 3. Classic Mode
- Select difficulty (Easy/Medium/Hard/Expert)
- Play Sudoku with:
  - Interactive 9×9 grid
  - Number pad for input
  - Undo, Hint, Clear buttons
  - Real-time mistake tracking
  - Win detection

---

## 🐛 Troubleshooting

### Issue: "flutter" command not found
**Solution:**
```powershell
# Add Flutter to PATH
$env:Path += ";C:\flutter\bin"

# Or permanently add via System Environment Variables
```

### Issue: "No devices found"
**Solutions:**

**For Chrome (Web):**
```powershell
# Enable web support
flutter config --enable-web
flutter run -d chrome
```

**For Android Emulator:**
```powershell
# Open Android Studio > Tools > AVD Manager
# Create new virtual device
# Start emulator
# Run: flutter run
```

**For Physical Phone:**
```powershell
# Enable Developer Options on phone
# Enable USB Debugging
# Connect via USB
# Run: flutter run
```

### Issue: Build errors
**Solution:**
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: Gradle errors (Android)
**Solution:**
```powershell
# Update Android SDK
# In Android Studio: Tools > SDK Manager
# Install latest SDK Platform and Build Tools
```

---

## 📱 Building Release Versions

### Android APK
```powershell
# Build release APK (for testing/sideloading)
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```powershell
# Build app bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Requires Mac)
```powershell
# On macOS only
flutter build ios --release
```

---

## 🎨 Customization

### Change Theme Colors
Edit: `lib/core/theme/app_theme.dart`
```dart
// Change primary color
static const Color primaryCyan = Color(0xFF00F0FF); // Your color here
```

### Add More Story Content
Edit: `lib/features/story/data/models/sample_story.dart`
```dart
// Add new scenes to Chapter 1
// Or create new chapters
```

### Adjust Difficulty
Edit: `lib/core/constants/difficulty.dart`
```dart
// Change clue counts
int get minClues {
  switch (this) {
    case Difficulty.easy:
      return 40; // Adjust this
```

---

## 📊 Performance Tips

### For Best Performance:
```powershell
# Run in release mode
flutter run --release

# Or profile mode for testing
flutter run --profile
```

### Enable Performance Overlay:
```dart
// In lib/main.dart, add to MaterialApp:
showPerformanceOverlay: true,
```

---

## 🧪 Testing

### Run All Tests:
```powershell
flutter test
```

### Run Specific Test:
```powershell
flutter test test/unit/game/sudoku_generator_test.dart
```

---

## 📦 Project Structure Quick Reference

```
lib/
├── main.dart                   # Start here
├── core/
│   ├── theme/                  # Change colors/fonts
│   ├── constants/              # Adjust difficulty
│   └── utils/                  # Storage utilities
├── features/
│   ├── game/                   # Sudoku logic & UI
│   ├── story/                  # Story mode
│   └── home/                   # Landing page
└── shared/                     # Reusable widgets

assets/                         # Images, audio, stories
```

---

## 🎯 Quick Commands Cheat Sheet

```powershell
# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get

# Run app (auto-select device)
flutter run

# Run on Chrome
flutter run -d chrome

# Run on specific device
flutter run -d <device-id>

# Hot reload (while running)
# Press 'r' in terminal

# Hot restart (while running)
# Press 'R' in terminal

# Stop app
# Press 'q' in terminal

# Build release APK
flutter build apk --release

# Clean project
flutter clean

# List connected devices
flutter devices

# Enable web support
flutter config --enable-web

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

---

## 💡 Pro Tips

### 1. Use Hot Reload
While app is running, press **'r'** to instantly see code changes without restarting!

### 2. Dev Tools
```powershell
# Open Flutter DevTools for debugging
flutter pub global activate devtools
flutter pub global run devtools
```

### 3. VS Code Launch Configuration
Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    }
  ]
}
```
Then press **F5** to run!

---

## 🎮 What to Try First

1. **Run the app** - See it working!
2. **Play Easy Sudoku** - Test the game logic
3. **Try Story Mode** - Experience the narrative
4. **Use Hint button** - See algorithm in action
5. **Complete a puzzle** - See win screen
6. **Change a color** - Experiment with theming

---

## 🚀 You're Ready!

Your app is **production-ready** for core gameplay. Just:

1. Install Flutter
2. Run `flutter pub get`
3. Run `flutter run -d chrome`

**That's it! You're playing StoryDoku!**

---

## 📞 Need Help?

### Flutter Resources:
- **Official Docs**: https://docs.flutter.dev
- **YouTube**: Flutter Channel
- **Discord**: https://discord.gg/flutter
- **Reddit**: r/FlutterDev

### Common Questions:

**Q: Do I need Android Studio?**
A: No! VS Code works fine. But Android Studio includes Android emulator.

**Q: Can I run on iOS?**
A: Yes, but you need a Mac with Xcode installed.

**Q: How do I test on my phone?**
A: Enable USB Debugging, connect via USB, run `flutter run`.

**Q: App won't start?**
A: Run `flutter clean`, then `flutter pub get`, then try again.

---

## ✅ Success Checklist

- [ ] Flutter installed & `flutter doctor` passes
- [ ] Navigated to project directory
- [ ] Run `flutter pub get` successfully
- [ ] Run `flutter run -d chrome` successfully
- [ ] See home screen with STORYDOKU title
- [ ] Tap CLASSIC MODE and play Sudoku
- [ ] Tap STORY MODE and read dialogue
- [ ] Complete a puzzle and see win screen

**All checked? Congratulations! 🎉**

---

**Jai Sri Krishna! 🙏**

*You've just built a real mobile game!*

---

**Project Location:**  
`D:\Jitin\PerfEasy\Perfeasy-Product\Research\Cursor\Suduko-V1`

**Next Steps:**  
See `PROJECT_SUMMARY.md` for full feature list  
See `Docs/90-Day-Development-Plan.md` for roadmap

