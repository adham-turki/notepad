class Note {
  final int? id;
  final String title;
  final String content;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String color;
  final bool isImportant;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.color = '#FFFFFF',
    this.isImportant = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'color': color,
      'is_important': isImportant ? 1 : 0,
    };
  }

  // Legacy map without is_important field for compatibility
  Map<String, dynamic> toLegacyMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'color': color,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt(),
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      userId: map['user_id']?.toInt() ?? 0,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'].toString())
          : DateTime.now(),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at'].toString())
          : DateTime.now(),
      color: map['color']?.toString() ?? '#FFFFFF',
      isImportant: _parseBool(map['is_important']),
    );
  }

  // Helper method to safely parse boolean values
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? color,
    bool? isImportant,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      color: color ?? this.color,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
