class Tag {
  final int? id;
  final String name;

  const Tag({this.id, required this.name});

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'name': name,
      };

  factory Tag.fromMap(Map<String, Object?> map) => Tag(
        id: map['id'] as int?,
        name: map['name'] as String,
      );
}
