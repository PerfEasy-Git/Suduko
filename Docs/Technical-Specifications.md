# ⚙️ StoryDoku - Technical Specifications

**Version:** 1.0  
**Project:** StoryDoku Mobile App  
**Platform:** Flutter (iOS + Android)  
**Last Updated:** October 22, 2025

---

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Application Specifications](#application-specifications)
3. [Sudoku Engine Specifications](#sudoku-engine-specifications)
4. [Story Engine Specifications](#story-engine-specifications)
5. [Data Storage Specifications](#data-storage-specifications)
6. [API & Services](#api--services)
7. [Performance Requirements](#performance-requirements)
8. [Security Specifications](#security-specifications)
9. [Testing Requirements](#testing-requirements)

---

## 1. System Requirements

### 1.1 Development Environment

| Component | Specification |
|-----------|---------------|
| **Flutter SDK** | 3.24.0 or higher |
| **Dart SDK** | 3.5.0 or higher |
| **Android Studio** | 2023.1 (Hedgehog) or higher |
| **Xcode** | 15.0 or higher (macOS only) |
| **Git** | 2.30 or higher |
| **Firebase CLI** | 12.0 or higher |

### 1.2 Target Devices

#### Android
| Specification | Minimum | Recommended |
|--------------|---------|-------------|
| **OS Version** | Android 7.0 (API 24) | Android 12+ (API 31+) |
| **RAM** | 2 GB | 4 GB+ |
| **Storage** | 100 MB free | 500 MB free |
| **Screen Resolution** | 720x1280 (HD) | 1080x1920 (FHD+) |
| **Screen Size** | 4.5" | 5.5"+ |

#### iOS
| Specification | Minimum | Recommended |
|--------------|---------|-------------|
| **OS Version** | iOS 13.0 | iOS 16.0+ |
| **Devices** | iPhone 7, iPad (5th gen) | iPhone 12+, iPad Pro |
| **RAM** | 2 GB | 4 GB+ |
| **Storage** | 100 MB free | 500 MB free |
| **Screen Size** | 4.7" (iPhone SE) | 6.1"+ |

### 1.3 Target User Base (MVP)

- **Target Users (3 months):** 1,000 users
- **Peak Concurrent Users:** 100
- **Daily Active Users (DAU):** 200-300
- **Monthly Active Users (MAU):** 500-800

---

## 2. Application Specifications

### 2.1 App Information

| Property | Value |
|----------|-------|
| **App Name** | StoryDoku: Code Breakers |
| **Bundle ID (iOS)** | com.storydoku.codebreakers |
| **Package Name (Android)** | com.storydoku.codebreakers |
| **Version** | 1.0.0 (MVP) |
| **Build Number** | 1 |

### 2.2 App Size

| Platform | Target Size | Maximum Size |
|----------|------------|--------------|
| **Android (APK)** | 30-40 MB | 50 MB |
| **Android (AAB)** | 25-35 MB | 45 MB |
| **iOS (IPA)** | 35-45 MB | 60 MB |

### 2.3 Supported Orientations

- **Primary:** Portrait
- **Secondary:** Portrait (upside down) - disabled
- **Landscape:** Disabled (future consideration for tablets)

### 2.4 Supported Languages (MVP)

- **Initial:** English (US)
- **Future:** Spanish, French, German, Japanese, Chinese

### 2.5 App Permissions

#### Android
```xml
<!-- Required -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- Optional -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

#### iOS (Info.plist)
```xml
<!-- Required -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>

<!-- Optional -->
<key>NSUserNotificationsUsageDescription</key>
<string>Enable notifications to receive daily puzzle reminders</string>
```

---

## 3. Sudoku Engine Specifications

### 3.1 Puzzle Generation

#### Algorithm: Backtracking with Optimization

**Generation Steps:**
1. Create complete valid solution grid
2. Remove numbers based on difficulty
3. Validate unique solution
4. Apply symmetry pattern
5. Validate puzzle quality

#### Performance Requirements

| Operation | Maximum Time |
|-----------|-------------|
| **Generate Easy Puzzle** | 100ms |
| **Generate Medium Puzzle** | 250ms |
| **Generate Hard Puzzle** | 500ms |
| **Generate Expert Puzzle** | 1000ms |
| **Validate Solution** | 10ms |
| **Solve Puzzle (hint)** | 100ms |

#### Difficulty Specifications

| Difficulty | Clues | Empty Cells | Techniques Required |
|-----------|-------|-------------|---------------------|
| **Easy** | 40-45 | 36-41 | Naked Singles, Hidden Singles |
| **Medium** | 30-35 | 46-51 | + Naked Pairs, Pointing Pairs |
| **Hard** | 24-28 | 53-57 | + Hidden Pairs, Box/Line Reduction |
| **Expert** | 20-23 | 58-61 | + X-Wing, Swordfish, Chains |

### 3.2 Puzzle Validation

#### Validation Rules

```dart
class ValidationRules {
  // No duplicate in row
  static bool validateRow(List<int> row);
  
  // No duplicate in column
  static bool validateColumn(List<int> column);
  
  // No duplicate in 3x3 box
  static bool validateBox(List<int> box);
  
  // Complete puzzle validation
  static bool validateComplete(List<List<int>> grid);
  
  // Puzzle has unique solution
  static bool hasUniqueSolution(List<List<int>> puzzle);
}
```

### 3.3 Hint System Specifications

| Hint Type | Description | Cost (Future) |
|-----------|-------------|---------------|
| **Show Candidates** | Display possible numbers for selected cell | Free |
| **Highlight Conflicts** | Show incorrect entries | Free |
| **Reveal Cell** | Fill one cell with correct number | 1 hint credit |
| **Show Technique** | Explain next logical step | 2 hint credits |
| **Auto-Fill** | Fill all remaining cells | 5 hint credits |

**Hint Regeneration:** 1 hint per hour (max 3 stored)

### 3.4 Game State Tracking

```dart
class GameState {
  // Puzzle metadata
  String puzzleId;
  Difficulty difficulty;
  DateTime startTime;
  
  // Current state
  List<List<Cell>> currentGrid;
  int elapsedSeconds;
  int mistakeCount;
  bool notesMode;
  
  // History
  List<Move> moveHistory;
  int hintsUsed;
  
  // Completion
  bool isCompleted;
  DateTime? completedAt;
  int finalScore;
}
```

### 3.5 Scoring System

```dart
int calculateScore({
  required int elapsedSeconds,
  required Difficulty difficulty,
  required int mistakeCount,
  required int hintsUsed,
}) {
  int baseScore = difficultyMultiplier[difficulty] * 1000;
  int timeBonus = max(0, 3600 - elapsedSeconds); // up to 1 hour
  int mistakePenalty = mistakeCount * 50;
  int hintPenalty = hintsUsed * 100;
  
  return max(0, baseScore + timeBonus - mistakePenalty - hintPenalty);
}
```

**Difficulty Multipliers:**
- Easy: 1x
- Medium: 2x
- Hard: 3x
- Expert: 5x

---

## 4. Story Engine Specifications

### 4.1 Story Data Format

#### JSON Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["chapterId", "chapterTitle", "scenes"],
  "properties": {
    "chapterId": {"type": "string"},
    "chapterTitle": {"type": "string"},
    "description": {"type": "string"},
    "theme": {"type": "string", "enum": ["codebreakers", "detective", "zen"]},
    "order": {"type": "integer"},
    "unlockCondition": {
      "type": "object",
      "properties": {
        "type": {"type": "string"},
        "value": {"type": ["string", "number", "null"]}
      }
    },
    "scenes": {
      "type": "array",
      "items": {"$ref": "#/definitions/scene"}
    }
  }
}
```

### 4.2 Scene Types

| Type | Description | Contains |
|------|-------------|----------|
| **narrative** | Story-only scene | Dialogues, choices |
| **puzzle** | Puzzle with story wrapper | Puzzle config, intro/outro dialogue |
| **choice** | Decision point | Multiple choice options |
| **memory** | Flashback/memory fragment | Special visual treatment |
| **ending** | Chapter conclusion | Summary, teaser |

### 4.3 Dialogue System

#### Typewriter Effect Specifications

```dart
class TypewriterConfig {
  static const int charsPerSecond = 30;
  static const Duration minCharDelay = Duration(milliseconds: 20);
  static const Duration maxCharDelay = Duration(milliseconds: 50);
  static const Duration punctuationDelay = Duration(milliseconds: 200);
  
  // Skip animation after X seconds
  static const Duration autoSkipAfter = Duration(seconds: 10);
}
```

#### Character Display

```dart
class Character {
  String id;
  String name;
  String spriteUrl;
  CharacterPosition position; // left, center, right
  CharacterEmotion emotion; // neutral, happy, sad, angry, surprised
  double opacity; // 0.0 to 1.0
  bool isVisible;
}
```

### 4.4 Story Progression Logic

```dart
class StoryProgression {
  // Check if scene is unlocked
  bool canUnlockScene(String sceneId, UserProgress progress) {
    Scene scene = getScene(sceneId);
    return scene.unlockCondition.validate(progress);
  }
  
  // Get next scene based on current state
  Scene? getNextScene(String currentSceneId, String? choiceId) {
    if (choiceId != null) {
      return scenes[choiceId];
    }
    return getSequentialNext(currentSceneId);
  }
  
  // Calculate chapter completion
  double getChapterCompletion(String chapterId) {
    int totalScenes = getChapter(chapterId).scenes.length;
    int viewedScenes = getUserProgress().viewedScenes.length;
    return viewedScenes / totalScenes;
  }
}
```

### 4.5 Asset Loading

#### Image Loading Strategy

```dart
class AssetLoader {
  // Preload next 2 scenes
  static const int preloadSceneCount = 2;
  
  // Cache size (images)
  static const int maxCachedImages = 10;
  static const int maxCacheMemoryMB = 50;
  
  // Image quality
  static const ImageQuality quality = ImageQuality.high;
  static const int maxWidth = 1920;
  static const int maxHeight = 1080;
}
```

---

## 5. Data Storage Specifications

### 5.1 Local Storage (Hive)

#### Boxes (Tables)

| Box Name | Type | Purpose | Max Size |
|----------|------|---------|----------|
| **user_box** | User | Current user data | 1 record |
| **game_states_box** | GameState | Active game states | 5 records |
| **progress_box** | UserProgress | User progress data | 1 record |
| **puzzles_box** | Puzzle | Cached puzzles | 50 records |
| **stories_box** | Chapter | Cached stories | 10 records |
| **settings_box** | Settings | App settings | 1 record |
| **achievements_box** | Achievement | Unlocked achievements | 100 records |

#### Data Size Estimates

| Data Type | Size per Record | Max Records | Total Size |
|-----------|----------------|-------------|------------|
| User | 5 KB | 1 | 5 KB |
| GameState | 10 KB | 5 | 50 KB |
| Puzzle | 2 KB | 50 | 100 KB |
| Chapter | 50 KB | 10 | 500 KB |
| **Total Local** | | | **~655 KB** |

### 5.2 Cloud Storage (Firestore)

#### Collection Structure

```
users/ (collection)
  {userId}/ (document)
    - email: string
    - displayName: string
    - createdAt: timestamp
    - stats: map
    
    gameStates/ (subcollection)
      {gameId}/ (document)
        - puzzleId: string
        - currentGrid: array
        - elapsedTime: number
        - isCompleted: boolean
    
    storyProgress/ (subcollection)
      {chapterId}/ (document)
        - viewedScenes: array
        - choices: map
        - completionPercent: number
    
    achievements/ (subcollection)
      {achievementId}/ (document)
        - unlockedAt: timestamp

dailyChallenges/ (collection)
  {date}/ (document)
    - puzzleId: string
    - difficulty: string
    - completedCount: number
    
puzzles/ (collection)
  {puzzleId}/ (document)
    - grid: array
    - solution: array
    - difficulty: string
```

#### Firestore Quotas (Free Tier)

| Resource | Free Tier Limit | Projected Usage |
|----------|----------------|-----------------|
| **Reads/day** | 50,000 | 10,000 |
| **Writes/day** | 20,000 | 5,000 |
| **Deletes/day** | 20,000 | 500 |
| **Storage** | 1 GB | 100 MB |
| **Bandwidth** | 10 GB/month | 2 GB/month |

### 5.3 Cloud Storage (Firebase Storage)

#### Directory Structure

```
stories/
  codebreakers/
    chapter_1/
      backgrounds/
        scene_1.jpg (200KB)
        scene_2.jpg (200KB)
      characters/
        echo.png (50KB)
        dr_chen.png (50KB)
      audio/
        ambient.mp3 (2MB)

user_uploads/ (future)
  {userId}/
    avatar.jpg (100KB)
```

#### Storage Quotas

| Resource | Free Tier | Projected |
|----------|-----------|-----------|
| **Storage** | 5 GB | 500 MB |
| **Downloads** | 1 GB/day | 100 MB/day |
| **Uploads** | 1 GB/day | 10 MB/day |

---

## 6. API & Services

### 6.1 Firebase Services

#### Authentication

```dart
class FirebaseAuthService {
  // Email/Password
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> registerWithEmail(String email, String password);
  
  // Social Auth
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
  
  // Anonymous
  Future<UserCredential> signInAnonymously();
  
  // Account Management
  Future<void> resetPassword(String email);
  Future<void> linkAnonymousAccount(String email, String password);
}
```

#### Cloud Functions (Future)

```javascript
// Generate daily puzzle (scheduled)
exports.generateDailyPuzzle = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    // Generate puzzle
    // Store in Firestore
  });

// Update leaderboard (triggered)
exports.updateLeaderboard = functions.firestore
  .document('users/{userId}/gameStates/{gameId}')
  .onUpdate(async (change, context) => {
    // Calculate rankings
    // Update leaderboard collection
  });
```

### 6.2 Analytics Events

#### Event Specifications

| Event Name | Parameters | Trigger |
|------------|-----------|---------|
| **app_open** | - | App launch |
| **user_signup** | method (email/google/apple) | Account created |
| **puzzle_started** | difficulty, chapter_id | Puzzle begins |
| **puzzle_completed** | difficulty, time, mistakes, score | Puzzle solved |
| **puzzle_abandoned** | difficulty, elapsed_time, progress | Puzzle quit |
| **hint_used** | hint_type, difficulty | Hint button pressed |
| **scene_viewed** | chapter_id, scene_id | Story scene shown |
| **choice_made** | scene_id, choice_id | Story choice selected |
| **achievement_unlocked** | achievement_id | Achievement earned |
| **daily_challenge_started** | date | Daily puzzle started |
| **daily_challenge_completed** | date, time, score | Daily puzzle done |

---

## 7. Performance Requirements

### 7.1 App Performance

| Metric | Target | Maximum |
|--------|--------|---------|
| **Cold Start Time** | < 2s | < 3s |
| **Hot Start Time** | < 0.5s | < 1s |
| **Frame Rate** | 60 FPS | 45 FPS minimum |
| **Memory Usage** | < 150 MB | < 250 MB |
| **Battery Usage** | < 5% per hour | < 10% per hour |

### 7.2 Network Performance

| Operation | Target | Timeout |
|-----------|--------|---------|
| **User Login** | < 1s | 5s |
| **Puzzle Load** | < 500ms | 2s |
| **Story Scene Load** | < 1s | 3s |
| **Progress Sync** | < 2s | 5s |
| **Image Download** | < 3s | 10s |

### 7.3 Offline Capabilities

| Feature | Offline Support | Sync Required |
|---------|----------------|---------------|
| **Puzzle Generation** | ✅ Full | No |
| **Classic Mode** | ✅ Full | No |
| **Story Mode** | ✅ If cached | Yes |
| **Progress Tracking** | ✅ Local save | Yes (auto-sync when online) |
| **Daily Challenge** | ❌ Requires network | Yes |
| **Achievements** | ✅ Local unlock | Yes (sync later) |

---

## 8. Security Specifications

### 8.1 Data Encryption

| Data Type | At Rest | In Transit |
|-----------|---------|------------|
| **User Credentials** | ✅ Hashed (bcrypt) | ✅ HTTPS/TLS 1.3 |
| **User Data** | ✅ Encrypted (AES-256) | ✅ HTTPS/TLS 1.3 |
| **Game States** | ✅ Encrypted | ✅ HTTPS/TLS 1.3 |
| **Story Content** | ❌ Public | ✅ HTTPS/TLS 1.3 |

### 8.2 Authentication Security

```dart
class SecurityConfig {
  // Password requirements
  static const int minPasswordLength = 8;
  static const bool requireUppercase = true;
  static const bool requireLowercase = true;
  static const bool requireNumber = true;
  static const bool requireSpecialChar = false;
  
  // Session management
  static const Duration sessionTimeout = Duration(days: 30);
  static const bool persistLogin = true;
  
  // Rate limiting
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
}
```

### 8.3 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // User data - owner only
    match /users/{userId} {
      allow read, write: if isOwner(userId);
      
      match /gameStates/{gameId} {
        allow read, write: if isOwner(userId);
      }
      
      match /storyProgress/{chapterId} {
        allow read, write: if isOwner(userId);
      }
    }
    
    // Puzzles - read-only for authenticated
    match /puzzles/{puzzleId} {
      allow read: if isAuthenticated();
      allow write: if false; // Cloud Functions only
    }
    
    // Daily challenges - read-only
    match /dailyChallenges/{date} {
      allow read: if isAuthenticated();
      allow write: if false;
    }
  }
}
```

### 8.4 API Security

```dart
class APIConfig {
  // API endpoints (Cloud Functions)
  static const String baseUrl = 'https://us-central1-storydoku.cloudfunctions.net';
  
  // Rate limiting
  static const int maxRequestsPerMinute = 60;
  
  // Timeout
  static const Duration requestTimeout = Duration(seconds: 10);
  
  // Retry policy
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
```

---

## 9. Testing Requirements

### 9.1 Test Coverage Targets

| Layer | Coverage Target | Critical Paths |
|-------|----------------|----------------|
| **Domain Layer** | 95% | Use cases, entities |
| **Data Layer** | 85% | Repositories, data sources |
| **Presentation Layer** | 80% | BLoCs |
| **UI Layer** | 60% | Widgets |
| **Overall** | 80% | All code |

### 9.2 Test Types

#### Unit Tests
```dart
// Test Sudoku generator
test('Generate valid easy puzzle', () {
  final puzzle = SudokuGenerator().generate(Difficulty.easy);
  expect(puzzle.clueCount, inRange(40, 45));
  expect(SudokuValidator().hasUniqueSolution(puzzle), true);
});

// Test BLoC
blocTest<GameBloc, GameState>(
  'Emits playing state when puzzle started',
  build: () => GameBloc(generatePuzzle),
  act: (bloc) => bloc.add(GameEvent.started(Difficulty.easy)),
  expect: () => [
    GameState.loading(),
    isA<GameStatePlaying>(),
  ],
);
```

#### Widget Tests
```dart
testWidgets('Number pad shows numbers 1-9', (tester) async {
  await tester.pumpWidget(MaterialApp(home: NumberPad()));
  
  for (int i = 1; i <= 9; i++) {
    expect(find.text('$i'), findsOneWidget);
  }
});
```

#### Integration Tests
```dart
testWidgets('Complete game flow', (tester) async {
  // Start app
  await tester.pumpWidget(MyApp());
  
  // Navigate to game
  await tester.tap(find.text('Classic Mode'));
  await tester.pumpAndSettle();
  
  // Select difficulty
  await tester.tap(find.text('Easy'));
  await tester.pumpAndSettle();
  
  // Verify game screen
  expect(find.byType(SudokuGrid), findsOneWidget);
});
```

### 9.3 Performance Testing

```dart
void main() {
  test('Puzzle generation performance', () {
    final stopwatch = Stopwatch()..start();
    final puzzle = SudokuGenerator().generate(Difficulty.easy);
    stopwatch.stop();
    
    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  });
}
```

---

## 10. Deployment Specifications

### 10.1 Build Configurations

#### Android

```gradle
// build.gradle (app level)
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.storydoku.codebreakers"
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            shrinkResources true
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
        }
        debug {
            debuggable true
            applicationIdSuffix ".debug"
        }
    }
}
```

#### iOS

```
Build Configuration: Release
Optimization Level: -Os (Optimize for Size)
Enable Bitcode: No
Strip Debug Symbols: Yes
```

### 10.2 Environment Variables

```dart
enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  static Environment current = Environment.production;
  
  static String get firebaseProjectId {
    switch (current) {
      case Environment.development:
        return 'storydoku-dev';
      case Environment.staging:
        return 'storydoku-staging';
      case Environment.production:
        return 'storydoku-prod';
    }
  }
}
```

---

## 11. Monitoring & Analytics

### 11.1 Key Metrics to Track

| Metric | Tool | Alert Threshold |
|--------|------|-----------------|
| **Crash Rate** | Crashlytics | > 1% |
| **ANR Rate** | Crashlytics | > 0.5% |
| **API Success Rate** | Analytics | < 95% |
| **Average Session Length** | Analytics | < 5 minutes |
| **Day 1 Retention** | Analytics | < 40% |
| **Day 7 Retention** | Analytics | < 20% |

### 11.2 Custom Dashboards

```
Firebase Console Dashboards:
- User Engagement (DAU, MAU, Session length)
- Puzzle Performance (Completion rate by difficulty)
- Story Engagement (Scenes viewed, Choices made)
- Technical Health (Crash rate, Performance)
- Monetization (Future: IAP conversion)
```

---

## 12. Future Enhancements

### 12.1 Planned Features (Post-MVP)

| Feature | Priority | Estimated Effort |
|---------|----------|------------------|
| **Leaderboards** | High | 2 weeks |
| **Social Sharing** | Medium | 1 week |
| **Additional Themes** | High | 4 weeks each |
| **Multiplayer Mode** | Low | 8 weeks |
| **Puzzle Creator** | Medium | 6 weeks |
| **Premium Content** | High | 3 weeks |

---

## ✅ Specification Checklist

Before development begins, ensure:
- [ ] All technical specs reviewed and approved
- [ ] Firebase project created with correct settings
- [ ] Development environment setup complete
- [ ] Team has access to necessary tools
- [ ] Design assets specifications finalized
- [ ] Testing strategy approved
- [ ] Security requirements understood
- [ ] Performance targets documented

---

**Document Version History:**
- v1.0 (Oct 22, 2025) - Initial specifications for MVP

**Last Review Date:** October 22, 2025  
**Next Review Date:** After MVP launch

