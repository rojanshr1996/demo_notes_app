import 'package:flutter/material.dart';

class AnotherPage extends StatelessWidget {
  final int data;
  final String title;
  const AnotherPage({Key? key, required this.data, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(14),
            child: Text("This is a test data for routing check purpose."),
          )
        ],
      ),
    );
  }
}
