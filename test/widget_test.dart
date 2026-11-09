// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ngo_donation_transparency_portal/main.dart';

void main() {
  testWidgets('bottom navigation opens all portal screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DonationPortalApp());

    expect(find.text('NGO Donation\nTransparency Portal'), findsOneWidget);
    expect(find.text('₹50,000'), findsOneWidget);

    await tester.tap(find.text('Donations').last);
    await tester.pumpAndSettle();
    expect(find.text('Donation records'), findsOneWidget);
    expect(find.text('Aarav Sharma'), findsOneWidget);

    await tester.tap(find.text('Funds'));
    await tester.pumpAndSettle();
    expect(find.text('Food Distribution'), findsOneWidget);
    expect(find.text('Total amount utilized'), findsOneWidget);

    await tester.tap(find.text('Activities'));
    await tester.pumpAndSettle();
    expect(find.text('Medical Camps'), findsOneWidget);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('Why transparency matters'), findsOneWidget);
    expect(find.text('Contact (sample details)'), findsOneWidget);
  });

  testWidgets('donation form validates and updates the total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DonationPortalApp());

    await tester.tap(find.text('Donations').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('addDonationButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('saveDonationButton')));
    await tester.pumpAndSettle();
    expect(find.text('Enter the donor name'), findsOneWidget);
    expect(find.text('Please complete all required fields.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('donorNameField')),
      'Test Donor',
    );
    await tester.enterText(
      find.byKey(const ValueKey('donationAmountField')),
      '500',
    );
    await tester.enterText(
      find.byKey(const ValueKey('donationPurposeField')),
      'School supplies',
    );
    await tester.tap(find.byKey(const ValueKey('saveDonationButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Test Donor'), findsOneWidget);
    expect(find.text('Donation added successfully.'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('₹50,500'), findsOneWidget);
    expect(
      find.text('₹30,000 utilized out of ₹50,500 received'),
      findsOneWidget,
    );
  });
}
