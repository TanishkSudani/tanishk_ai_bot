import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanishks_ai_bot/main.dart';
import 'package:tanishks_ai_bot/services/call_session_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TanishkAiBot());
    expect(find.byType(TanishkAiBot), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    CallSessionService().reset();
    await tester.pumpWidget(const SizedBox());
  });
}
