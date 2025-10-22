# 🏗️ StoryDoku - Technical Architecture Design

**Version:** v1.0  
**Project:** StoryDoku (Codebreakers Edition)  
**Platform:** Flutter (iOS + Android)  
**Backend:** Firebase  
**Prepared:** October 22, 2025

---

## 📋 Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Layers](#architecture-layers)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Core Components](#core-components)
6. [Data Models](#data-models)
7. [State Management](#state-management)
8. [Firebase Integration](#firebase-integration)
9. [Story Engine Design](#story-engine-design)
10. [Security & Performance](#security--performance)

---

## 1. System Overview

### 1.1 Architecture Pattern
**Clean Architecture with BLoC Pattern**

```
┌─────────────────────────────────────────────────────┐
│                 Presentation Layer                   │
│  (UI Widgets, Screens, BLoC/State Management)       │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│                  Domain Layer                        │
│     (Business Logic, Use Cases, Entities)           │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│                   Data Layer                         │
│  (Repositories, Data Sources, Models, Services)     │
└─────────────────────────────────────────────────────┘
                         ↓
┌──────────────────┬──────────────────┬───────────────┐
│  Local Storage   │    Firebase      │  Story Files  │
│     (Hive)       │  (Auth, Cloud)   │    (JSON)     │
└──────────────────┴──────────────────┴───────────────┘
```

### 1.2 Key Principles
- **Separation of Concerns**: Each layer has distinct responsibilities
- **Dependency Inversion**: High-level modules don't depend on low-level ones
- **Testability**: Easy unit and integration testing
- **Scalability**: Modular design for feature expansion
- **Offline-First**: Local storage with cloud sync

---

## 2. Architecture Layers

### 2.1 Presentation Layer
**Responsibilities:**
- UI rendering and user interactions
- State management (BLoC)
- Navigation and routing
- Input validation and formatting

**Components:**
- Screens (Home, Game, Story, Profile)
- Widgets (Sudoku Grid, Story Viewer, Progress Bar)
- BLoCs (Game BLoC, Story BLoC, User BLoC)
- Theme and styling

### 2.2 Domain Layer
**Responsibilities:**
- Core business logic
- Use case implementations
- Entity definitions
- Repository interfaces

**Components:**
- Entities (User, Puzzle, Chapter, Progress)
- Use Cases (Solve Puzzle, Load Story, Save Progress)
- Repository Interfaces
- Value Objects

### 2.3 Data Layer
**Responsibilities:**
- Data persistence and retrieval
- API communication
- Caching strategies
- Data transformation

**Components:**
- Repository Implementations
- Data Sources (Local, Remote)
- Data Models
- Services (Sudoku Generator, Story Parser)

---

## 3. Technology Stack

### 3.1 Frontend
```yaml
Flutter SDK: 3.24+
Dart: 3.5+

Core Packages:
  - flutter_bloc: ^8.1.3           # State management
  - equatable: ^2.0.5              # Value comparison
  - get_it: ^7.6.0                 # Dependency injection
  - auto_route: ^7.8.0             # Navigation
  - freezed: ^2.4.5                # Code generation
  - json_annotation: ^4.8.1        # JSON serialization

UI/UX:
  - google_fonts: ^6.1.0           # Typography
  - flutter_animate: ^4.3.0        # Animations
  - shimmer: ^3.0.0                # Loading states
  - lottie: ^3.0.0                 # Complex animations

Storage:
  - hive: ^2.2.3                   # Local database
  - hive_flutter: ^1.1.0
  - shared_preferences: ^2.2.2     # Simple key-value

Firebase:
  - firebase_core: ^2.24.2
  - firebase_auth: ^4.15.3
  - cloud_firestore: ^4.13.6
  - firebase_analytics: ^10.7.4
  - firebase_crashlytics: ^3.4.8
  - firebase_messaging: ^14.7.9    # Push notifications
  - firebase_storage: ^11.5.6

Utils:
  - intl: ^0.19.0                  # Internationalization
  - uuid: ^4.2.1                   # Unique IDs
  - connectivity_plus: ^5.0.2      # Network status
  - device_info_plus: ^9.1.1       # Device info
```

### 3.2 Backend
```yaml
Firebase Services:
  - Authentication (Email, Google, Apple, Guest)
  - Cloud Firestore (User data, progress, leaderboards)
  - Cloud Storage (Story assets, images, audio)
  - Cloud Functions (Server-side logic, scheduled tasks)
  - Analytics (User behavior, retention metrics)
  - Crashlytics (Error tracking)
  - Performance Monitoring
  - Remote Config (Feature flags, A/B testing)
  - Cloud Messaging (Push notifications)
```

### 3.3 Development Tools
```yaml
Development:
  - flutter_launcher_icons: ^0.13.1
  - flutter_native_splash: ^2.3.7
  - build_runner: ^2.4.7
  - freezed_annotation: ^2.4.1
  - json_serializable: ^6.7.1

Testing:
  - flutter_test: (SDK)
  - mockito: ^5.4.4
  - bloc_test: ^9.1.5
  - integration_test: (SDK)

Code Quality:
  - flutter_lints: ^3.0.1
  - very_good_analysis: ^5.1.0
```

---

## 4. Project Structure

```
storydoku/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── firebase_config.dart
│   │   │   └── theme_config.dart
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── story_constants.dart
│   │   │   └── difficulty_levels.dart
│   │   ├── di/
│   │   │   └── injection.dart
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   └── network_info.dart
│   │   ├── utils/
│   │   │   ├── logger.dart
│   │   │   ├── validators.dart
│   │   │   └── formatters.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── app_colors.dart
│   │       ├── app_typography.dart
│   │       └── app_dimensions.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login.dart
│   │   │   │       ├── register.dart
│   │   │   │       ├── logout.dart
│   │   │   │       └── get_current_user.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── auth_bloc.dart
│   │   │       │   ├── auth_event.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   ├── register_screen.dart
│   │   │       │   └── splash_screen.dart
│   │   │       └── widgets/
│   │   │           ├── auth_button.dart
│   │   │           └── social_login_buttons.dart
│   │   │
│   │   ├── game/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── puzzle_local_datasource.dart
│   │   │   │   │   └── puzzle_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── puzzle_model.dart
│   │   │   │   │   ├── cell_model.dart
│   │   │   │   │   └── game_state_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── puzzle_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── puzzle.dart
│   │   │   │   │   ├── cell.dart
│   │   │   │   │   └── game_state.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── puzzle_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── generate_puzzle.dart
│   │   │   │       ├── validate_move.dart
│   │   │   │       ├── solve_puzzle.dart
│   │   │   │       ├── get_hint.dart
│   │   │   │       └── save_game_state.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── game_bloc.dart
│   │   │       │   ├── game_event.dart
│   │   │       │   └── game_state.dart
│   │   │       ├── screens/
│   │   │       │   ├── game_screen.dart
│   │   │       │   ├── difficulty_selection_screen.dart
│   │   │       │   └── game_complete_screen.dart
│   │   │       └── widgets/
│   │   │           ├── sudoku_grid.dart
│   │   │           ├── sudoku_cell.dart
│   │   │           ├── number_pad.dart
│   │   │           ├── game_controls.dart
│   │   │           ├── timer_widget.dart
│   │   │           └── hint_button.dart
│   │   │
│   │   ├── story/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── story_local_datasource.dart
│   │   │   │   │   └── story_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── chapter_model.dart
│   │   │   │   │   ├── scene_model.dart
│   │   │   │   │   ├── dialogue_model.dart
│   │   │   │   │   └── character_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── story_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── chapter.dart
│   │   │   │   │   ├── scene.dart
│   │   │   │   │   ├── dialogue.dart
│   │   │   │   │   └── character.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── story_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── load_chapter.dart
│   │   │   │       ├── unlock_scene.dart
│   │   │   │       ├── get_story_progress.dart
│   │   │   │       └── mark_scene_viewed.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── story_bloc.dart
│   │   │       │   ├── story_event.dart
│   │   │       │   └── story_state.dart
│   │   │       ├── screens/
│   │   │       │   ├── story_viewer_screen.dart
│   │   │       │   ├── chapter_select_screen.dart
│   │   │       │   └── story_intro_screen.dart
│   │   │       └── widgets/
│   │   │           ├── dialogue_box.dart
│   │   │           ├── character_sprite.dart
│   │   │           ├── scene_background.dart
│   │   │           ├── story_choice_button.dart
│   │   │           └── typewriter_text.dart
│   │   │
│   │   ├── progress/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── progress_local_datasource.dart
│   │   │   │   │   └── progress_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_progress_model.dart
│   │   │   │   │   ├── achievement_model.dart
│   │   │   │   │   └── stats_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── progress_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user_progress.dart
│   │   │   │   │   ├── achievement.dart
│   │   │   │   │   └── stats.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── progress_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── save_progress.dart
│   │   │   │       ├── get_progress.dart
│   │   │   │       ├── unlock_achievement.dart
│   │   │   │       └── sync_progress.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── progress_bloc.dart
│   │   │       │   ├── progress_event.dart
│   │   │       │   └── progress_state.dart
│   │   │       ├── screens/
│   │   │       │   ├── profile_screen.dart
│   │   │       │   ├── achievements_screen.dart
│   │   │       │   └── statistics_screen.dart
│   │   │       └── widgets/
│   │   │           ├── progress_card.dart
│   │   │           ├── achievement_badge.dart
│   │   │           ├── stats_chart.dart
│   │   │           └── level_indicator.dart
│   │   │
│   │   ├── daily/
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── daily_challenge_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── daily_challenge.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── daily_challenge_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_daily_challenge.dart
│   │   │   │       └── submit_daily_solution.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── daily_bloc.dart
│   │   │       │   ├── daily_event.dart
│   │   │       │   └── daily_state.dart
│   │   │       ├── screens/
│   │   │       │   └── daily_challenge_screen.dart
│   │   │       └── widgets/
│   │   │           └── daily_challenge_card.dart
│   │   │
│   │   └── home/
│   │       └── presentation/
│   │           ├── screens/
│   │           │   └── home_screen.dart
│   │           └── widgets/
│   │               ├── mode_selection_card.dart
│   │               ├── continue_game_card.dart
│   │               └── daily_reminder_card.dart
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── loading_indicator.dart
│       │   ├── error_widget.dart
│       │   ├── custom_button.dart
│       │   ├── custom_dialog.dart
│       │   └── page_header.dart
│       └── extensions/
│           ├── context_extensions.dart
│           ├── string_extensions.dart
│           └── datetime_extensions.dart
│
├── assets/
│   ├── images/
│   │   ├── backgrounds/
│   │   ├── characters/
│   │   ├── icons/
│   │   └── ui/
│   ├── animations/
│   │   └── lottie/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   ├── fonts/
│   └── stories/
│       ├── codebreakers/
│       │   ├── chapter_1.json
│       │   ├── chapter_2.json
│       │   └── ...
│       ├── detective/
│       └── zen/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── android/
├── ios/
├── web/
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 5. Core Components

### 5.1 Sudoku Engine

#### Puzzle Generator
```dart
class SudokuGenerator {
  /// Generates a valid Sudoku puzzle with specified difficulty
  /// 
  /// Algorithm: Backtracking with pattern-based cell removal
  /// - Easy: 36-45 clues (35-45 empty cells)
  /// - Medium: 27-35 clues (46-54 empty cells)
  /// - Hard: 22-26 clues (55-59 empty cells)
  /// - Expert: 17-21 clues (60-64 empty cells)
  Puzzle generate(Difficulty difficulty);
  
  /// Generates solution grid using backtracking
  List<List<int>> _generateSolution();
  
  /// Removes numbers to create puzzle while ensuring unique solution
  void _removeNumbers(int count);
  
  /// Validates that puzzle has exactly one solution
  bool _hasUniqueSolution();
}
```

#### Puzzle Solver
```dart
class SudokuSolver {
  /// Solves puzzle using backtracking algorithm
  bool solve(List<List<int>> grid);
  
  /// Validates if a number can be placed at position
  bool isValid(int row, int col, int num);
  
  /// Gets all possible candidates for a cell
  Set<int> getCandidates(int row, int col);
  
  /// Counts number of solutions (for uniqueness check)
  int countSolutions(List<List<int>> grid, {int maxCount = 2});
}
```

#### Puzzle Validator
```dart
class SudokuValidator {
  /// Validates complete puzzle solution
  bool validateSolution(List<List<int>> grid);
  
  /// Validates a single move
  ValidationResult validateMove(Puzzle puzzle, int row, int col, int value);
  
  /// Checks if puzzle is solvable
  bool isSolvable(Puzzle puzzle);
  
  /// Detects conflicts in current state
  List<Conflict> findConflicts(List<List<int>> grid);
}
```

### 5.2 Story Engine

#### Story Parser
```dart
class StoryParser {
  /// Loads and parses story chapter from JSON
  Future<Chapter> loadChapter(String chapterId);
  
  /// Validates story JSON structure
  bool validateStoryJson(Map<String, dynamic> json);
  
  /// Parses scene data with dialogue and choices
  Scene parseScene(Map<String, dynamic> sceneData);
}
```

#### Story Manager
```dart
class StoryManager {
  /// Manages story progression and unlocking
  Future<void> unlockScene(String chapterId, String sceneId);
  
  /// Checks if scene is unlocked
  bool isSceneUnlocked(String chapterId, String sceneId);
  
  /// Gets next scene based on choices
  Scene? getNextScene(String currentSceneId, String? choiceId);
  
  /// Calculates story completion percentage
  double getCompletionPercentage(String chapterId);
}
```

### 5.3 Progress Tracking

#### Progress Manager
```dart
class ProgressManager {
  /// Saves puzzle completion progress
  Future<void> savePuzzleProgress(PuzzleProgress progress);
  
  /// Saves story progression
  Future<void> saveStoryProgress(StoryProgress progress);
  
  /// Syncs local progress with cloud
  Future<void> syncProgress();
  
  /// Calculates skill rating
  int calculateSkillRating(List<PuzzleResult> results);
  
  /// Awards achievements
  Future<void> checkAndAwardAchievements(GameEvent event);
}
```

---

## 6. Data Models

### 6.1 Core Entities

#### User
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    required DateTime createdAt,
    required UserSettings settings,
    required UserProgress progress,
  }) = _User;
}
```

#### Puzzle
```dart
@freezed
class Puzzle with _$Puzzle {
  const factory Puzzle({
    required String id,
    required List<List<Cell>> grid,
    required List<List<int>> solution,
    required Difficulty difficulty,
    required String chapterId,
    required int puzzleNumber,
    required DateTime createdAt,
  }) = _Puzzle;
}
```

#### Cell
```dart
@freezed
class Cell with _$Cell {
  const factory Cell({
    required int row,
    required int col,
    int? value,
    required bool isFixed,
    required bool isCorrect,
    required Set<int> notes,
    CellState? state, // normal, selected, highlighted, error
  }) = _Cell;
}
```

#### Chapter
```dart
@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String title,
    required String description,
    required StoryTheme theme,
    required List<Scene> scenes,
    required List<Puzzle> puzzles,
    required int order,
    required bool isLocked,
  }) = _Chapter;
}
```

#### Scene
```dart
@freezed
class Scene with _$Scene {
  const factory Scene({
    required String id,
    required String chapterId,
    required String title,
    required String backgroundImage,
    required List<Dialogue> dialogues,
    List<Character>? characters,
    List<SceneChoice>? choices,
    required int order,
    required bool isUnlocked,
  }) = _Scene;
}
```

#### Dialogue
```dart
@freezed
class Dialogue with _$Dialogue {
  const factory Dialogue({
    required String id,
    required String text,
    String? characterId,
    DialogueType? type, // narration, speech, system
    int? delay,
    String? audioFile,
  }) = _Dialogue;
}
```

### 6.2 Progress Models

#### UserProgress
```dart
@freezed
class UserProgress with _$UserProgress {
  const factory UserProgress({
    required String userId,
    required int totalPuzzlesSolved,
    required int currentStreak,
    required int longestStreak,
    required int totalPlayTime, // seconds
    required int skillRating,
    required Map<Difficulty, DifficultyStats> statsByDifficulty,
    required List<String> unlockedChapters,
    required Map<String, ChapterProgress> chapterProgress,
    required List<Achievement> achievements,
    required DateTime lastPlayed,
  }) = _UserProgress;
}
```

#### GameState
```dart
@freezed
class GameState with _$GameState {
  const factory GameState({
    required String id,
    required Puzzle puzzle,
    required List<List<Cell>> currentGrid,
    required int elapsedTime,
    required int mistakes,
    required bool isPaused,
    required bool isCompleted,
    required List<Move> moveHistory,
    required DateTime startedAt,
    DateTime? completedAt,
  }) = _GameState;
}
```

---

## 7. State Management

### 7.1 BLoC Architecture

#### Game BLoC States
```dart
@freezed
class GameState with _$GameState {
  const factory GameState.initial() = _Initial;
  const factory GameState.loading() = _Loading;
  const factory GameState.playing({
    required Puzzle puzzle,
    required List<List<Cell>> currentGrid,
    required int elapsedTime,
    required int mistakes,
    Cell? selectedCell,
  }) = _Playing;
  const factory GameState.paused() = _Paused;
  const factory GameState.completed({
    required PuzzleResult result,
  }) = _Completed;
  const factory GameState.error(String message) = _Error;
}
```

#### Game BLoC Events
```dart
@freezed
class GameEvent with _$GameEvent {
  const factory GameEvent.started({
    required Difficulty difficulty,
    String? chapterId,
    int? puzzleNumber,
  }) = _Started;
  
  const factory GameEvent.cellSelected(int row, int col) = _CellSelected;
  const factory GameEvent.numberEntered(int number) = _NumberEntered;
  const factory GameEvent.noteToggled(int number) = _NoteToggled;
  const factory GameEvent.cellCleared() = _CellCleared;
  
  const factory GameEvent.hintRequested() = _HintRequested;
  const factory GameEvent.undoRequested() = _UndoRequested;
  const factory GameEvent.pauseToggled() = _PauseToggled;
  
  const factory GameEvent.puzzleValidated() = _PuzzleValidated;
  const factory GameEvent.puzzleCompleted() = _PuzzleCompleted;
}
```

### 7.2 State Flow Example

```
User Action → Event → BLoC → Use Case → Repository → Data Source
     ↓                                                      ↓
  UI Update ←───────────────────── New State ←─────────────┘
```

---

## 8. Firebase Integration

### 8.1 Authentication Flow

```dart
// Sign in with email
AuthResult signIn(String email, String password);

// Register new user
AuthResult register(String email, String password, String displayName);

// Google Sign-In
AuthResult signInWithGoogle();

// Guest mode (Anonymous)
AuthResult signInAnonymously();

// Convert guest to permanent account
AuthResult linkGuestAccount(String email, String password);
```

### 8.2 Firestore Schema

#### Collections Structure
```
users/
  {userId}/
    - email: string
    - displayName: string
    - photoUrl: string
    - createdAt: timestamp
    - lastLoginAt: timestamp
    - settings: map
    
    progress/
      {progressId}/
        - totalPuzzlesSolved: number
        - currentStreak: number
        - skillRating: number
        - lastPlayed: timestamp
    
    gameStates/
      {gameId}/
        - puzzleId: string
        - currentGrid: array
        - elapsedTime: number
        - startedAt: timestamp
        - isCompleted: boolean
    
    storyProgress/
      {chapterId}/
        - unlockedScenes: array
        - completedPuzzles: array
        - lastSceneViewed: string
        - completionPercentage: number
    
    achievements/
      {achievementId}/
        - achievementId: string
        - unlockedAt: timestamp

puzzles/
  {puzzleId}/
    - grid: array
    - solution: array
    - difficulty: string
    - chapterId: string
    - createdAt: timestamp

dailyChallenges/
  {date}/
    - puzzleId: string
    - date: timestamp
    - completedBy: number
    - averageTime: number

leaderboards/
  global/
    {userId}: { score: number, rank: number }
  
  daily/
    {date}/
      {userId}: { time: number, rank: number }
```

### 8.3 Cloud Functions

```javascript
// Generate daily puzzle (scheduled)
exports.generateDailyPuzzle = functions.pubsub
  .schedule('0 0 * * *')
  .onRun(async (context) => {
    // Generate and store daily puzzle
  });

// Calculate leaderboard rankings (triggered)
exports.updateLeaderboard = functions.firestore
  .document('puzzles/{puzzleId}/completions/{userId}')
  .onCreate(async (snap, context) => {
    // Update global and daily leaderboards
  });

// Award achievements (callable)
exports.checkAchievements = functions.https
  .onCall(async (data, context) => {
    // Check and award achievements
  });

// Sync progress (callable)
exports.syncUserProgress = functions.https
  .onCall(async (data, context) => {
    // Sync local and cloud progress
  });
```

### 8.4 Storage Structure

```
stories/
  codebreakers/
    chapter_1/
      backgrounds/
        scene_1.png
        scene_2.png
      characters/
        protagonist.png
        ai_core.png
      audio/
        ambient.mp3
        dialogue_1.mp3
    chapter_2/
      ...

user_profiles/
  {userId}/
    avatar.jpg
```

---

## 9. Story Engine Design

### 9.1 Story JSON Schema

```json
{
  "chapter": {
    "id": "codebreakers_ch1",
    "title": "The Last Cipher",
    "description": "You awaken in a digital wasteland...",
    "theme": "codebreakers",
    "order": 1,
    "unlockCondition": null,
    "scenes": [
      {
        "id": "scene_1",
        "title": "Awakening",
        "backgroundImage": "stories/codebreakers/chapter_1/backgrounds/digital_wasteland.png",
        "ambientAudio": "stories/codebreakers/chapter_1/audio/ambient_digital.mp3",
        "characters": [
          {
            "id": "protagonist",
            "name": "You",
            "sprite": "stories/codebreakers/chapter_1/characters/protagonist.png",
            "position": "center"
          }
        ],
        "dialogues": [
          {
            "id": "d1",
            "characterId": null,
            "type": "narration",
            "text": "You awaken in a world of fragments—data streams broken into pieces.",
            "delay": 50,
            "audioFile": null
          },
          {
            "id": "d2",
            "characterId": "ai_core",
            "type": "speech",
            "text": "Cryptographer... you must restore the grid. Each puzzle is a memory we've lost.",
            "delay": 50,
            "audioFile": "stories/codebreakers/chapter_1/audio/ai_dialogue_1.mp3"
          }
        ],
        "unlockCondition": {
          "type": "chapter_start",
          "value": null
        },
        "nextScene": "puzzle_1"
      },
      {
        "id": "puzzle_1",
        "title": "First Fragment",
        "type": "puzzle",
        "puzzleId": "cb_ch1_p1",
        "difficulty": "easy",
        "introDialogue": [
          {
            "id": "pd1",
            "characterId": "ai_core",
            "type": "system",
            "text": "Decode this cipher. It's a 9x9 grid—each row, column, and 3x3 box must contain numbers 1-9.",
            "delay": 50
          }
        ],
        "onComplete": "scene_2"
      },
      {
        "id": "scene_2",
        "title": "First Memory",
        "backgroundImage": "stories/codebreakers/chapter_1/backgrounds/memory_fragment.png",
        "dialogues": [
          {
            "id": "d3",
            "characterId": null,
            "type": "narration",
            "text": "The grid dissolves... revealing a memory: the world before the collapse.",
            "delay": 50
          }
        ],
        "choices": [
          {
            "id": "choice_1",
            "text": "Investigate the memory",
            "nextScene": "scene_3"
          },
          {
            "id": "choice_2",
            "text": "Continue to next cipher",
            "nextScene": "puzzle_2"
          }
        ]
      }
    ],
    "puzzles": [
      {
        "id": "cb_ch1_p1",
        "difficulty": "easy",
        "order": 1,
        "linkedScene": "puzzle_1",
        "rewardScene": "scene_2"
      }
    ]
  }
}
```

### 9.2 Story Progression Logic

```dart
class StoryProgressionEngine {
  /// Determines next scene based on current state
  Scene? getNextScene(
    String currentSceneId,
    String? choiceId,
    Map<String, dynamic> gameState,
  ) {
    // Check unlock conditions
    // Apply choice logic
    // Return next scene or null if chapter complete
  }
  
  /// Checks if scene unlock conditions are met
  bool canUnlockScene(Scene scene, Map<String, dynamic> progress) {
    return scene.unlockCondition.validate(progress);
  }
  
  /// Triggers story event after puzzle completion
  Future<void> onPuzzleComplete(String puzzleId) {
    // Find linked scene
    // Unlock reward scene
    // Update progress
    // Trigger animations/notifications
  }
}
```

---

## 10. Security & Performance

### 10.1 Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User data - only owner can read/write
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /progress/{progressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /gameStates/{gameId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /storyProgress/{chapterId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Puzzles - read-only for all authenticated users
    match /puzzles/{puzzleId} {
      allow read: if request.auth != null;
      allow write: if false; // Only via Cloud Functions
    }
    
    // Daily challenges - read-only
    match /dailyChallenges/{date} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Leaderboards - read-only
    match /leaderboards/{type} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

### 10.2 Performance Optimizations

#### Caching Strategy
```dart
// Local-first architecture
class CachedRepository<T> {
  final LocalDataSource<T> localSource;
  final RemoteDataSource<T> remoteSource;
  final NetworkInfo networkInfo;
  
  Future<T> getData(String id) async {
    // 1. Try local cache first
    try {
      return await localSource.get(id);
    } catch (e) {
      // 2. Fetch from remote if online
      if (await networkInfo.isConnected) {
        final data = await remoteSource.get(id);
        // 3. Cache locally
        await localSource.save(id, data);
        return data;
      }
      throw CacheException();
    }
  }
}
```

#### Image Optimization
```dart
// Lazy loading and caching
CachedNetworkImage(
  imageUrl: scene.backgroundImage,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => ErrorPlaceholder(),
  fadeInDuration: Duration(milliseconds: 300),
  memCacheWidth: 1080,
  memCacheHeight: 1920,
)
```

#### State Persistence
```dart
// Auto-save game state every 30 seconds
Timer.periodic(Duration(seconds: 30), (timer) {
  if (currentGameState.isPlaying) {
    _saveGameState(currentGameState);
  }
});
```

### 10.3 Offline Support

```dart
// Offline-first game experience
class OfflineGameManager {
  /// Check if puzzle can be played offline
  bool canPlayOffline(String puzzleId) {
    return localDataSource.hasPuzzle(puzzleId);
  }
  
  /// Queue progress updates for sync when online
  Future<void> queueProgressUpdate(Progress progress) async {
    await localDataSource.savePending(progress);
    // Will sync when connection restored
  }
  
  /// Sync all pending updates
  Future<void> syncPendingUpdates() async {
    if (await networkInfo.isConnected) {
      final pending = await localDataSource.getPending();
      for (var update in pending) {
        await remoteDataSource.sync(update);
        await localDataSource.removePending(update.id);
      }
    }
  }
}
```

---

## 11. Testing Strategy

### 11.1 Unit Tests
- Sudoku generator logic
- Sudoku solver algorithms
- Validation rules
- Story progression logic
- State management (BLoCs)

### 11.2 Widget Tests
- UI components rendering
- User interactions
- Navigation flows
- Error states

### 11.3 Integration Tests
- End-to-end game flow
- Authentication flow
- Story progression
- Progress syncing

---

## 12. Analytics Events

```dart
// Key events to track
enum AnalyticsEvent {
  // User lifecycle
  userSignUp,
  userLogin,
  userLogout,
  
  // Game events
  puzzleStarted,
  puzzleCompleted,
  puzzleAbandoned,
  hintUsed,
  mistakeMade,
  
  // Story events
  sceneViewed,
  chapterCompleted,
  choiceMade,
  
  // Engagement
  dailyChallengeStarted,
  dailyChallengeCompleted,
  achievementUnlocked,
  
  // Monetization
  premiumContentViewed,
  purchaseInitiated,
  purchaseCompleted,
}
```

---

## 13. Scalability Considerations

### 13.1 Chapter Expansion
- Modular JSON-based story system
- Dynamic chapter loading
- Version control for story content
- A/B testing for story variations

### 13.2 Multi-theme Support
- Abstract story theme interface
- Theme-specific assets organization
- Theme switching without code changes
- Cross-theme progress tracking

### 13.3 Localization
- Multi-language support (i18n)
- Separate story translations
- RTL language support
- Regional content variations

---

## Conclusion

This architecture provides:
- ✅ **Clean separation of concerns** for maintainability
- ✅ **Offline-first approach** for reliable user experience
- ✅ **Scalable story system** for content expansion
- ✅ **Firebase integration** for cloud features
- ✅ **Performance optimizations** for smooth gameplay
- ✅ **Testable codebase** for quality assurance
- ✅ **Future-proof design** for feature additions

The architecture follows industry best practices and Flutter/Dart conventions while maintaining flexibility for the unique story-driven Sudoku experience.

