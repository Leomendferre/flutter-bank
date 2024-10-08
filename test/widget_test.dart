import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(BankApp());

    // Verify that our dashboard shows the correct title.
    expect(find.text('Dashboard'), findsOneWidget);

    // Verify that we have two buttons: CONTATOS and TRANSFERÊNCIA.
    expect(find.text('CONTATOS'), findsOneWidget);
    expect(find.text('TRANSFERÊNCIA'), findsOneWidget);

    // Tap the CONTATOS button and trigger a frame.
    await tester.tap(find.text('CONTATOS'));
    await tester.pumpAndSettle();

    // Verify that we've navigated to the Lista de Contatos screen.
    expect(find.text('Lista de Contatos'), findsOneWidget);

    // Navigate back to the Dashboard
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Tap the TRANSFERÊNCIA button and trigger a frame.
    await tester.tap(find.text('TRANSFERÊNCIA'));
    await tester.pumpAndSettle();

    // Verify that we've navigated to the Transferências screen.
    expect(find.text('Transferências'), findsOneWidget);
  });
}
