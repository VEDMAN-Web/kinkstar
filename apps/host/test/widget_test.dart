import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_host/src/app.dart';

void main() {
  testWidgets('placeholder home renders config through the host theme', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: HostApp()));
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsWidgets);
    expect(find.text('Find someone to talk to'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
  });
}
