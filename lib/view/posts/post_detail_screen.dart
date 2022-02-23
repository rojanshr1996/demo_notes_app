import 'package:demo_app_bloc/model/model.dart';
import 'package:demo_app_bloc/view/route/routes.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Posts post;
  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(post.body),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.anotherPage,
                          arguments: ScreenArguments(title: "NewTitle", id: 1));
                    },
                    child: const Text("Another Page"),
                  ),
                  // TextButton(onPressed: () {}, child: const Text("Another Text"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final int id;

  ScreenArguments({required this.title, required this.id});
}
