import 'package:flutter_test/flutter_test.dart';

import 'package:uas_pariwisata/main.dart';

void main() {
  testWidgets('menampilkan dashboard sistem informasi pariwisata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TourismApp());

    expect(find.text('SIP Benang Stokel'), findsOneWidget);
    expect(find.text('Booking Sekarang'), findsOneWidget);
    expect(find.text('Ringkasan Sistem'), findsOneWidget);
    expect(find.text('Informasi Kunjungan'), findsWidgets);
  });
}
