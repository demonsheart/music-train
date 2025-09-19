import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../models/scale_degree.dart';
import '../models/key_signature.dart';

class MusicTheoryService with ChangeNotifier {
  List<NoteName> _circleOfFifthsDescending = [];
  bool _isMajor = true;
  KeySignature? _currentKey;
  ScaleDegree? _currentScaleDegree;
  NoteName? _currentNote;
  int _score = 0;
  int _streak = 0;
  bool _isTrainingMode = false;
  bool _isForwardMode = true;

  MusicTheoryService() {
    _initializeCircleOfFifths();
    generateNewQuestion();
  }

  void _initializeCircleOfFifths() {
    _circleOfFifthsDescending = [
      NoteName.C,
      NoteName.F,
      NoteName.BFlat,
      NoteName.EFlat,
      NoteName.AFlat,
      NoteName.DFlat,
      NoteName.GFlat,
      NoteName.B,
      NoteName.E,
      NoteName.A,
      NoteName.D,
      NoteName.G,
    ];
  }

  List<NoteName> get circleOfFifthsDescending => _circleOfFifthsDescending;
  bool get isMajor => _isMajor;
  KeySignature? get currentKey => _currentKey;
  ScaleDegree? get currentScaleDegree => _currentScaleDegree;
  NoteName? get currentNote => _currentNote;
  int get score => _score;
  int get streak => _streak;
  bool get isTrainingMode => _isTrainingMode;
  bool get isForwardMode => _isForwardMode;

  void toggleKeyMode() {
    _isMajor = !_isMajor;
    generateNewQuestion();
    notifyListeners();
  }

  void toggleTrainingMode() {
    _isForwardMode = !_isForwardMode;
    generateNewQuestion();
    notifyListeners();
  }

  void generateNewQuestion() {
    if (_circleOfFifthsDescending.isEmpty) return;

    final randomRoot = _circleOfFifthsDescending[
        DateTime.now().millisecond % _circleOfFifthsDescending.length];

    _currentKey = KeySignature(
      root: randomRoot,
      type: _isMajor ? KeyType.major : KeyType.minor,
    );

    final randomDegreeIndex = DateTime.now().second % 7;
    _currentScaleDegree = ScaleDegree.fromInt(randomDegreeIndex + 1);

    _currentNote = _getNoteForScaleDegree(_currentKey!, _currentScaleDegree!);
    notifyListeners();
  }

  NoteName _getNoteForScaleDegree(KeySignature key, ScaleDegree degree) {
    const majorIntervals = [0, 2, 4, 5, 7, 9, 11];
    const minorIntervals = [0, 2, 3, 5, 7, 8, 10];

    final intervals = key.type == KeyType.major ? majorIntervals : minorIntervals;
    final semitoneOffset = intervals[degree.degree - 1];

    final noteIndex = (key.root.index + semitoneOffset) % 12;
    return NoteName.values[noteIndex];
  }

  ScaleDegree getScaleDegreeForNote(KeySignature key, NoteName note) {
    const majorIntervals = [0, 2, 4, 5, 7, 9, 11];
    const minorIntervals = [0, 2, 3, 5, 7, 8, 10];

    final intervals = key.type == KeyType.major ? majorIntervals : minorIntervals;

    final keyIndex = key.root.index;
    final noteIndex = note.index;

    final semitoneDifference = (noteIndex - keyIndex + 12) % 12;

    final degreeIndex = intervals.indexOf(semitoneDifference);
    if (degreeIndex != -1) {
      return ScaleDegree.fromInt(degreeIndex + 1);
    }

    return ScaleDegree.I;
  }

  bool checkAnswer(dynamic userAnswer) {
    if (_currentKey == null) return false;

    bool isCorrect = false;

    if (_isForwardMode) {
      if (userAnswer is NoteName) {
        isCorrect = userAnswer == _currentNote;
      }
    } else {
      if (userAnswer is ScaleDegree) {
        isCorrect = userAnswer == _currentScaleDegree;
      }
    }

    if (isCorrect) {
      _score += 10;
      _streak += 1;
    } else {
      _streak = 0;
    }

    generateNewQuestion();
    notifyListeners();
    return isCorrect;
  }

  List<NoteName> getAvailableNotes() => NoteName.values.toList();
  List<ScaleDegree> getAvailableScaleDegrees() => ScaleDegree.values.toList();

  void startTraining() {
    _isTrainingMode = true;
    _score = 0;
    _streak = 0;
    generateNewQuestion();
    notifyListeners();
  }

  void stopTraining() {
    _isTrainingMode = false;
    notifyListeners();
  }
}