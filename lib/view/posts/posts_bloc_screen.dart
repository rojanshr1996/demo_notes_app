import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_bloc.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_event.dart';
import 'package:demo_app_bloc/bloc/authBloc/auth_state.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_event.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_state.dart';
import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/view/auth/login_screen.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/default_loading_screen.dart';
import 'package:demo_app_bloc/widgets/no_data_widget.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:demo_app_bloc/widgets/sliver_header_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsBlocScreen extends StatefulWidget {
  const PostsBlocScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PostsBlocScreen> createState() => _PostsBlocScreenState();
}

class _PostsBlocScreenState extends State<PostsBlocScreen> {
  double top = 0.0;

  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => 120;

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset = _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
          () => _controller.animateTo(snapOffset, duration: const Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cDarkBlue,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          debugPrint("State has changed");
          if (state is AuthStateLoggedOut) {
            Utilities.removeStackActivity(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          return BlocConsumer<PostsBloc, PostsState>(
            listener: (context, state) {
              debugPrint("State has changed");
              if (state is LoadedPostState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: AppColors.cDarkBlueAccent,
                  content: Text("Posts loaded", style: CustomTextStyle.subtitleTextLight),
                  duration: Duration(seconds: 1),
                ));
              }
            },
            builder: (context, state) {
              if (state is LoadingPostState) {
                return DefaultLoadingScreen(maxHeight: maxHeight, minHeight: minHeight, fromPosts: true);
              } else if (state is LoadedPostState) {
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (_) {
                    _snapAppbar();
                    return false;
                  },
                  child: CupertinoScrollbar(
                    controller: _controller,
                    child: CustomScrollView(
                      controller: _controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          stretch: true,
                          centerTitle: false,
                          flexibleSpace: SliverHeaderText(
                            maxHeight: maxHeight,
                            minHeight: minHeight,
                            notesLength: state.posts!.length,
                            imagePath: "assets/postImage.png",
                            fromPost: true,
                          ),
                          expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
                          actions: [
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
                                BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
                              },
                              icon: const Icon(Icons.logout),
                            ),
                          ],
                        ),
                        if (state.posts!.isNotEmpty)
                          PostsList(posts: state.posts ?? [])
                        else
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: NoDataWidget(title: "No data"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              } else if (state is FailedLoadPostState) {
                return Center(
                  child: NoDataWidget(title: "Error occured: ${state.error}"),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({Key? key, required this.posts}) : super(key: key);

  final List<Posts> posts;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                color: AppColors.cDarkBlueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  onTap: () {
                    debugPrint(posts[index].title);
                    Navigator.pushNamed(context, Routes.postDetail, arguments: posts[index]);
                  },
                  title: Text(
                    posts[index].title,
                    style: CustomTextStyle.subtitleTextLight,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      posts[index].body,
                      style: CustomTextStyle.bodyTextLight.copyWith(color: AppColors.cDarkBlueLight),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: posts.length,
        ),
      ),
    );
  }
}
