/// Sample data copied from the VanQ Figma prototype.
/// Replace with real API / database calls later.
library;

enum BookingStatus { pending, confirmed, ongoing, completed, cancelled }

enum VanState { available, booked, onTrip, maintenance }

class Van {
  const Van({
    required this.model,
    required this.plate,
    required this.seats,
    required this.price,
    required this.image,
    this.state = VanState.available,
  });

  final String model;
  final String plate;
  final String seats;
  final double price;
  final String image;
  final VanState state;

  String get details => '$seats · $plate';
}

const vans = <Van>[
  Van(
    model: 'Toyota Hiace 2023',
    plate: 'QSA 1234',
    seats: '12 seats',
    price: 350,
    image: 'assets/images/van_hiace.png',
  ),
  Van(
    model: 'Foton View CS2 2024',
    plate: 'QSB 5678',
    seats: 'Up to 18 seats',
    price: 320,
    image: 'assets/images/van_foton.png',
  ),
  Van(
    model: 'Toyota Hiace 2024',
    plate: 'QSC 2468',
    seats: '12 seats',
    price: 300,
    image: 'assets/images/van_hiace.png',
  ),
  Van(
    model: 'Foton View CS2 2025',
    plate: 'QSD 1357',
    seats: 'Up to 18 seats',
    price: 280,
    image: 'assets/images/van_foton.png',
    state: VanState.booked,
  ),
];

const destinations = <String>[
  'Bako National Park',
  'Kuching City',
  'Santubong',
  'Semenggoh',
  'Annah Rais',
  'Damai Beach',
];

const tripTypes = <String>['Nature', 'Family', 'Culture', 'Adventure', 'Food'];

class PlaceIdea {
  const PlaceIdea(this.name, this.category, this.reason);
  final String name;
  final String category;
  final String reason;
}

const aiPlaceIdeas = <PlaceIdea>[
  PlaceIdea(
    'Bako National Park',
    'Nature · 45 min from Kuching',
    'Easy jungle trails and proboscis monkeys, a good fit for a group of 8 on a 3-day trip.',
  ),
  PlaceIdea(
    'Semenggoh Nature Reserve',
    'Wildlife · 30 min from Kuching',
    'Watch orangutans at the 9 AM feeding. Short, flat walk that suits all ages.',
  ),
  PlaceIdea(
    'Santubong Peninsula',
    'Beach & food · 35 min from Kuching',
    'Sunset at Damai Beach and a seafood dinner at Buntal on your last evening.',
  ),
];

class BookingInfo {
  const BookingInfo({
    required this.title,
    required this.ref,
    required this.dates,
    required this.destination,
    required this.note,
    required this.status,
  });

  final String title;
  final String ref;
  final String dates;
  final String destination;
  final String note;
  final BookingStatus status;
}

const customerCurrentBookings = <BookingInfo>[
  BookingInfo(
    title: 'Toyota Hiace 2023',
    ref: 'VQ-2026-0012',
    dates: '10 Dec, 9:00 AM → 12 Dec, 6:00 PM',
    destination: 'Bako National Park · Self-drive',
    note: 'Awaiting document check and deposit',
    status: BookingStatus.pending,
  ),
  BookingInfo(
    title: 'Foton View CS2 2024',
    ref: 'VQ-2026-0011',
    dates: '20 Dec, 8:00 AM → 21 Dec, 5:00 PM',
    destination: 'Santubong · With driver',
    note: 'Action needed: upload your IC again (photo is blurry)',
    status: BookingStatus.cancelled, // used for the red "action needed" note
  ),
  BookingInfo(
    title: 'Toyota Hiace 2024',
    ref: 'VQ-2026-0009',
    dates: '28 Nov, 9:00 AM → 29 Nov, 6:00 PM',
    destination: 'Semenggoh · With driver',
    note: 'Documents verified · Driver: Ahmad',
    status: BookingStatus.confirmed,
  ),
];

const customerPastBookings = <BookingInfo>[
  BookingInfo(
    title: 'Foton View CS2 2025',
    ref: 'VQ-2026-0003',
    dates: '2 Nov, 9:00 AM → 3 Nov, 6:00 PM',
    destination: 'Kuching City · Self-drive',
    note: 'Trip completed · Tap to rate and review',
    status: BookingStatus.completed,
  ),
];

const adminReviewBookings = <BookingInfo>[
  BookingInfo(
    title: 'Lee Wei Ming · Foton View CS2 2024',
    ref: 'VQ-2026-0014 · With driver · 10 people',
    dates: '15 Dec, 8:00 AM → 15 Dec, 6:00 PM',
    destination: 'Kuching City tour',
    note: '1 document to verify · deposit not yet received',
    status: BookingStatus.pending,
  ),
  BookingInfo(
    title: 'Muhammad Izzat · Toyota Hiace 2023',
    ref: 'VQ-2026-0012 · Self-drive · 8 people',
    dates: '10 Dec, 9:00 AM → 12 Dec, 6:00 PM',
    destination: 'Bako National Park',
    note: '2 documents to verify · deposit not yet received',
    status: BookingStatus.pending,
  ),
];

class DriverTrip {
  DriverTrip({
    required this.title,
    required this.ref,
    required this.dates,
    required this.van,
    required this.customer,
    required this.pickup,
    required this.startsOn,
    this.canStart = false,
    this.status = BookingStatus.confirmed,
  });

  final String title;
  final String ref;
  final String dates;
  final String van;
  final String customer;
  final String pickup;
  final String startsOn;
  final bool canStart;
  BookingStatus status;
}

List<DriverTrip> buildDriverTrips() => [
      DriverTrip(
        title: 'Semenggoh Nature Reserve',
        ref: 'VQ-2026-0009',
        dates: '28 Nov, 9:00 AM → 29 Nov, 6:00 PM',
        van: 'Toyota Hiace 2024 · QSC 2468',
        customer: 'Muhammad Izzat · 8 people · 012-345 6789',
        pickup: 'Pickup: Van Sewa Samariang base',
        startsOn: '28 Nov',
        canStart: true,
      ),
      DriverTrip(
        title: 'Kuching City tour',
        ref: 'VQ-2026-0014',
        dates: '15 Dec, 8:00 AM → 15 Dec, 6:00 PM',
        van: 'Foton View CS2 2024 · QSB 5678',
        customer: 'Lee Wei Ming · 10 people · 016-889 0021',
        pickup: 'Pickup: Kuching Waterfront Hotel',
        startsOn: '15 Dec',
      ),
    ];

class LedgerEntry {
  const LedgerEntry(this.title, this.subtitle, this.amount);
  final String title;
  final String subtitle;
  final String amount;
}

const driverCompletedTrips = <LedgerEntry>[
  LedgerEntry('VQ-2026-0009 · Semenggoh', '29 Nov · Toyota Hiace 2024', 'RM 150.00'),
  LedgerEntry('VQ-2026-0006 · Bako National Park', '22 Nov · Toyota Hiace 2023', 'RM 150.00'),
  LedgerEntry('VQ-2026-0004 · Annah Rais', '8 Nov · Foton View CS2 2024', 'RM 150.00'),
];

const driverSalaries = <LedgerEntry>[
  LedgerEntry('Ahmad', '3 completed trips', 'RM 450.00'),
  LedgerEntry('Rahman', '1 completed trip', 'RM 150.00'),
];

const incomeLedger = <LedgerEntry>[
  LedgerEntry('VQ-2026-0009 · Toyota Hiace 2024', '29 Nov · Completed · with driver', 'RM 470.00'),
  LedgerEntry('VQ-2026-0008 · Toyota Hiace 2023', '25 Nov · Completed · self-drive', 'RM 350.00'),
  LedgerEntry('VQ-2026-0006 · Toyota Hiace 2023', '22 Nov · Completed · with driver', 'RM 650.00'),
  LedgerEntry('VQ-2026-0004 · Foton View CS2 2024', '8 Nov · Completed · with driver', 'RM 470.00'),
];

class FleetVan {
  const FleetVan(this.name, this.detail, this.state);
  final String name;
  final String detail;
  final VanState state;
}

const fleetToday = <FleetVan>[
  FleetVan('Toyota Hiace 2023', 'QSA 1234 · 12 seats', VanState.available),
  FleetVan('Foton View CS2 2024', 'QSB 5678 · up to 18 seats', VanState.available),
  FleetVan('Toyota Hiace 2024', 'QSC 2468 · 12 seats · Driver Ahmad', VanState.onTrip),
  FleetVan('Foton View CS2 2025', 'QSD 1357 · up to 18 seats', VanState.maintenance),
];

class SelectOption {
  const SelectOption(this.title, this.subtitle, {this.enabled = true});
  final String title;
  final String subtitle;
  final bool enabled;
}

const assignVanOptions = <SelectOption>[
  SelectOption('Foton View CS2 2024 · QSB 5678', 'Up to 18 seats · Free on 15 Dec'),
  SelectOption('Toyota Hiace 2023 · QSA 1234', '12 seats · Free on 15 Dec'),
  SelectOption('Toyota Hiace 2024 · QSC 2468', 'Booked 14–16 Dec · clash', enabled: false),
  SelectOption('Foton View CS2 2025 · QSD 1357', 'In maintenance · not available', enabled: false),
];

const assignDriverOptions = <SelectOption>[
  SelectOption('Rahman', 'Free on 15 Dec'),
  SelectOption('Ahmad', 'Assigned to VQ-2026-0013 on 15 Dec · clash', enabled: false),
];

/// Formats a number as "RM 350.00" (Figma rule CI-03: RM with 2 decimals).
String rm(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
  return 'RM $whole.${parts[1]}';
}
