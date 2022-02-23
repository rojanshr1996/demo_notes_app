import 'package:demo_app_bloc/cubit/post_cubit.dart';
import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/view/posts/posts_bloc_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    // context.read<PostCubit>().getPosts();
    final postCubit = BlocProvider.of<PostCubit>(context);
    postCubit.getPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const PostsBlocScreen(title: "Bloc instead of cubit"))),
        // onPressed: () => postCubit.clearPosts(),
        child: const Icon(Icons.clear),
      ),
      body: Center(
        child: BlocBuilder<PostCubit, List<Posts>?>(
          builder: (context, posts) {
            if (posts == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (posts.isEmpty) {
              return const Center(
                child: Text("No posts available"),
              );
            }
            return PostsList(posts: posts);
          },
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({Key? key, required this.posts}) : super(key: key);

  final List<Posts> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(posts[index].title),
            subtitle: Text(posts[index].body),
          ),
        );
      },
    );
  }
}
