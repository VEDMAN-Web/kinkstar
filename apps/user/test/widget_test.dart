import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_user/src/app.dart';

void main() {
  testWidgets('placeholder home renders config through the user theme', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: UserApp()));
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsWidgets);
    expect(find.text('Find someone to talk to'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);
    expect(find.text('Maintenance off'), findsOneWidget);
    expect(find.text('Match'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);
  });

  test('app assets do not include the design folder', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final ui = File('../../packages/ui/pubspec.yaml').readAsStringSync();
    expect(pubspec.contains('design/'), isFalse);
    expect(ui.contains('design/'), isFalse);
  });
}
