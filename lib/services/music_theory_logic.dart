// 音乐理论逻辑工具类
class MusicTheoryLogic {
  // 大调音阶：全全半全全全半
  static const List<int> majorScaleIntervals = [0, 2, 4, 5, 7, 9, 11];

  // 小调音阶：全半全全半全全
  static const List<int> minorScaleIntervals = [0, 2, 3, 5, 7, 8, 10];

  // 12个半音的音名
  static const List<String> chromaticNotes = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  // 五度圈下行顺序
  static const List<String> circleOfFifthsDescending = [
    'C', 'F', 'Bb', 'Eb', 'Ab', 'Db', 'Gb', 'B', 'E', 'A', 'D', 'G'
  ];

  // 根据调性和级数获取对应的音名
  static String getNoteForDegree(String key, bool isMajor, int degree) {
    if (degree < 1 || degree > 7) return 'C';

    final keyIndex = chromaticNotes.indexOf(key);
    if (keyIndex == -1) return 'C';

    final intervals = isMajor ? majorScaleIntervals : minorScaleIntervals;
    final semitoneOffset = intervals[degree - 1];

    final noteIndex = (keyIndex + semitoneOffset) % 12;
    return chromaticNotes[noteIndex];
  }

  // 根据调性和音名获取对应的级数
  static int getDegreeForNote(String key, bool isMajor, String note) {
    final keyIndex = chromaticNotes.indexOf(key);
    final noteIndex = chromaticNotes.indexOf(note);

    if (keyIndex == -1 || noteIndex == -1) return 1;

    final intervals = isMajor ? majorScaleIntervals : minorScaleIntervals;

    final semitoneDifference = (noteIndex - keyIndex + 12) % 12;
    final degreeIndex = intervals.indexOf(semitoneDifference);

    return degreeIndex != -1 ? degreeIndex + 1 : 1;
  }

  // 获取所有可用的音名
  static List<String> getAvailableNotes() {
    return List.from(chromaticNotes);
  }

  // 获取所有可用的级数
  static List<int> getAvailableDegrees() {
    return [1, 2, 3, 4, 5, 6, 7];
  }

  // 验证答案是否正确
  static bool validateAnswer(String key, bool isMajor, bool isForwardMode,
                            int questionDegree, String questionNote,
                            dynamic userAnswer) {
    if (isForwardMode) {
      // 正向模式：给级数，选音名
      if (userAnswer is String) {
        final correctNote = getNoteForDegree(key, isMajor, questionDegree);
        return userAnswer == correctNote;
      }
    } else {
      // 反向模式：给音名，选级数
      if (userAnswer is int) {
        final correctDegree = getDegreeForNote(key, isMajor, questionNote);
        return userAnswer == correctDegree;
      }
    }
    return false;
  }
}