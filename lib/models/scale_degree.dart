enum ScaleDegree {
  I,
  II,
  III,
  IV,
  V,
  VI,
  VII
}

extension ScaleDegreeExtension on ScaleDegree {
  String get displayName {
    switch (this) {
      case ScaleDegree.I:
        return 'I';
      case ScaleDegree.II:
        return 'II';
      case ScaleDegree.III:
        return 'III';
      case ScaleDegree.IV:
        return 'IV';
      case ScaleDegree.V:
        return 'V';
      case ScaleDegree.VI:
        return 'VI';
      case ScaleDegree.VII:
        return 'VII';
    }
  }

  int get degree {
    switch (this) {
      case ScaleDegree.I:
        return 1;
      case ScaleDegree.II:
        return 2;
      case ScaleDegree.III:
        return 3;
      case ScaleDegree.IV:
        return 4;
      case ScaleDegree.V:
        return 5;
      case ScaleDegree.VI:
        return 6;
      case ScaleDegree.VII:
        return 7;
    }
  }

  static ScaleDegree fromInt(int degree) {
    switch (degree) {
      case 1:
        return ScaleDegree.I;
      case 2:
        return ScaleDegree.II;
      case 3:
        return ScaleDegree.III;
      case 4:
        return ScaleDegree.IV;
      case 5:
        return ScaleDegree.V;
      case 6:
        return ScaleDegree.VI;
      case 7:
        return ScaleDegree.VII;
      default:
        return ScaleDegree.I;
    }
  }

  static ScaleDegree fromString(String degree) {
    switch (degree.toUpperCase()) {
      case 'I':
        return ScaleDegree.I;
      case 'II':
        return ScaleDegree.II;
      case 'III':
        return ScaleDegree.III;
      case 'IV':
        return ScaleDegree.IV;
      case 'V':
        return ScaleDegree.V;
      case 'VI':
        return ScaleDegree.VI;
      case 'VII':
        return ScaleDegree.VII;
      default:
        return ScaleDegree.I;
    }
  }
}