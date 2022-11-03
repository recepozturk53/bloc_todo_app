import 'package:bloc_todo_app/core/post_bloc/post_block.dart';
import 'package:bloc_todo_app/core/post_bloc/post_event.dart';
import 'package:bloc_todo_app/core/post_bloc/post_state.dart';
import 'package:bloc_todo_app/views/pages/homepage/widgets/indicator_widget.dart';
import 'package:bloc_todo_app/views/pages/homepage/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => PostBloc(client: HttpClient())..add(const PostFetched()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (_isBottom) {
      context.read<PostBloc>().add(const PostFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: ((context, postState) {
            switch (postState.status) {
              case PostStatus.failure:
                return const Center(child: Text('failed to fetch posts'));
              case PostStatus.success:
                if (postState.posts.isEmpty) {
                  return const Center(child: Text('no posts'));
                }
                return ListView.builder(
                  itemCount: postState.hasReachedMax
                      ? postState.posts.length
                      : postState.posts.length + 1,
                  itemBuilder: (context, index) {
                    return index >= postState.posts.length
                        ? const IndicatorWidget()
                        : PostWidget(post: postState.posts[index]);
                  },
                  controller: _scrollController,
                );
              default:
                return Column(
                  children: const [
                    Text('Please Wait...'),
                    CircularProgressIndicator(),
                  ],
                );
            }
          }),
        ));
  }
}
