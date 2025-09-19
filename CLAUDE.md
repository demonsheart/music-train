# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based music training application designed to help musicians improve their fundamental skills. The project aims to provide free alternative to paid music learning tools with the following core features:

### Core Features (Planned)
- Scale degree and note name reaction training (12 keys)
- Chord training
- Rhythm training
- Scale training
- Improvisation training
- Chord-scale pairing
- Chord progression training
- Circle of fifths training

## Current Focus (Version 1)

The initial version focuses on implementing the scale degree and note name reaction training feature with two modes:

1. **Forward Practice**: In circle of fifths descending order, prompt user with current major/minor key, generate scale degrees, and have user match note names
2. **Reverse Practice**: In circle of fifths descending order, prompt user with current major/minor key, generate note names, and have user match scale degrees
3. **Key Mode Switching**: Allow users to switch between major and minor keys

Requirements include beautiful UI design, reward mechanisms, and timing strategies to enhance training efficiency.

## Technology Stack

- **Framework**: Flutter (for rapid development and cross-platform compatibility)
- **Language**: Dart

## Development Setup

Since this is a new Flutter project, you'll need to:

1. Initialize Flutter project: `flutter create .` or `flutter create music_train`
2. Set up project structure in `lib/` directory
3. Configure dependencies in `pubspec.yaml`

## Project Architecture Notes

- The app should follow Flutter best practices with clean architecture
- Focus on music theory logic implementation for the first feature
- Design with future feature expansion in mind
- Implement gamification elements for better user engagement

## Music Theory Concepts

Key concepts to implement:
- Circle of fifths (五度圈)
- Scale degrees (级数) and note names (音名) mapping
- Major/minor key relationships
- Music notation fundamentals