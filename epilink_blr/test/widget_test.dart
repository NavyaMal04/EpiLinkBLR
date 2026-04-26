import 'package:flutter_test/flutter_test.dart';
import 'package:epilink_blr/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EpiLinkApp());
  });
}
