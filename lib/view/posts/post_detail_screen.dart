import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/utils/app_colors.dart';
import 'package:demo_app_bloc/utils/custom_text_style.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Posts post;
  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.cDarkBlue,
        // appBar: AppBar(
        //   backgroundColor: AppColors.cDarkBlue,
        //   title: Text(post.title),
        // ),
        body: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: AppColors.cDarkBlueAccent),
                  title: Text(
                    post.title,
                    style: CustomTextStyle.bodyTextLight
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.cDarkBlueLight),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                ),
                expandedHeight: 150 + MediaQuery.of(context).padding.top,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:
                          Text(post.body, style: CustomTextStyle.largeTextLight.copyWith(fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              )
            ],
          ),
        )

        //  Center(
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.all(20.0),
        //         child: Text(post.body),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(20),
        //         child: ButtonBar(
        //           alignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             ElevatedButton(
        //               onPressed: () {
        //                 Navigator.pushNamed(context, Routes.anotherPage,
        //                     arguments: ScreenArguments(title: "NewTitle", id: 1));
        //               },
        //               child: const Text("Another Page"),
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        );
  }
}

class ScreenArguments {
  final String title;
  final int id;

  ScreenArguments({required this.title, required this.id});
}
