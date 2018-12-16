import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vibration_example/main.dart';

void main() {
  testWidgets('Buttons rendered', (WidgetTester tester) async {
    await tester.pumpWidget(VibratingApp());

    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is RaisedButton,
      ),
      findsNWidgets(3),
    );
  });
}
