class DocumentModel {
  final String id;
  final String uid;
  final String title;
  final List<dynamic> content;
  final DateTime createdAt;

  const DocumentModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['_id'],
      uid: json['uid'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.fromMicrosecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DocumentModel copyWith({
    String? id,
    String? uid,
    String? title,
    List<dynamic>? content,
    DateTime? createdAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
