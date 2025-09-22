# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Music Train is a Flutter-based music training application that provides free alternative to paid music learning tools. The app helps musicians improve fundamental skills through interactive training exercises.

## Common Development Commands

### Essential Commands

```bash
# Install dependencies
flutter pub get

# Run app (web version)
flutter run -d chrome

# Hot reload during development
# Press 'r' in running terminal

# Hot restart
# Press 'R' in running terminal

# Run tests
flutter test

# Code analysis
flutter analyze

# Build for release (web)
flutter build web --release
```

### Development Setup

- **Flutter SDK**: >=3.0.0
- **Dart SDK**: >=3.0.0
- **Target Platform**: Web (iOS/Android ready)

## Project Architecture

### Directory Structure

```
lib/
├── screens/              # Main app screens
│   ├── splash_screen.dart
│   ├── home_screen_simple.dart
│   └── training_screen_basic.dart
├── services/             # Business logic
│   └── music_theory_logic.dart
├── widgets/              # Reusable UI components
│   ├── answer_button.dart
│   └── feedback_overlay.dart
└── main.dart             # App entry point
```

### Architecture Pattern

- **Clean Architecture**: Clear separation of concerns
- **State Management**: Provider pattern for state sharing
- **Presentation Layer**: Screens and widgets
- **Business Logic**: Music theory calculations in services
- **Data Layer**: Minimal, using shared_preferences for persistence

### Key Components

#### Training Screen (`lib/screens/training_screen_basic.dart`)

- Main training interface with 3-phase user journey
- Manages timer, scoring, and training state
- Handles key selection, duration selection, and active training

#### Music Theory Logic (`lib/services/music_theory_logic.dart`)

- Pure business logic with no UI dependencies
- Implements accurate scale calculations:
  - Major scale: W-W-H-W-W-W-H `[0, 2, 4, 5, 7, 9, 11]`
  - Minor scale: W-H-W-W-H-W-W `[0, 2, 3, 5, 7, 8, 10]`
- Answer validation and note/degree mapping

#### Answer Button (`lib/widgets/answer_button.dart`)

- Sophisticated button component with multiple states
- Smart feedback system with visual indicators
- Animation controllers for press feedback

## Core Features (v1.3)

### Current Implementation

- **Twelve-Key Training**: All chromatic keys with major/minor modes
- **Dual Practice Modes**:
  - Forward: Scale degrees → Note names
  - Reverse: Note names → Scale degrees
- **Smart Feedback System**: Button-level feedback without popup disruption
- **Fixed Key Practice**: Users can focus on single key
- **Real-time Metrics**: Score, streak, accuracy tracking

### Music Theory Implementation

- Supports all 12 chromatic keys (C, C#, D, D#, E, F, F#, G, G#, A, A#, B)
- Accurate major/minor scale calculations
- Real-time answer validation
- Circle of fifths foundation for future features

## Development Patterns

### State Management

- Use **StatefulWidgets** for complex UI state
- **Provider** pattern for cross-widget state sharing
- Local state managed within individual widgets
- Proper timer cleanup in dispose()

### UI/UX Conventions

- **Material Design 3**: Modern UI components
- **Card-based Layout**: Clear information hierarchy
- **Gradient Backgrounds**: Blue/purple theme
- **Bilingual Interface**: Chinese with English terms
- **Responsive Design**: Grid-based layouts
- **Animation**: Smooth transitions and micro-interactions

### Code Quality

- **Null Safety**: Modern Dart null safety
- **Linting**: Flutter recommended lints
- **Testing**: Flutter test framework
- **Performance**: Efficient rebuilds and memory management

## Important Implementation Details

### Answer Feedback System

- **Button-level feedback**: Results shown directly on answer buttons
- **Visual indicators**: ✓ Green for correct, ✗ Red for incorrect, 💡 Amber for correct answer when user was wrong
- **Non-intrusive**: No full-screen popups, maintains training flow
- **Auto-progression**: 1.5-second delay before next question

### User Journey Phases

1. **Duration Selection**: 5, 10, 20, or 30-minute sessions
2. **Key Selection**: Choose from 12 chromatic keys
3. **Active Training**: Real-time questions with immediate feedback

### Animation Patterns

- **AnimationController**: Manual control for complex animations
- **Tween Animations**: Smooth interpolation between values
- **CurvedAnimation**: Natural easing curves
- **Auto-cleanup**: Proper disposal in lifecycle methods
