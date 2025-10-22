# 🚀 StoryDoku - Implementation Quick Start Guide

**Purpose:** Get from zero to first commit in 1 day  
**Target:** Developers ready to start building  
**Prerequisites:** Flutter & Firebase basics

---

## 📋 Pre-Development Checklist

### Day 0: Setup (2-3 hours)

- [ ] Install Flutter SDK 3.24+
- [ ] Install Android Studio or VS Code
- [ ] Install Xcode (macOS only)
- [ ] Install Git
- [ ] Install Firebase CLI: `npm install -g firebase-tools`
- [ ] Create Firebase account
- [ ] Create Google Play Console account ($25 one-time)
- [ ] Create Apple Developer account ($99/year)

---

## 🎯 Day 1: Project Initialization

### Step 1: Create Flutter Project (30 min)

```powershell
# Navigate to your workspace
cd D:\Jitin\PerfEasy\Perfeasy-Product\Research\Cursor\Suduko-V1

# Create Flutter project
flutter create storydoku

# Navigate to project
cd storydoku

# Test installation
flutter doctor
flutter run
```

### Step 2: Initialize Git (5 min)

```powershell
git init
git add .
git commit -m "Initial commit: Flutter project created"

# Optional: Create GitHub repo and push
git remote add origin <your-repo-url>
git push -u origin main
```

### Step 3: Setup Firebase (20 min)

#### 3.1 Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add project"
3. Project name: `StoryDoku`
4. Enable Google Analytics (recommended)
5. Create project

#### 3.2 Add Android App

1. Click "Add app" → Android
2. Package name: `com.storydoku.codebreakers`
3. Download `google-services.json`
4. Place in `android/app/`

#### 3.3 Add iOS App

1. Click "Add app" → iOS
2. Bundle ID: `com.storydoku.codebreakers`
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/` (drag in Xcode)

#### 3.4 Initialize FlutterFire

```powershell
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for project
flutterfire configure
```

### Step 4: Configure Dependencies (15 min)

Replace `pubspec.yaml` with:

```yaml
name: storydoku
description: A story-driven Sudoku adventure game
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.0
  injectable: ^2.3.2
  
  # Navigation
  auto_route: ^7.8.0
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_messaging: ^14.7.9
  firebase_storage: ^11.5.6
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # UI/UX
  google_fonts: ^6.1.0
  flutter_animate: ^4.3.0
  shimmer: ^3.0.0
  lottie: ^3.0.0
  cached_network_image: ^3.3.0
  
  # Utils
  intl: ^0.19.0
  uuid: ^4.2.1
  connectivity_plus: ^5.0.2
  device_info_plus: ^9.1.1
  path_provider: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  injectable_generator: ^2.4.1
  auto_route_generator: ^7.3.0
  hive_generator: ^2.0.1
  
  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.5
  
  # App Icons & Splash
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.7

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/images/backgrounds/
    - assets/images/characters/
    - assets/animations/
    - assets/audio/music/
    - assets/audio/sfx/
    - assets/stories/codebreakers/

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#0A0E1A"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"

flutter_native_splash:
  color: "#0A0E1A"
  image: assets/images/splash_logo.png
  android: true
  ios: true
```

Install dependencies:

```powershell
flutter pub get
```

### Step 5: Create Folder Structure (10 min)

```powershell
# Core folders
mkdir lib\core\config
mkdir lib\core\constants
mkdir lib\core\di
mkdir lib\core\error
mkdir lib\core\theme
mkdir lib\core\utils

# Feature folders
mkdir lib\features\auth\data\datasources
mkdir lib\features\auth\data\models
mkdir lib\features\auth\data\repositories
mkdir lib\features\auth\domain\entities
mkdir lib\features\auth\domain\repositories
mkdir lib\features\auth\domain\usecases
mkdir lib\features\auth\presentation\bloc
mkdir lib\features\auth\presentation\screens
mkdir lib\features\auth\presentation\widgets

mkdir lib\features\game\data\datasources
mkdir lib\features\game\data\models
mkdir lib\features\game\data\repositories
mkdir lib\features\game\data\services
mkdir lib\features\game\domain\entities
mkdir lib\features\game\domain\repositories
mkdir lib\features\game\domain\usecases
mkdir lib\features\game\presentation\bloc
mkdir lib\features\game\presentation\screens
mkdir lib\features\game\presentation\widgets

mkdir lib\features\story\data\datasources
mkdir lib\features\story\data\models
mkdir lib\features\story\data\repositories
mkdir lib\features\story\domain\entities
mkdir lib\features\story\domain\repositories
mkdir lib\features\story\domain\usecases
mkdir lib\features\story\presentation\bloc
mkdir lib\features\story\presentation\screens
mkdir lib\features\story\presentation\widgets

mkdir lib\features\home\presentation\screens
mkdir lib\features\home\presentation\widgets

mkdir lib\shared\widgets

# Asset folders
mkdir assets\images
mkdir assets\images\backgrounds
mkdir assets\images\characters
mkdir assets\animations
mkdir assets\audio\music
mkdir assets\audio\sfx
mkdir assets\stories\codebreakers

# Test folders
mkdir test\unit
mkdir test\widget
mkdir test\integration
```

---

## 🎨 Day 2: Core Setup

### Step 1: Create Theme (30 min)

Create `lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryCyan = Color(0x00F0FF);
  static const Color primaryPurple = Color(0xFFB026FF);
  static const Color backgroundDark = Color(0xFF0A0E1A);
  static const Color accentGreen = Color(0xFF00FF41);
  static const Color warningRed = Color(0xFFFF0040);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryCyan,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryCyan,
        secondary: primaryPurple,
        surface: surfaceDark,
        background: backgroundDark,
        error: warningRed,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.rajdhani(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCyan,
          foregroundColor: backgroundDark,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
```

### Step 2: Setup Dependency Injection (20 min)

Create `lib/core/di/injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Register services (we'll add more later)
  // getIt.registerLazySingleton(() => AuthService());
  // getIt.registerLazySingleton(() => PuzzleService());
}
```

### Step 3: Create Main App (15 min)

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // Setup dependencies
  await setupDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryDoku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'STORYDOKU',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 8),
            Text(
              'CODE BREAKERS',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.primaryCyan,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: AppTheme.primaryCyan,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 4: Configure Analysis Options (5 min)

Create `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - unnecessary_null_checks
```

---

## 🧩 Day 3: First Feature - Sudoku Generator

### Step 1: Create Puzzle Entity (15 min)

Create `lib/features/game/domain/entities/puzzle.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'puzzle.freezed.dart';

enum Difficulty { easy, medium, hard, expert }

@freezed
class Puzzle with _$Puzzle {
  const factory Puzzle({
    required String id,
    required List<List<int>> grid,
    required List<List<int>> solution,
    required Difficulty difficulty,
    required int clueCount,
  }) = _Puzzle;
}
```

Run code generation:

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Create Sudoku Generator (45 min)

Create `lib/features/game/data/services/sudoku_generator.dart`:

```dart
import 'dart:math';
import '../../domain/entities/puzzle.dart';

class SudokuGenerator {
  final Random _random = Random();
  
  /// Generate a Sudoku puzzle with specified difficulty
  Puzzle generate(Difficulty difficulty) {
    // Generate complete solution
    final solution = _generateSolution();
    
    // Create puzzle by removing numbers
    final grid = _createPuzzle(solution, difficulty);
    
    // Count clues
    int clueCount = 0;
    for (var row in grid) {
      clueCount += row.where((cell) => cell != 0).length;
    }
    
    return Puzzle(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      grid: grid,
      solution: solution,
      difficulty: difficulty,
      clueCount: clueCount,
    );
  }
  
  /// Generate complete valid Sudoku solution
  List<List<int>> _generateSolution() {
    List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid);
    return grid;
  }
  
  /// Fill grid using backtracking
  bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(_random);
          
          for (int num in numbers) {
            if (_isValid(grid, row, col, num)) {
              grid[row][col] = num;
              
              if (_fillGrid(grid)) {
                return true;
              }
              
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }
  
  /// Check if number can be placed at position
  bool _isValid(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
    }
    
    // Check column
    for (int x = 0; x < 9; x++) {
      if (grid[x][col] == num) return false;
    }
    
    // Check 3x3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[boxRow + i][boxCol + j] == num) return false;
      }
    }
    
    return true;
  }
  
  /// Create puzzle by removing numbers based on difficulty
  List<List<int>> _createPuzzle(List<List<int>> solution, Difficulty difficulty) {
    List<List<int>> grid = solution.map((row) => List<int>.from(row)).toList();
    
    int cellsToRemove = _getCellsToRemove(difficulty);
    int removed = 0;
    
    while (removed < cellsToRemove) {
      int row = _random.nextInt(9);
      int col = _random.nextInt(9);
      
      if (grid[row][col] != 0) {
        grid[row][col] = 0;
        removed++;
      }
    }
    
    return grid;
  }
  
  /// Get number of cells to remove based on difficulty
  int _getCellsToRemove(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 40 + _random.nextInt(5); // 40-44
      case Difficulty.medium:
        return 46 + _random.nextInt(5); // 46-50
      case Difficulty.hard:
        return 53 + _random.nextInt(4); // 53-56
      case Difficulty.expert:
        return 58 + _random.nextInt(4); // 58-61
    }
  }
}
```

### Step 3: Test Generator (15 min)

Create `test/unit/game/sudoku_generator_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storydoku/features/game/data/services/sudoku_generator.dart';
import 'package:storydoku/features/game/domain/entities/puzzle.dart';

void main() {
  late SudokuGenerator generator;

  setUp(() {
    generator = SudokuGenerator();
  });

  group('SudokuGenerator', () {
    test('generates easy puzzle with correct clue count', () {
      final puzzle = generator.generate(Difficulty.easy);
      
      expect(puzzle.clueCount, greaterThanOrEqualTo(40));
      expect(puzzle.clueCount, lessThanOrEqualTo(45));
    });

    test('generates valid solution', () {
      final puzzle = generator.generate(Difficulty.medium);
      
      // Check all rows have 1-9
      for (var row in puzzle.solution) {
        expect(row.toSet(), equals({1, 2, 3, 4, 5, 6, 7, 8, 9}));
      }
    });

    test('puzzle is subset of solution', () {
      final puzzle = generator.generate(Difficulty.hard);
      
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (puzzle.grid[i][j] != 0) {
            expect(puzzle.grid[i][j], equals(puzzle.solution[i][j]));
          }
        }
      }
    });
  });
}
```

Run tests:

```powershell
flutter test
```

---

## 📊 Progress Tracking

### What We've Built So Far

✅ Flutter project initialized  
✅ Firebase configured  
✅ Dependencies installed  
✅ Project structure created  
✅ Theme system setup  
✅ DI framework configured  
✅ Sudoku generator implemented  
✅ First unit tests passing

### What's Next (Week 1 Continued)

📋 Create game UI components  
📋 Implement game state management  
📋 Add local storage  
📋 Create home screen

---

## 🛠️ Development Commands Cheat Sheet

```powershell
# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (in running app)
r

# Hot restart (in running app)
R

# Run tests
flutter test

# Run specific test file
flutter test test/unit/game/sudoku_generator_test.dart

# Code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on save)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean project
flutter clean

# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Build APK (release)
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Check device status
flutter devices

# Doctor
flutter doctor -v
```

---

## 🐛 Common Issues & Solutions

### Issue: Firebase not initializing

**Solution:**
```dart
// Make sure Firebase.initializeApp() is called before runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### Issue: Code generation not working

**Solution:**
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Android build fails

**Solution:**
Check `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
    }
}
```

### Issue: iOS build fails

**Solution:**
```powershell
cd ios
pod install
cd ..
flutter clean
flutter run
```

---

## 📝 Daily Development Workflow

### Start of Day
1. Pull latest code: `git pull`
2. Check dependencies: `flutter pub get`
3. Run tests: `flutter test`
4. Start app: `flutter run`

### During Development
1. Write feature code
2. Write tests
3. Run tests frequently
4. Generate code if using Freezed/JSON: `build_runner build`
5. Format code: `flutter format lib/`

### End of Day
1. Run all tests: `flutter test`
2. Check for lint errors: `flutter analyze`
3. Commit changes: `git commit -m "Description"`
4. Push to remote: `git push`

---

## 📚 Essential Resources

### Documentation
- Flutter: https://docs.flutter.dev
- Firebase: https://firebase.google.com/docs
- BLoC: https://bloclibrary.dev

### Tutorials
- Flutter Codelabs: https://docs.flutter.dev/codelabs
- Firebase Flutter Setup: https://firebase.google.com/docs/flutter/setup

### Community
- Flutter Discord: https://discord.gg/flutter
- r/FlutterDev: https://reddit.com/r/FlutterDev
- Stack Overflow: Tag [flutter]

---

## ✅ Week 1 Completion Checklist

By end of Week 1, you should have:

- [ ] ✅ Flutter project setup complete
- [ ] ✅ Firebase integrated
- [ ] ✅ Dependencies configured
- [ ] ✅ Theme system implemented
- [ ] ✅ Folder structure created
- [ ] ✅ Sudoku generator working
- [ ] ✅ First tests passing
- [ ] ⏳ Game UI components started
- [ ] ⏳ BLoC setup initiated
- [ ] ⏳ Home screen design completed

---

## 🚀 Next Steps

1. **Complete Week 1 tasks** from 90-Day Development Plan
2. **Implement Game UI** (Week 1, Days 6-7)
3. **Start Story System** (Week 5)
4. **Integrate Firebase Auth** (Week 9)

---

## 💡 Pro Tips

1. **Commit Often**: Commit working code daily
2. **Test First**: Write tests before implementing complex logic
3. **Hot Reload**: Use `r` for fast iterations
4. **Debug Tools**: Use Flutter DevTools for debugging
5. **VSCode Extensions**: 
   - Flutter
   - Dart
   - Bloc
   - Error Lens
6. **Keep Dependencies Updated**: Run `flutter pub outdated` weekly

---

## 📞 Need Help?

**Architecture Questions:** Review `Architecture-Design.md`  
**Story Content:** Review `Codebreakers-Story-Design.md`  
**Timeline:** Review `90-Day-Development-Plan.md`  
**Technical Details:** Review `Technical-Specifications.md`

---

**🎉 Congratulations! You're ready to start building StoryDoku!**

*Remember: Progress over perfection. Ship the MVP, gather feedback, iterate.*

---

**Document Version:** 1.0  
**Last Updated:** October 22, 2025

