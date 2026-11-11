
import 'package:flutter_test/flutter_test.dart';
import 'package:siaga_sarpas_tuban/main.dart';

void main() {
  testWidgets('Aplikasi SIAGA Sarpras Tuban berhasil dibuat',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiagaSarprasApp());

    expect(find.byType(SiagaSarprasApp), findsOneWidget);
  });
}
