import 'package:bloc_todo_app/core/model/post.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text(
          post.id.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
        title: Text(post.title),
        isThreeLine: true,
        subtitle: Text(post.body),
      ),
    );
  }
}
