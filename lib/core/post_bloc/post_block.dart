import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_todo_app/core/model/post.dart';
import 'package:bloc_todo_app/core/post_bloc/post_event.dart';
import 'package:bloc_todo_app/core/post_bloc/post_state.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

typedef HttpClient = http.Client;
const postLimit = 20;
const _postDuration = Duration(milliseconds: 100);

EventTransformer<T> postDroppable<T>(Duration duration) {
  return (events, mapper) {
    return droppable<T>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required HttpClient client})
      : _client = client,
        super(
          const PostState(),
        ) {
    on<PostFetched>(_onPostFetched, transformer: postDroppable(_postDuration));
  }

  final HttpClient _client;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    try {
      if (state.hasReachedMax) return;
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      final posts = await _fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await _client.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$postLimit'));
    if (response.statusCode == 200) {
      final posts = jsonDecode(response.body) as List;
      return posts.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Error fetching posts');
    }
  }
}
