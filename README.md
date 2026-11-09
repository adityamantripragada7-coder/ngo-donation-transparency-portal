# NGO Donation Transparency Portal

A beginner-friendly Flutter lab project that presents sample donations,
utilization categories, and NGO activities. It uses local Dart lists only: it
does not connect to a backend, database, API, or authentication service.

All records are illustrative examples, not verified real-world transactions.
Donations entered with the form stay in memory while the app is running and
reset when the app is restarted.

## Project structure

```text
ngo_donation_transparency_portal/
├── android/                 # Android application and Gradle files
├── lib/
│   └── main.dart            # Models, sample data, screens, and form
├── test/
│   └── widget_test.dart     # Navigation, validation, and totals tests
├── analysis_options.yaml    # Dart lint settings
├── pubspec.yaml             # Flutter package configuration
└── README.md
```

## Requirements

- Flutter SDK with Dart 3.7 or later
- VS Code with the Flutter and Dart extensions, or Android Studio
- An Android emulator or a USB-connected Android device

## Create and run

To create a fresh project with the same package name, run these commands in
the VS Code terminal:

```powershell
flutter create --project-name ngo_donation_transparency_portal --platforms=android ngo_donation_transparency_portal
cd ngo_donation_transparency_portal
```

To run this already-created project, open its folder in VS Code and run:

```powershell
flutter pub get
flutter devices
flutter run
```

Select an Android emulator or connected device if Flutter asks which device to
use. No extra packages or service credentials are required.

## Create a shareable web link

The project also supports Flutter Web, so you can publish a demo without an
Android SDK. Build it with:

```powershell
flutter build web --release
```

For a quick public demo, open [Netlify Drop](https://app.netlify.com/drop),
sign in or create a free account if prompted, then upload the contents of
`build/web` (or a ZIP of those files). Netlify will provide a public URL to
copy into your submission. The current build is also packaged at
`build/ngo-donation-transparency-portal-web.zip`.

The public demo contains only illustrative sample data and has no backend.
Donations entered by a visitor stay in that browser session and are not saved.

## Check and test

```powershell
dart format lib test
flutter analyze
flutter test
```

The widget tests cover screen navigation, required-field validation, saving a
donation, and recalculating the dashboard totals.

## Try the app manually

1. On Home, confirm total donations are ₹50,000, utilized funds are ₹30,000,
   remaining funds are ₹20,000, and the utilization bar shows 60%.
2. Visit Donations and confirm the five example records. Choose **Add
   Donation**, try to save the blank form, then complete each field and save.
3. Check that the new entry appears and the dashboard's total and remaining
   funds increase by the donated amount.
4. Visit Funds and confirm the four categories add up to ₹30,000.
5. Visit Activities to see the sample descriptions and statuses, then About
   to read the portal purpose and sample contact details.
6. Restart the app to confirm that a newly entered donation is not persisted.

## College lab viva explanation

This app uses Flutter Material widgets and a `StatefulWidget` to present five
screens. Sample donation, spending, and activity records are Dart lists. The
donation form uses a `Form` with validators; a valid entry is added to the
donations list with `setState`, which rebuilds the interface. Dashboard totals
are calculated from the donation and utilization lists, and the fund progress
bar visualizes the utilized share. Data is only held in memory, so it resets
on restart; the displayed sample records do not claim to be real or verified.

### Viva questions and answers

**1. What is Flutter?**  
Flutter is Google's UI toolkit for building applications from a shared Dart
codebase.

**2. Why does this app use `StatefulWidget`?**  
The donation list and selected navigation screen can change while the app is
running, so their state must be retained and redrawn.

**3. What does `setState` do here?**  
It tells Flutter that the donation list changed and that dependent widgets,
including dashboard totals, should be rebuilt.

**4. How is donation input validated?**  
The `Form` checks that the donor name and purpose are not blank and that the
amount is a positive number before saving.

**5. How are the dashboard totals calculated?**  
Donation amounts are summed from the donation list. Utilized funds are summed
from the four spending categories, and remaining funds are donations minus
utilization.

**6. Is the data saved permanently?**  
No. The project intentionally uses in-memory lists and has no database, so
user-added records disappear when the app restarts.

**7. Are the displayed donations verified?**  
No. They are illustrative sample data for a college demonstration, not
verified real-world transactions.
