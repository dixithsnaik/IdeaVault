class NotesModel {
  final String id;
  final String title;
  final String date;
  final String noteMessage;
  final String type;
  final String userName;

  NotesModel({
    required this.id,
    required this.title,
    required this.date,
    required this.noteMessage,
    required this.type,
    required this.userName,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'noteMessage': noteMessage,
      'type': type,
      'id': id,
      'userName': userName,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      noteMessage: map['noteMessage'],
      type: map['type'],
      userName: map['userName'],
    );
  }
  NotesModel copyWith({
    String? id,
    String? title,
    String? date,
    String? noteMessage,
    String? type,
    String? userName,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      noteMessage: noteMessage ?? this.noteMessage,
      type: type ?? this.type,
      userName: userName ?? this.userName,
    );
  }
}
