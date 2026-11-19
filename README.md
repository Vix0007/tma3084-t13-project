# VanQ – Flutter app (from the VanQ Prototype – T13 Figma file)

A UI-only Flutter app built from your Figma screens. It uses sample data and has no backend yet.

## Run it

You need the Flutter SDK (3.19 or newer).

```bash
cd vanq
flutter pub get
flutter run -d chrome     # or just `flutter run` for a phone/emulator
```

The `android/`, `ios/` and `web/` folders are already set up.

## Images and icons

- `assets/images/` holds the real Figma logo (`vanq_logo.png`) and van photos
  (`van_hiace.png`, `van_foton.png`).
- `assets/icons/` holds the Figma SVG icons: bottom nav (normal + `_active`), back arrow,
  checkbox, chevron, and the small calendar/pin icons on cards. They are drawn with
  `flutter_svg`. A few small icons (van, person, document, upload, info) are still Material icons.

## Prototype flow

**Login (UI-01)**: **Sign In** or **Customer** opens the customer app. **Driver** and **Admin** open those apps.

**Customer**
- Home (UI-02): tap an available van to open the Booking form (UI-03).
- Booking form: **Continue** is enabled once you tick the licence box (self-drive) or pick **With driver**, which adds the RM 150 driver fee.
- **Get AI place ideas** opens the AI suggestions sheet (UI-05). Every second time you open it, it shows the "fallback" state (error + Retry), so you can demo both designs.
- Upload + summary (UI-04): tap **Upload** on the rental form and **Submit booking** becomes enabled. That opens Booking submitted.
- Bookings (UI-06) and Profile use the bottom navigation.

**Driver**
- Trips (UI-07): **Start trip** switches the card to Ongoing. **End trip** asks for confirmation, then moves it to Completed.
- Earnings and Profile use the bottom navigation.

**Admin**
- Dashboard (UI-08): tap a booking to open Booking review (UI-11). Tap the **SB** avatar to open the admin profile.
- The **Bookings** tab opens Booking review for the first booking awaiting review, as in the Figma prototype.
- Booking review: verify the documents and tick **Deposit received** to enable **Confirm booking**. **Assign van & driver** opens UI-09.
- Income (UI-10): the October tab uses sample numbers.

## Project structure

```
lib/
  main.dart                 app entry + navigation helpers
  theme/                    colours, Inter text styles, theme (from Figma variables)
  data/sample_data.dart     all sample content from the Figma screens
  widgets/                  Figma components: Button, Text Field, Chip, Status Badge,
                            Info Row, Booking/Van/Trip cards, glass bottom nav, etc.
  screens/auth/             UI-01 Login
  screens/customer/         UI-02 to UI-06 + Booking submitted
  screens/driver/           UI-07 Trip schedule, Earnings
  screens/admin/            UI-08 to UI-11
  screens/shared/           Profile (Customer / Driver / Admin)
```

## Notes

- Fonts: Inter is loaded with `google_fonts`, so the first launch needs internet. To bundle the font offline, download Inter, add it under `fonts:` in `pubspec.yaml`, and set `GoogleFonts.config.allowRuntimeFetching = false`.
- Profile text for all three roles matches the Figma screens (`lib/screens/shared/profile_screen.dart`).
- Top spacing follows Figma (56px, 96px on Login / Booking submitted) in a browser; on a phone the
  status bar height is added on top.
- File upload is simulated. For real uploads, add the `file_picker` or `image_picker` package in `upload_summary_screen.dart`.
