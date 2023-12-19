import 'package:atom_notifier/atom_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("AtomInputController: ", () {
    testWidgets(
      "sut should listen to changes on TextFormField",
      (tester) async {
        final controller = AtomInputController();
        String content = "";
        controller.listen((value) {
          content = value ?? "";
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextFormField(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), "Aserehê");
        await tester.pumpAndSettle();

        expect(content, "Aserehê");
      },
    );

    testWidgets(
      "sut should listen to changes on TextField",
      (tester) async {
        final controller = AtomInputController();
        String content = "";
        controller.listen((value) {
          content = value ?? "";
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), "Aserehê");
        await tester.pumpAndSettle();

        expect(content, "Aserehê");
      },
    );
  });
}
