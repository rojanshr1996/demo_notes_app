// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:demo_app_bloc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Floating button teset', (WidgetTester tester) async {
    // find all widgets needed
    final buttonkey = find.byKey(const ValueKey("reloadButton"));

    //execute the actual test
    await tester.pumpWidget(const MyApp());
    await tester.tap(buttonkey);
    await tester.pump();

    //check outputs
    expect(find.byWidget(const Center(child: CircularProgressIndicator())), findsNothing);
  });
}
