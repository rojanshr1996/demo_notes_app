import 'package:demo_app_bloc/view/posts/posts_bloc_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Floating button teset', (WidgetTester tester) async {
    // find all widgets needed
    final buttonkey = find.byKey(const ValueKey("reloadButton"));

    //execute the actual test
    await tester.pumpWidget(const MaterialApp(home: PostsBlocScreen(title: "Flutter Bloc")));
    await tester.tap(buttonkey);
    await tester.pump();

    //check outputs
    expect(find.byWidget(const CircularProgressIndicator()), findsOneWidget);
  });
}
