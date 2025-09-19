enum NoteName {
  C,
  CSharp,
  D,
  DSharp,
  E,
  F,
  FSharp,
  G,
  GSharp,
  A,
  ASharp,
  B,
  BFlat,
  EFlat,
  AFlat,
  DFlat,
  GFlat
}

extension NoteNameExtension on NoteName {
  String get displayName {
    switch (this) {
      case NoteName.C:
        return 'C';
      case NoteName.CSharp:
        return 'C#';
      case NoteName.D:
        return 'D';
      case NoteName.DSharp:
        return 'D#';
      case NoteName.E:
        return 'E';
      case NoteName.F:
        return 'F';
      case NoteName.FSharp:
        return 'F#';
      case NoteName.G:
        return 'G';
      case NoteName.GSharp:
        return 'G#';
      case NoteName.A:
        return 'A';
      case NoteName.ASharp:
        return 'A#';
      case NoteName.B:
        return 'B';
      case NoteName.BFlat:
        return 'Bb';
      case NoteName.EFlat:
        return 'Eb';
      case NoteName.AFlat:
        return 'Ab';
      case NoteName.DFlat:
        return 'Db';
      case NoteName.GFlat:
        return 'Gb';
    }
  }

  static NoteName fromString(String name) {
    switch (name.toUpperCase()) {
      case 'C':
        return NoteName.C;
      case 'C#':
        return NoteName.CSharp;
      case 'D':
        return NoteName.D;
      case 'D#':
        return NoteName.DSharp;
      case 'E':
        return NoteName.E;
      case 'F':
        return NoteName.F;
      case 'F#':
        return NoteName.FSharp;
      case 'G':
        return NoteName.G;
      case 'G#':
        return NoteName.GSharp;
      case 'A':
        return NoteName.A;
      case 'A#':
        return NoteName.ASharp;
      case 'B':
        return NoteName.B;
      case 'BB':
      case 'B♭':
        return NoteName.BFlat;
      case 'EB':
      case 'E♭':
        return NoteName.EFlat;
      case 'AB':
      case 'A♭':
        return NoteName.AFlat;
      case 'DB':
      case 'D♭':
        return NoteName.DFlat;
      case 'GB':
      case 'G♭':
        return NoteName.GFlat;
      default:
        return NoteName.C;
    }
  }
}