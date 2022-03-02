import 'package:custom_widgets/custom_widgets.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:demo_app_bloc/widgets/simple_circular_loader.dart';
import 'package:demo_app_bloc/widgets/sliver_header_text.dart';
import 'package:flutter/material.dart';

class DefaultLoadingScreen extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final bool fromPosts;
  final List<Widget>? actions;

  const DefaultLoadingScreen({
    Key? key,
    required this.maxHeight,
    required this.minHeight,
    this.fromPosts = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          centerTitle: false,
          flexibleSpace: fromPosts
              ? SliverHeaderText(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  imagePath: "assets/postImage.png",
                  fromPost: true,
                )
              : SliverHeaderText(maxHeight: maxHeight, minHeight: minHeight),
          expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
          actions: actions,
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: SimpleCircularLoader(),
          ),
        ),
      ],
    );
  }
}
