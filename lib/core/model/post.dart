import 'package:equatable/equatable.dart';

typedef JsonMap = Map<String, dynamic>;

class Post extends Equatable {
  final int id;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(JsonMap json) => Post(
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  @override
  List<Object?> get props => [id, title, body];
}
