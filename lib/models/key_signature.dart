import 'note.dart';

enum KeyType {
  major,
  minor
}

extension KeyTypeExtension on KeyType {
  String get displayName {
    switch (this) {
      case KeyType.major:
        return '大调';
      case KeyType.minor:
        return '小调';
    }
  }
}

class KeySignature {
  final NoteName root;
  final KeyType type;

  KeySignature({required this.root, required this.type});

  String get displayName => '${root.displayName} ${type.displayName}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeySignature &&
        other.root == root &&
        other.type == type;
  }

  @override
  int get hashCode => root.hashCode ^ type.hashCode;
}