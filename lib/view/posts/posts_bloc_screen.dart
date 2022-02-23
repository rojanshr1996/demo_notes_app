import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_event.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_state.dart';
import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsBlocScreen extends StatefulWidget {
  const PostsBlocScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PostsBlocScreen> createState() => _PostsBlocScreenState();
}

class _PostsBlocScreenState extends State<PostsBlocScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: [
          IconButton(
            onPressed: () {
              debugPrint("OK");
              final postBloc = BlocProvider.of<PostsBloc>(context);
              postBloc.add(LoadPostEvent());
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ]),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint("State has changed");
            if (state is UnAuthenticated) {
              Utilities.removeStackActivity(context, const LoginScreen());
            }
          },
          builder: (context, state) {
            return BlocConsumer<PostsBloc, PostsState>(
              listener: (context, state) {
                debugPrint("State has changed");
                if (state is LoadedPostState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Posts loaded"),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
              builder: (context, state) {
                if (state is LoadingPostState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedPostState) {
                  return PostsList(posts: state.posts ?? []);
                } else if (state is FailedLoadPostState) {
                  return Center(
                    child: Text("Error occured: ${state.error}"),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ));
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
            onTap: () {
              debugPrint(posts[index].title);
              Navigator.pushNamed(context, Routes.postDetail, arguments: posts[index]);
            },
            title: Text(posts[index].title),
            subtitle: Text(posts[index].body),
          ),
        );
      },
    );
  }
}
