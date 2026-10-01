import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medialog/main.dart';

void main() {
  testWidgets('MediaLog smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MediaLogApp()));
    expect(find.text('MediaLog'), findsOneWidget);
  });
}
