import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  TaskModel copyWith({String? id, String? title, bool? isCompleted, DateTime? createdAt}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object?> get props => [id, title, isCompleted, createdAt];
}
