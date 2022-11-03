import 'package:bloc_todo_app/core/model/post.dart';
import 'package:equatable/equatable.dart';

enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  final List<Post> posts;
  final bool hasReachedMax;
  final PostStatus status;

  const PostState({
    this.posts = const <Post>[],
    this.hasReachedMax = false,
    this.status = PostStatus.initial,
  });
  @override
  List<Object?> get props => [
        posts,
        hasReachedMax,
        status,
      ];

  PostState copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
    PostStatus? status,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }
}
