import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const TourismApp());
}

class TourismApp extends StatelessWidget {
  const TourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0F766E);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watterfall Bookings',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD7E5E1)),
          ),
        ),
      ),
      home: const TourismShell(),
    );
  }
}

class TourismShell extends StatefulWidget {
  const TourismShell({super.key});

  @override
  State<TourismShell> createState() => _TourismShellState();
}

class _TourismShellState extends State<TourismShell> {
  static const _destinationName =
      'Air Terjun Benang Stokel dan Benang Kelambu';
  static const _destinationAddress =
      'Desa Aik Berik, Batukliang Utara, Lombok Tengah';
  static const _imageOptions = [
    ImageChoice(label: 'Benang Stokel', path: 'assets/images/Benang_Stokel.jpg'),
    ImageChoice(label: 'Air Terjun Stokel', path: 'assets/images/stokel.jpg'),
    ImageChoice(label: 'Benang Kelambu', path: 'assets/images/Benang_kelambu.jpg'),
    ImageChoice(label: 'Jalur Trekking', path: 'assets/images/treking.jpg'),
  ];
  static const _backgroundPresets = [
    BackgroundPreset(
      key: 'natural',
      label: 'Natural',
      icon: Icons.forest,
      baseColors: [
        Color(0xFFE4F7F2),
        Color(0xFFF7FBF9),
        Color(0xFFFFF7ED),
      ],
      washTop: Color(0xFFF7FBF9),
      washMiddle: Color(0xFFEFFAF7),
      washBottom: Color(0xFFFFF4E3),
      patternColor: Color(0xFF0F766E),
      accentColor: Color(0xFFF59E0B),
      waterColor: Color(0xFF0EA5E9),
    ),
    BackgroundPreset(
      key: 'bright',
      label: 'Cerah',
      icon: Icons.wb_sunny_outlined,
      baseColors: [
        Color(0xFFE0F2FE),
        Color(0xFFFFFBEB),
        Color(0xFFDCFCE7),
      ],
      washTop: Color(0xFFF0F9FF),
      washMiddle: Color(0xFFFFFBEB),
      washBottom: Color(0xFFEAFBF1),
      patternColor: Color(0xFF0369A1),
      accentColor: Color(0xFFF97316),
      waterColor: Color(0xFF22C55E),
    ),
    BackgroundPreset(
      key: 'sunset',
      label: 'Senja',
      icon: Icons.wb_twilight,
      baseColors: [
        Color(0xFFFFEDD5),
        Color(0xFFFFF7ED),
        Color(0xFFDDF7F0),
      ],
      washTop: Color(0xFFFFF7ED),
      washMiddle: Color(0xFFFFEDD5),
      washBottom: Color(0xFFE6FFFA),
      patternColor: Color(0xFFB45309),
      accentColor: Color(0xFF0F766E),
      waterColor: Color(0xFF0284C7),
    ),
    BackgroundPreset(
      key: 'deep',
      label: 'Dramatis',
      icon: Icons.landscape_outlined,
      baseColors: [
        Color(0xFFD9F99D),
        Color(0xFFE0F2FE),
        Color(0xFFFFF7ED),
      ],
      washTop: Color(0xFFF8FAFC),
      washMiddle: Color(0xFFE0F2FE),
      washBottom: Color(0xFFFFF7ED),
      patternColor: Color(0xFF14532D),
      accentColor: Color(0xFF7C3AED),
      waterColor: Color(0xFF0891B2),
    ),
  ];
  static const _statusOptions = [
    'Menunggu',
    'Disetujui',
    'Selesai',
    'Dibatalkan',
  ];

  final _bookingNameController = TextEditingController();
  final _bookingPhoneController = TextEditingController();
  final _reviewNameController = TextEditingController();
  final _reviewCommentController = TextEditingController();
  final _adminUsernameController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  late final TextEditingController _openHoursController;
  late final TextEditingController _announcementController;
  late final TextEditingController _adminWhatsAppController;
  late List<PackageOption> _packages;
  late List<Booking> _bookings;
  late List<GalleryItem> _galleryItems;
  late List<VisitorReview> _reviews;

  int _selectedIndex = 0;
  int _domesticTicket = 10000;
  int _foreignTicket = 25000;
  int _motorParking = 3000;
  int _carParking = 10000;
  int _bookingSequence = 3;
  int _reviewSequence = 4;
  int _guestCount = 1;
  double _newReviewRating = 5;
  bool _adminLoggedIn = false;
  String _selectedPackageName = 'Tiket Mandiri';
  String _adminWhatsAppNumber = '6287748071872';
  String _backgroundImage = 'assets/images/Benang_kelambu.jpg';
  String _heroImage = 'assets/images/Benang_Stokel.jpg';
  String _backgroundPresetKey = 'natural';
  double _backgroundImageOpacity = 0.32;
  double _backgroundWashStrength = 0.82;
  bool _backgroundTextureEnabled = true;
  String _openHours = '08.00 - 17.00 WITA';
  String _announcement =
      'Jalur utama dibuka normal. Wisatawan disarankan memakai alas kaki anti slip.';
  DateTime _arrivalDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _openHoursController = TextEditingController(text: _openHours);
    _announcementController = TextEditingController(text: _announcement);
    _adminWhatsAppController =
        TextEditingController(text: _adminWhatsAppNumber);

    _galleryItems = const [
      GalleryItem(
        title: 'Benang Stokel',
        subtitle: 'Aliran bertingkat dengan kolam alami.',
        image: 'assets/images/stokel.jpg',
        icon: Icons.water,
        startColor: Color(0xFF0E7490),
        endColor: Color(0xFF67E8F9),
      ),
      GalleryItem(
        title: 'Benang Kelambu',
        subtitle: 'Tirai air tipis dari sela pepohonan.',
        image: 'assets/images/Benang_kelambu.jpg',
        icon: Icons.forest,
        startColor: Color(0xFF166534),
        endColor: Color(0xFF86EFAC),
      ),
      GalleryItem(
        title: 'Jalur Trekking',
        subtitle: 'Rute hijau menuju area air terjun.',
        image: 'assets/images/treking.jpg',
        icon: Icons.hiking,
        startColor: Color(0xFF92400E),
        endColor: Color(0xFFFBBF24),
      ),
    ];

    _packages = const [
      PackageOption(
        name: 'Guide Trekking',
        price: 55000,
        description: 'Pendamping lokal untuk jalur Stokel dan Kelambu.',
        icon: Icons.hiking,
        includes: ['Guide lokal', 'Rute trekking', 'Briefing keamanan'],
      ),
      PackageOption(
        name: 'Camping Alam',
        price: 150000,
        description: 'Area kemah dengan pendampingan pengelola.',
        icon: Icons.cabin,
        includes: ['Area camping', 'Pemandu area', 'Parkir malam'],
      ),
      PackageOption(
        name: 'Rombongan',
        price: 300000,
        description: 'Paket kunjungan kelompok sekolah, kantor, atau komunitas.',
        icon: Icons.groups,
        includes: ['Tiket 20 orang', 'Guide', 'Spot foto kelompok'],
      ),
      PackageOption(
        name: 'Wisata Edukasi',
        price: 75000,
        description: 'Pengenalan alam, konservasi, dan budaya lokal.',
        icon: Icons.school,
        includes: ['Materi edukasi', 'Guide', 'Sesi tanya jawab'],
      ),
    ];

    final now = DateTime.now();
    _bookings = [
      Booking(
        id: 1,
        visitorName: 'Renda Ayu',
        phone: '081234567890',
        arrivalDate: now.add(const Duration(days: 2)),
        guestCount: 4,
        packageName: 'Guide Trekking',
        totalPrice: 220000,
        status: 'Disetujui',
      ),
      Booking(
        id: 2,
        visitorName: 'Luis Pernando',
        phone: '087812341234',
        arrivalDate: now.add(const Duration(days: 5)),
        guestCount: 2,
        packageName: 'Tiket Mandiri',
        totalPrice: 20000,
        status: 'Menunggu',
      ),
    ];

    _reviews = const [
      VisitorReview(
        id: 1,
        visitorName: 'Pipit',
        rating: 5,
        comment: 'Air terjunnya indah, jalurnya sejuk, dan guide sangat ramah.',
      ),
      VisitorReview(
        id: 2,
        visitorName: 'Dimas',
        rating: 4,
        comment: 'Informasi tiket jelas. Area parkir dan jalur cukup tertata.',
      ),
      VisitorReview(
        id: 3,
        visitorName: 'Jingga',
        rating: 5,
        comment: 'Cocok untuk liburan keluarga dan foto alam.',
      ),
    ];
  }

  @override
  void dispose() {
    _bookingNameController.dispose();
    _bookingPhoneController.dispose();
    _reviewNameController.dispose();
    _reviewCommentController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    _openHoursController.dispose();
    _announcementController.dispose();
    _adminWhatsAppController.dispose();
    super.dispose();
  }

  List<NavigationDestination> get _navigationItems => const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: Icon(Icons.terrain_outlined),
          selectedIcon: Icon(Icons.terrain),
          label: 'Wisata',
        ),
        NavigationDestination(
          icon: Icon(Icons.confirmation_number_outlined),
          selectedIcon: Icon(Icons.confirmation_number),
          label: 'Tiket',
        ),
        NavigationDestination(
          icon: Icon(Icons.photo_library_outlined),
          selectedIcon: Icon(Icons.photo_library),
          label: 'Galeri',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_available_outlined),
          selectedIcon: Icon(Icons.event_available),
          label: 'Booking',
        ),
        NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      ];

  List<NavigationRailDestination> get _railItems => const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Beranda'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.terrain_outlined),
          selectedIcon: Icon(Icons.terrain),
          label: Text('Wisata'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.confirmation_number_outlined),
          selectedIcon: Icon(Icons.confirmation_number),
          label: Text('Tiket'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.photo_library_outlined),
          selectedIcon: Icon(Icons.photo_library),
          label: Text('Galeri'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.event_available_outlined),
          selectedIcon: Icon(Icons.event_available),
          label: Text('Booking'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: Text('Admin'),
        ),
      ];

  double get _averageRating {
    if (_reviews.isEmpty) {
      return 0;
    }
    final total = _reviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / _reviews.length;
  }

  int get _bookingRevenue => _bookings
      .where((booking) => booking.status != 'Dibatalkan')
      .fold<int>(0, (sum, booking) => sum + booking.totalPrice);

  BackgroundPreset get _selectedBackgroundPreset {
    return _backgroundPresets.firstWhere(
      (preset) => preset.key == _backgroundPresetKey,
      orElse: () => _backgroundPresets.first,
    );
  }

  List<String> get _bookablePackageNames => [
        'Tiket Mandiri',
        ..._packages.where((package) => package.isActive).map((package) => package.name),
      ];

  int _packagePrice(String name) {
    if (name == 'Tiket Mandiri') {
      return _domesticTicket;
    }

    return _packages
        .firstWhere(
          (package) => package.name == name,
          orElse: () => const PackageOption(
            name: 'Tiket Mandiri',
            price: 0,
            description: '',
            icon: Icons.confirmation_number,
            includes: [],
          ),
        )
        .price;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final page = KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: _buildSelectedPage(isWide),
        );

        return Scaffold(
          body: Row(
            children: [
              if (isWide) ...[
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _goToPage,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFE0F2F1),
                      foregroundColor: Color(0xFF0F766E),
                      child: Icon(Icons.water_drop),
                    ),
                  ),
                  destinations: _railItems,
                ),
                const VerticalDivider(width: 1, color: Color(0xFFD7E5E1)),
              ],
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: page,
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _goToPage,
                  labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                  destinations: _navigationItems,
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openAdminWhatsApp(),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Chat Admin'),
          ),
        );
      },
    );
  }

  Widget _buildSelectedPage(bool isWide) {
    return switch (_selectedIndex) {
      0 => _buildHomePage(isWide),
      1 => _buildDestinationPage(isWide),
      2 => _buildTicketsPage(isWide),
      3 => _buildGalleryPage(isWide),
      4 => _buildBookingPage(isWide),
      _ => _buildAdminPage(isWide),
    };
  }

  void _goToPage(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _pageFrame({
    required bool isWide,
    required List<Widget> children,
  }) {
    return Stack(
      children: [
        Positioned.fill(child: _buildPageBackground()),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 32 : 16,
              isWide ? 28 : 16,
              isWide ? 32 : 16,
              isWide ? 36 : 96,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 20),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageBackground() {
    return _buildBackgroundLayers(_selectedBackgroundPreset);
  }

  Widget _buildBackgroundLayers(BackgroundPreset preset) {
    final textureOpacity =
        (1 - _backgroundWashStrength + 0.32).clamp(0.14, 0.42).toDouble();

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: preset.baseColors,
                stops: const [0, 0.56, 1],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: _backgroundImageOpacity,
            child: Image.asset(
              _backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: preset.baseColors),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  preset.washTop.withAlpha(
                    _opacityAlpha(_backgroundWashStrength + 0.05),
                  ),
                  preset.washMiddle.withAlpha(
                    _opacityAlpha(_backgroundWashStrength),
                  ),
                  preset.washBottom.withAlpha(
                    _opacityAlpha(_backgroundWashStrength - 0.04),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  preset.waterColor.withAlpha(_opacityAlpha(0.08)),
                  Colors.transparent,
                  preset.accentColor.withAlpha(_opacityAlpha(0.1)),
                ],
                stops: const [0, 0.52, 1],
              ),
            ),
          ),
        ),
        if (_backgroundTextureEnabled)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: TourismBackgroundPainter(
                  preset: preset,
                  opacity: textureOpacity,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFE0F2F1),
          foregroundColor: Color(0xFF0F766E),
          child: Icon(Icons.water_drop),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIP Benang Stokel',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF123832),
                    ),
              ),
              Text(
                'Sistem Informasi Pariwisata Benang Stokel dan Benang Kelambu',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF5C6F6A),
                    ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            IconButton.filledTonal(
              tooltip: 'Chat admin WhatsApp',
              onPressed: () => _openAdminWhatsApp(),
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _goToPage(4),
              icon: const Icon(Icons.event_available),
              label: const Text('Booking'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHomePage(bool isWide) {
    return _pageFrame(
      isWide: isWide,
      children: [
        _buildHeroSection(isWide),
        const SizedBox(height: 18),
        ResponsiveGrid(
          minItemWidth: 220,
          children: [
            StatCard(
              icon: Icons.schedule,
              label: 'Jam buka',
              value: _openHours,
              color: const Color(0xFF0F766E),
            ),
            StatCard(
              icon: Icons.confirmation_number,
              label: 'Tiket mulai',
              value: rupiah(_domesticTicket),
              color: const Color(0xFFF59E0B),
            ),
            StatCard(
              icon: Icons.star,
              label: 'Rating',
              value: _averageRating.toStringAsFixed(1),
              color: const Color(0xFF2563EB),
            ),
            StatCard(
              icon: Icons.place,
              label: 'Lokasi',
              value: 'Aik Berik',
              color: const Color(0xFF7C3AED),
            ),
          ],
        ),
        const SizedBox(height: 28),
        SectionHeader(
          icon: Icons.info_outline,
          title: 'Ringkasan Sistem',
          subtitle:
              'Aplikasi ini mengikuti kebutuhan dokumen: informasi wisata, tiket, galeri, reservasi, ulasan, paket wisata, dan pengelolaan admin.',
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          minItemWidth: 250,
          children: [
            FeatureCard(
              icon: Icons.terrain,
              title: 'Profil Destinasi',
              body:
                  'Informasi umum, daya tarik, sejarah singkat, fasilitas, dan kondisi lingkungan wisata.',
              onTap: () => _goToPage(1),
            ),
            FeatureCard(
              icon: Icons.confirmation_number,
              title: 'Tiket dan Paket',
              body:
                  'Harga tiket, parkir, guide, camping, trekking, rombongan, dan wisata edukasi.',
              onTap: () => _goToPage(2),
            ),
            FeatureCard(
              icon: Icons.event_available,
              title: 'Reservasi Online',
              body:
                  'Pengunjung dapat mengisi data kunjungan, memilih paket, dan membuat booking.',
              onTap: () => _goToPage(4),
            ),
            FeatureCard(
              icon: Icons.rate_review,
              title: 'Review Pengunjung',
              body:
                  'Wisatawan dapat memberikan rating dan komentar sebagai masukan pengelola.',
              onTap: () => _goToPage(4),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _buildAnnouncementCard(),
      ],
    );
  }

  Widget _buildHeroSection(bool isWide) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Text(
            'Desa Aik Berik, Batukliang Utara, Lombok Tengah',
            style: TextStyle(
              color: Color(0xFF1D4ED8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Air Terjun Benang Stokel dan Benang Kelambu',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF123832),
                letterSpacing: 0,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pusat informasi digital untuk wisatawan dan pengelola: profil destinasi, harga tiket, jam operasional, galeri, reservasi, lokasi, ulasan, dan paket wisata tambahan.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.55,
                color: const Color(0xFF425B55),
              ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => _goToPage(4),
              icon: const Icon(Icons.event_available),
              label: const Text('Booking Sekarang'),
            ),
            OutlinedButton.icon(
              onPressed: () => _goToPage(2),
              icon: const Icon(Icons.confirmation_number),
              label: const Text('Lihat Tiket'),
            ),
            OutlinedButton.icon(
              onPressed: () => _openDestinationMap(directions: true),
              icon: const Icon(Icons.map),
              label: const Text('Buka Maps'),
            ),
            OutlinedButton.icon(
              onPressed: () => _openAdminWhatsApp(),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Chat Admin'),
            ),
          ],
        ),
      ],
    );

    final scene = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        _heroImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const ColoredBox(
            color: Color(0xFFE0F2F1),
            child: Center(child: Icon(Icons.image_not_supported_outlined)),
          );
        },
      ),
    );

    return Container(
      padding: EdgeInsets.all(isWide ? 24 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCDE8E1)),
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 6, child: textContent),
                const SizedBox(width: 26),
                Expanded(flex: 5, child: scene),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textContent,
                const SizedBox(height: 18),
                scene,
              ],
            ),
    );
  }

  Widget _buildDestinationPage(bool isWide) {
    return _pageFrame(
      isWide: isWide,
      children: [
        const SectionHeader(
          icon: Icons.terrain,
          title: 'Profil Destinasi',
          subtitle:
              'Informasi umum mengenai lokasi, daya tarik, sejarah singkat, dan layanan wisata alam.',
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          minItemWidth: 330,
          children: const [
            InfoPanel(
              title: 'Gambaran Umum',
              icon: Icons.landscape,
              body:
                  'Air Terjun Benang Stokel dan Benang Kelambu adalah destinasi alam di Lombok Tengah yang dikenal dengan udara sejuk, panorama hijau, dan aliran air bertingkat.',
            ),
            InfoPanel(
              title: 'Daya Tarik',
              icon: Icons.water,
              body:
                  'Pengunjung dapat menikmati air terjun, trekking ringan, spot foto alam, area istirahat, dan suasana hutan yang masih asri.',
            ),
            InfoPanel(
              title: 'Untuk Pengelola',
              icon: Icons.manage_accounts,
              body:
                  'Sistem membantu promosi destinasi, pencatatan reservasi, pengelolaan ulasan, pembaruan harga tiket, paket wisata, dan laporan.',
            ),
          ],
        ),
        const SizedBox(height: 28),
        const SectionHeader(
          icon: Icons.task_alt,
          title: 'Fasilitas dan Aktivitas',
          subtitle:
              'Informasi yang dibutuhkan calon pengunjung sebelum datang ke lokasi wisata.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            ChipItem(icon: Icons.local_parking, text: 'Area parkir'),
            ChipItem(icon: Icons.wc, text: 'Toilet umum'),
            ChipItem(icon: Icons.mosque, text: 'Mushola'),
            ChipItem(icon: Icons.restaurant, text: 'Warung lokal'),
            ChipItem(icon: Icons.hiking, text: 'Jalur trekking'),
            ChipItem(icon: Icons.camera_alt, text: 'Spot foto'),
            ChipItem(icon: Icons.support_agent, text: 'Guide lokal'),
            ChipItem(icon: Icons.groups, text: 'Wisata kelompok'),
            ChipItem(icon: Icons.cabin, text: 'Camping'),
          ],
        ),
        const SizedBox(height: 28),
        const SectionHeader(
          icon: Icons.map,
          title: 'Peta Lokasi Nyata',
          subtitle:
              'Buka lokasi wisata di Google Maps untuk melihat peta dan rute perjalanan langsung.',
        ),
        const SizedBox(height: 12),
        _buildLocationCard(isWide),
        const SizedBox(height: 28),
        ResponsiveGrid(
          minItemWidth: 320,
          children: [
            _buildAnnouncementCard(),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.dataset, color: Color(0xFF0F766E)),
                  const SizedBox(height: 12),
                  Text(
                    'Kebutuhan Data',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Data wisata, reservasi, galeri, ulasan, admin, harga tiket, paket wisata, dan status booking disimpan secara terpusat di aplikasi.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTicketsPage(bool isWide) {
    final ticketOptions = [
      TicketOption(
        name: 'Wisatawan Nusantara',
        price: _domesticTicket,
        note: 'Tiket masuk reguler',
        icon: Icons.person,
      ),
      TicketOption(
        name: 'Wisatawan Mancanegara',
        price: _foreignTicket,
        note: 'Tiket masuk internasional',
        icon: Icons.public,
      ),
      TicketOption(
        name: 'Parkir Motor',
        price: _motorParking,
        note: 'Sekali masuk',
        icon: Icons.two_wheeler,
      ),
      TicketOption(
        name: 'Parkir Mobil',
        price: _carParking,
        note: 'Sekali masuk',
        icon: Icons.directions_car,
      ),
    ];

    return _pageFrame(
      isWide: isWide,
      children: [
        const SectionHeader(
          icon: Icons.confirmation_number,
          title: 'Informasi Tiket',
          subtitle:
              'Rincian harga tiket, jam operasional, dan ketentuan kunjungan wisata.',
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          minItemWidth: 240,
          children: ticketOptions
              .map(
                (ticket) => TicketCard(ticket: ticket),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        SectionHeader(
          icon: Icons.card_travel,
          title: 'Paket Wisata Tambahan',
          subtitle:
              'Pilihan layanan guide, camping, trekking, dan wisata kelompok yang dapat dipesan pengunjung.',
          trailing: FilledButton.tonalIcon(
            onPressed: () => _goToPage(4),
            icon: const Icon(Icons.event_available),
            label: const Text('Pesan Paket'),
          ),
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          minItemWidth: 270,
          children: _packages
              .map(
                (package) => PackageCard(package: package),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildGalleryPage(bool isWide) {
    return _pageFrame(
      isWide: isWide,
      children: [
        const SectionHeader(
          icon: Icons.photo_library,
          title: 'Galeri Multimedia',
          subtitle:
              'Kumpulan visual destinasi untuk membantu wisatawan mengenali suasana lokasi.',
        ),
        const SizedBox(height: 12),
        ResponsiveGrid(
          minItemWidth: 260,
          children: _galleryItems
              .map(
                (item) => GalleryCard(item: item),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        const SectionHeader(
          icon: Icons.map,
          title: 'Peta Lokasi',
          subtitle:
              'Rute menuju Air Terjun Benang Stokel dan Benang Kelambu di Lombok Tengah.',
        ),
        const SizedBox(height: 12),
        _buildLocationCard(isWide),
      ],
    );
  }

  Widget _buildLocationCard(bool isWide) {
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: isWide
          ? Row(
              children: [
                Expanded(
                  flex: 6,
                  child: MapPreview(onOpenMap: () => _openDestinationMap()),
                ),
                Expanded(
                  flex: 5,
                  child: RouteInfo(
                    onOpenMap: () => _openDestinationMap(),
                    onDirections: () => _openDestinationMap(directions: true),
                    onChatAdmin: () => _openAdminWhatsApp(),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                MapPreview(onOpenMap: () => _openDestinationMap()),
                RouteInfo(
                  onOpenMap: () => _openDestinationMap(),
                  onDirections: () => _openDestinationMap(directions: true),
                  onChatAdmin: () => _openAdminWhatsApp(),
                ),
              ],
            ),
    );
  }

  Widget _buildBookingPage(bool isWide) {
    final packageNames = _bookablePackageNames;
    final selectedPackage = packageNames.contains(_selectedPackageName)
        ? _selectedPackageName
        : packageNames.first;
    final total = _packagePrice(selectedPackage) * _guestCount;

    return _pageFrame(
      isWide: isWide,
      children: [
        const SectionHeader(
          icon: Icons.event_available,
          title: 'Reservasi Online',
          subtitle:
              'Pengunjung dapat merencanakan kunjungan dengan memilih tanggal, jumlah orang, dan paket wisata.',
        ),
        const SizedBox(height: 12),
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildBookingForm(selectedPackage, total)),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: _buildBookingList()),
                ],
              )
            : Column(
                children: [
                  _buildBookingForm(selectedPackage, total),
                  const SizedBox(height: 16),
                  _buildBookingList(),
                ],
              ),
        const SizedBox(height: 28),
        _buildReviewsSection(isWide),
      ],
    );
  }

  Widget _buildBookingForm(String selectedPackage, int total) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Form Booking',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bookingNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nama pengunjung',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bookingPhoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nomor WhatsApp / telepon',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedPackage,
            decoration: const InputDecoration(
              labelText: 'Paket wisata',
              prefixIcon: Icon(Icons.card_travel),
            ),
            items: _bookablePackageNames
                .map(
                  (name) => DropdownMenuItem(
                    value: name,
                    child: Text(name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() => _selectedPackageName = value);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickArrivalDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(shortDate(_arrivalDate)),
                ),
              ),
              const SizedBox(width: 12),
              QuantityStepper(
                value: _guestCount,
                onDecrease: () {
                  if (_guestCount > 1) {
                    setState(() => _guestCount--);
                  }
                },
                onIncrease: () => setState(() => _guestCount++),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Row(
              children: [
                const Icon(Icons.payments, color: Color(0xFFC2410C)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Total estimasi',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  rupiah(total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF9A3412),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _submitBooking(
                selectedPackage,
                total,
                notifyAdmin: true,
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Pesan Langsung via WhatsApp'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _submitBooking(selectedPackage, total),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan di Aplikasi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Reservasi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          if (_bookings.isEmpty)
            const EmptyState(
              icon: Icons.event_busy,
              title: 'Belum ada reservasi',
              body: 'Reservasi baru akan tampil di sini.',
            )
          else
            ..._bookings.map(
              (booking) => BookingTile(
                booking: booking,
                onChat: () => _openAdminWhatsApp(_bookingMessage(booking)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          icon: Icons.rate_review,
          title: 'Review Pengunjung',
          subtitle:
              'Rating rata-rata ${_averageRating.toStringAsFixed(1)} dari ${_reviews.length} ulasan.',
        ),
        const SizedBox(height: 12),
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildReviewForm()),
                  const SizedBox(width: 16),
                  Expanded(flex: 6, child: _buildReviewList()),
                ],
              )
            : Column(
                children: [
                  _buildReviewForm(),
                  const SizedBox(height: 16),
                  _buildReviewList(),
                ],
              ),
      ],
    );
  }

  Widget _buildReviewForm() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tambah Review',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _reviewNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nama pengunjung',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reviewCommentController,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.comment),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Text('Rating ${_newReviewRating.toStringAsFixed(0)}'),
            ],
          ),
          Slider(
            value: _newReviewRating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _newReviewRating.toStringAsFixed(0),
            onChanged: (value) => setState(() => _newReviewRating = value),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitReview,
              icon: const Icon(Icons.send),
              label: const Text('Kirim Review'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ulasan Terbaru',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          if (_reviews.isEmpty)
            const EmptyState(
              icon: Icons.rate_review_outlined,
              title: 'Belum ada ulasan',
              body: 'Review pengunjung akan tampil di sini.',
            )
          else
            ..._reviews.reversed.map(
              (review) => ReviewTile(review: review),
            ),
        ],
      ),
    );
  }

  Widget _buildAdminPage(bool isWide) {
    return _pageFrame(
      isWide: isWide,
      children: [
        const SectionHeader(
          icon: Icons.admin_panel_settings,
          title: 'Panel Admin',
          subtitle:
              'Admin mengelola data wisata, harga tiket, galeri, booking, paket wisata, review, dan laporan.',
        ),
        const SizedBox(height: 12),
        _adminLoggedIn ? _buildAdminDashboard(isWide) : _buildAdminLogin(),
      ],
    );
  }

  Widget _buildAdminLogin() {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login Admin',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _adminUsernameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _adminPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loginAdmin,
                  icon: const Icon(Icons.login),
                  label: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Demo: admin / admin123',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboard(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Dashboard Pengelola',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF123832),
                    ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => setState(() => _adminLoggedIn = false),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ResponsiveGrid(
          minItemWidth: 220,
          children: [
            StatCard(
              icon: Icons.event_available,
              label: 'Booking',
              value: '${_bookings.length}',
              color: const Color(0xFF0F766E),
            ),
            StatCard(
              icon: Icons.hourglass_top,
              label: 'Menunggu',
              value:
                  "${_bookings.where((booking) => booking.status == 'Menunggu').length}",
              color: const Color(0xFFF59E0B),
            ),
            StatCard(
              icon: Icons.star,
              label: 'Rating',
              value: _averageRating.toStringAsFixed(1),
              color: const Color(0xFF2563EB),
            ),
            StatCard(
              icon: Icons.payments,
              label: 'Estimasi omzet',
              value: rupiah(_bookingRevenue),
              color: const Color(0xFF7C3AED),
            ),
          ],
        ),
        const SizedBox(height: 16),
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildAdminDestinationManager()),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: _buildAdminTicketManager()),
                ],
              )
            : Column(
                children: [
                  _buildAdminDestinationManager(),
                  const SizedBox(height: 16),
                  _buildAdminTicketManager(),
                ],
              ),
        const SizedBox(height: 16),
        _buildAdminImageManager(),
        const SizedBox(height: 16),
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildAdminBookingManager()),
                  const SizedBox(width: 16),
                  Expanded(flex: 5, child: _buildAdminPackageManager()),
                ],
              )
            : Column(
                children: [
                  _buildAdminBookingManager(),
                  const SizedBox(height: 16),
                  _buildAdminPackageManager(),
                ],
              ),
        const SizedBox(height: 16),
        _buildAdminReviewManager(),
      ],
    );
  }

  Widget _buildAdminDestinationManager() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adminCardTitle(Icons.edit_location_alt, 'Kelola Data Wisata'),
          const SizedBox(height: 14),
          TextField(
            controller: _openHoursController,
            decoration: const InputDecoration(
              labelText: 'Jam operasional',
              prefixIcon: Icon(Icons.schedule),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _announcementController,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Pengumuman',
              prefixIcon: Icon(Icons.campaign),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _adminWhatsAppController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Nomor WhatsApp admin',
              helperText: 'Contoh: 6287748071872',
              prefixIcon: Icon(Icons.chat_bubble_outline),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveDestinationInfo,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Informasi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminImageManager() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adminCardTitle(Icons.image, 'Kelola Gambar Tampilan'),
          const SizedBox(height: 12),
          _buildBackgroundDesigner(),
          const SizedBox(height: 16),
          Text(
            'Gambar tampilan',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          ResponsiveGrid(
            minItemWidth: 260,
            children: [
              _buildImageSelector(
                label: 'Latar belakang aplikasi',
                value: _backgroundImage,
                onChanged: (value) => setState(() => _backgroundImage = value),
              ),
              _buildImageSelector(
                label: 'Gambar utama beranda',
                value: _heroImage,
                onChanged: (value) => setState(() => _heroImage = value),
              ),
              ..._galleryItems.indexed.map(
                (entry) {
                  final index = entry.$1;
                  final item = entry.$2;
                  return _buildImageSelector(
                    label: 'Galeri: ${item.title}',
                    value: item.image,
                    onChanged: (value) {
                      setState(() {
                        _galleryItems[index] = item.copyWith(image: value);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDesigner() {
    final preset = _selectedBackgroundPreset;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      preset.patternColor.withAlpha(28),
                      Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(preset.icon, color: preset.patternColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Desain Latar Aplikasi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _resetBackgroundDesign,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 5,
                child: _buildBackgroundLayers(preset),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _backgroundPresets.map((option) {
                final selected = option.key == _backgroundPresetKey;

                return ChoiceChip(
                  selected: selected,
                  selectedColor: const Color(0xFF0F766E),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFF0F766E)
                        : const Color(0xFFD7E5E1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar: Icon(
                    option.icon,
                    size: 18,
                    color: selected ? Colors.white : option.patternColor,
                  ),
                  label: Text(option.label),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF123832),
                    fontWeight: FontWeight.w700,
                  ),
                  onSelected: (_) {
                    setState(() => _backgroundPresetKey = option.key);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            _buildBackgroundSlider(
              icon: Icons.image_outlined,
              label: 'Kekuatan foto',
              value: _backgroundImageOpacity,
              min: 0.12,
              max: 0.5,
              divisions: 19,
              onChanged: (value) {
                setState(() => _backgroundImageOpacity = value);
              },
            ),
            _buildBackgroundSlider(
              icon: Icons.tonality,
              label: 'Lapisan terang',
              value: _backgroundWashStrength,
              min: 0.64,
              max: 0.94,
              divisions: 15,
              onChanged: (value) {
                setState(() => _backgroundWashStrength = value);
              },
            ),
            SwitchListTile.adaptive(
              value: _backgroundTextureEnabled,
              onChanged: (value) {
                setState(() => _backgroundTextureEnabled = value);
              },
              title: const Text('Motif kontur alam'),
              secondary: const Icon(Icons.layers_outlined),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSlider({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    final percent = '${(value * 100).round()}%';

    return LayoutBuilder(
      builder: (context, constraints) {
        final slider = Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: percent,
          onChanged: onChanged,
        );

        if (constraints.maxWidth < 520) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(icon, color: const Color(0xFF0F766E)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      percent,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                slider,
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF0F766E)),
              const SizedBox(width: 8),
              SizedBox(
                width: 132,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(child: slider),
              SizedBox(
                width: 48,
                child: Text(
                  percent,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSelector({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    final selectedValue =
        _imageOptions.any((image) => image.path == value) ? value : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0xFFE2E8F0),
                      child: Center(
                        child: Icon(Icons.image_not_supported_outlined),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedValue,
              decoration: const InputDecoration(
                labelText: 'Pilih gambar',
                prefixIcon: Icon(Icons.photo_library_outlined),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _imageOptions
                  .map(
                    (image) => DropdownMenuItem(
                      value: image.path,
                      child: Text(image.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTicketManager() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adminCardTitle(Icons.price_change, 'Kelola Harga Tiket'),
          const SizedBox(height: 12),
          PriceAdjuster(
            label: 'Wisatawan Nusantara',
            value: _domesticTicket,
            onDecrease: () => _adjustPrice('domestic', -1000),
            onIncrease: () => _adjustPrice('domestic', 1000),
          ),
          PriceAdjuster(
            label: 'Wisatawan Mancanegara',
            value: _foreignTicket,
            onDecrease: () => _adjustPrice('foreign', -1000),
            onIncrease: () => _adjustPrice('foreign', 1000),
          ),
          PriceAdjuster(
            label: 'Parkir Motor',
            value: _motorParking,
            onDecrease: () => _adjustPrice('motor', -1000),
            onIncrease: () => _adjustPrice('motor', 1000),
          ),
          PriceAdjuster(
            label: 'Parkir Mobil',
            value: _carParking,
            onDecrease: () => _adjustPrice('car', -1000),
            onIncrease: () => _adjustPrice('car', 1000),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showReportDialog,
              icon: const Icon(Icons.print),
              label: const Text('Cetak Laporan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminBookingManager() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adminCardTitle(Icons.fact_check, 'Kelola Booking'),
          const SizedBox(height: 12),
          if (_bookings.isEmpty)
            const EmptyState(
              icon: Icons.event_busy,
              title: 'Tidak ada booking',
              body: 'Booking pengunjung akan tampil di dashboard admin.',
            )
          else
            ..._bookings.map(
              (booking) => AdminBookingTile(
                booking: booking,
                statusOptions: _statusOptions,
                onStatusChanged: (status) => _updateBookingStatus(booking.id, status),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdminPackageManager() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adminCardTitle(Icons.card_travel, 'Kelola Paket Wisata'),
          const SizedBox(height: 8),
          ..._packages.indexed.map(
            (entry) {
              final index = entry.$1;
              final package = entry.$2;
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: package.isActive,
                title: Text(package.name),
                subtitle: Text(rupiah(package.price)),
                secondary: Icon(package.icon),
                onChanged: (value) => _setPackageActive(index, value),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminReviewManager() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adminCardTitle(Icons.rate_review, 'Kelola Review'),
          const SizedBox(height: 12),
          if (_reviews.isEmpty)
            const EmptyState(
              icon: Icons.rate_review_outlined,
              title: 'Tidak ada review',
              body: 'Review yang masuk akan tampil untuk ditinjau admin.',
            )
          else
            ..._reviews.reversed.map(
              (review) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFFFF7ED),
                  foregroundColor: const Color(0xFFC2410C),
                  child: Text(review.rating.toStringAsFixed(0)),
                ),
                title: Text(review.visitorName),
                subtitle: Text(review.comment),
                trailing: IconButton(
                  tooltip: 'Hapus review',
                  onPressed: () => _deleteReview(review.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _adminCardTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0F766E)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard() {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.campaign, color: Color(0xFFF59E0B)),
          const SizedBox(height: 12),
          Text(
            'Informasi Kunjungan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(_announcement),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              BadgePill(text: 'Jam buka: $_openHours'),
              const BadgePill(text: 'Koneksi internet diperlukan'),
              const BadgePill(text: 'Admin dan pengunjung berbeda akses'),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickArrivalDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _arrivalDate,
    );

    if (!mounted || picked == null) {
      return;
    }

    setState(() => _arrivalDate = picked);
  }

  Future<void> _submitBooking(
  String packageName,
  int total, {
  bool notifyAdmin = false,
}) async {

  final name = _bookingNameController.text.trim();
  final phone = _bookingPhoneController.text.trim();

  if (name.isEmpty || phone.isEmpty) {
    _showSnack('Nama dan nomor telepon wajib diisi.');
    return;
  }

  final response = await http.post(
    Uri.parse("http://waterfallbooking.web.id/api/booking"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "id_wisata": 1,
      "nama_pengunjung": name,
      "no_hp": phone,
      "jumlah_tiket": _guestCount,
      "tanggal_kunjungan":
          _arrivalDate.toIso8601String().substring(0, 10)
    }),
  );

  if (response.statusCode == 201) {

    _bookingNameController.clear();
    _bookingPhoneController.clear();

    _showSnack("Booking berhasil disimpan.");

    if (notifyAdmin) {
      await _openAdminWhatsApp("Booking baru dari $name");
    }

  } else {

    _showSnack("Booking gagal.");

  }
}

  void _submitReview() {
    final name = _reviewNameController.text.trim();
    final comment = _reviewCommentController.text.trim();

    if (name.isEmpty || comment.isEmpty) {
      _showSnack('Nama dan komentar review wajib diisi.');
      return;
    }

    setState(() {
      _reviews.add(
        VisitorReview(
          id: _reviewSequence++,
          visitorName: name,
          rating: _newReviewRating,
          comment: comment,
        ),
      );
      _reviewNameController.clear();
      _reviewCommentController.clear();
      _newReviewRating = 5;
    });

    _showSnack('Review pengunjung berhasil disimpan.');
  }

  void _loginAdmin() {
    final username = _adminUsernameController.text.trim();
    final password = _adminPasswordController.text.trim();

    if (username == 'admin' && password == 'admin123') {
      setState(() {
        _adminLoggedIn = true;
        _adminPasswordController.clear();
      });
      _showSnack('Login admin berhasil.');
    } else {
      _showSnack('Username atau password admin salah.');
    }
  }

  void _saveDestinationInfo() {
    final normalizedWhatsApp =
        _normalizeWhatsAppNumber(_adminWhatsAppController.text);

    setState(() {
      _openHours = _openHoursController.text.trim().isEmpty
          ? _openHours
          : _openHoursController.text.trim();
      _announcement = _announcementController.text.trim().isEmpty
          ? _announcement
          : _announcementController.text.trim();
      if (normalizedWhatsApp.isNotEmpty) {
        _adminWhatsAppNumber = normalizedWhatsApp;
        _adminWhatsAppController.text = normalizedWhatsApp;
      }
    });
    _showSnack('Informasi wisata berhasil diperbarui.');
  }

  String _bookingMessage(Booking booking) {
    return [
      'Halo Admin SIP Benang Stokel, saya ingin memesan kunjungan wisata.',
      '',
      'Nama: ${booking.visitorName}',
      'No. HP/WA: ${booking.phone}',
      'Tanggal: ${shortDate(booking.arrivalDate)}',
      'Jumlah orang: ${booking.guestCount}',
      'Paket: ${booking.packageName}',
      'Estimasi total: ${rupiah(booking.totalPrice)}',
      '',
      'Mohon konfirmasi ketersediaannya. Terima kasih.',
    ].join('\n');
  }

  Future<void> _openAdminWhatsApp([String? message]) async {
    final phone = _normalizeWhatsAppNumber(_adminWhatsAppNumber);

    if (phone.isEmpty) {
      _showSnack('Nomor WhatsApp admin belum diatur.');
      return;
    }

    final uri = Uri.https('wa.me', '/$phone', {
      'text': message ??
          'Halo Admin SIP Benang Stokel, saya ingin bertanya tentang informasi wisata.',
    });
    await _openExternalUri(uri, 'WhatsApp tidak dapat dibuka di perangkat ini.');
  }

  Future<void> _openDestinationMap({bool directions = false}) async {
    final query = '$_destinationName, $_destinationAddress';
    final uri = directions
        ? Uri.https('www.google.com', '/maps/dir/', {
            'api': '1',
            'destination': query,
            'travelmode': 'driving',
          })
        : Uri.https('www.google.com', '/maps/search/', {
            'api': '1',
            'query': query,
          });

    await _openExternalUri(
      uri,
      'Google Maps tidak dapat dibuka di perangkat ini.',
    );
  }

  Future<void> _openExternalUri(Uri uri, String failureMessage) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) {
        return;
      }
      if (!launched) {
        _showSnack(failureMessage);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnack(failureMessage);
    }
  }

  String _normalizeWhatsAppNumber(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('0')) {
      return '62${digits.substring(1)}';
    }
    return digits;
  }

  void _adjustPrice(String key, int delta) {
    setState(() {
      switch (key) {
        case 'domestic':
          _domesticTicket = math.max(0, _domesticTicket + delta);
        case 'foreign':
          _foreignTicket = math.max(0, _foreignTicket + delta);
        case 'motor':
          _motorParking = math.max(0, _motorParking + delta);
        case 'car':
          _carParking = math.max(0, _carParking + delta);
      }
    });
  }

  void _updateBookingStatus(int bookingId, String status) {
    setState(() {
      _bookings = _bookings
          .map(
            (booking) => booking.id == bookingId
                ? booking.copyWith(status: status)
                : booking,
          )
          .toList();
    });
  }

  void _setPackageActive(int index, bool value) {
    setState(() {
      _packages[index] = _packages[index].copyWith(isActive: value);
      if (!_bookablePackageNames.contains(_selectedPackageName)) {
        _selectedPackageName = 'Tiket Mandiri';
      }
    });
  }

  void _resetBackgroundDesign() {
    setState(() {
      _backgroundPresetKey = 'natural';
      _backgroundImageOpacity = 0.32;
      _backgroundWashStrength = 0.82;
      _backgroundTextureEnabled = true;
    });
    _showSnack('Desain latar berhasil direset.');
  }

  void _deleteReview(int id) {
    setState(() {
      _reviews.removeWhere((review) => review.id == id);
    });
    _showSnack('Review berhasil dihapus.');
  }

  void _showReportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Laporan Pariwisata'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total booking: ${_bookings.length}'),
              Text(
                "Booking menunggu: ${_bookings.where((booking) => booking.status == 'Menunggu').length}",
              ),
              Text('Total review: ${_reviews.length}'),
              Text('Rating rata-rata: ${_averageRating.toStringAsFixed(1)}'),
              Text('Estimasi omzet: ${rupiah(_bookingRevenue)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDE7E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF0F766E)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF123832),
                      letterSpacing: 0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5C6F6A),
                    ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.minItemWidth = 260,
    this.spacing = 12,
    super.key,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final count = math.max(1, width ~/ minItemWidth);
        final itemWidth = (width - (spacing * (count - 1))) / count;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map(
                (child) => SizedBox(width: itemWidth, child: child),
              )
              .toList(),
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Color.alphaBlend(color.withAlpha(32), Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF123832),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF0F766E), size: 30),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({
    required this.title,
    required this.icon,
    required this.body,
    super.key,
  });

  final String title;
  final IconData icon;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0F766E)),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  const TicketCard({required this.ticket, super.key});

  final TicketOption ticket;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ticket.icon, color: const Color(0xFF0F766E), size: 30),
          const SizedBox(height: 14),
          Text(
            ticket.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            ticket.note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
          ),
          const SizedBox(height: 14),
          Text(
            rupiah(ticket.price),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF9A3412),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
          ),
        ],
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  const PackageCard({required this.package, super.key});

  final PackageOption package;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(package.icon, color: const Color(0xFF0F766E), size: 30),
              const Spacer(),
              BadgePill(text: package.isActive ? 'Aktif' : 'Nonaktif'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            package.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(package.description),
          const SizedBox(height: 12),
          Text(
            rupiah(package.price),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF9A3412),
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: package.includes
                .map(
                  (item) => BadgePill(text: item),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class GalleryCard extends StatelessWidget {
  const GalleryCard({required this.item, super.key});

  final GalleryItem item;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(item.subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapPreview extends StatelessWidget {
  const MapPreview({this.onOpenMap, super.key});

  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onOpenMap,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: MapPreviewPainter()),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A0F172A),
                          blurRadius: 14,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map, color: Color(0xFF0F766E), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Terhubung Google Maps',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xEE123832),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Air Terjun Benang Stokel dan Kelambu',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Aik Berik, Batukliang Utara, Lombok Tengah',
                            style: TextStyle(color: Color(0xFFD1FAE5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RouteInfo extends StatelessWidget {
  const RouteInfo({
    required this.onOpenMap,
    required this.onDirections,
    required this.onChatAdmin,
    super.key,
  });

  final VoidCallback onOpenMap;
  final VoidCallback onDirections;
  final VoidCallback onChatAdmin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rute Wisata',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          const RouteStep(number: '1', text: 'Mulai dari Kota Mataram atau Praya.'),
          const RouteStep(number: '2', text: 'Arahkan perjalanan ke Desa Aik Berik.'),
          const RouteStep(
            number: '3',
            text: 'Ikuti papan arah menuju Benang Stokel dan Benang Kelambu.',
          ),
          const RouteStep(
            number: '4',
            text: 'Gunakan guide lokal jika mengambil jalur trekking tambahan.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onDirections,
                icon: const Icon(Icons.directions),
                label: const Text('Rute Maps'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenMap,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Lihat Peta'),
              ),
              OutlinedButton.icon(
                onPressed: onChatAdmin,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat Admin'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RouteStep extends StatelessWidget {
  const RouteStep({
    required this.number,
    required this.text,
    super.key,
  });

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFFE0F2F1),
            foregroundColor: const Color(0xFF0F766E),
            child: Text(
              number,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  const BookingTile({
    required this.booking,
    this.onChat,
    super.key,
  });

  final Booking booking;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFE0F2F1),
                    foregroundColor: const Color(0xFF0F766E),
                    child: Text('${booking.guestCount}'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      booking.visitorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  BadgePill(text: booking.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${booking.packageName} - ${shortDate(booking.arrivalDate)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('${booking.phone} - ${rupiah(booking.totalPrice)}'),
              if (onChat != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onChat,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat Admin untuk Konfirmasi'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AdminBookingTile extends StatelessWidget {
  const AdminBookingTile({
    required this.booking,
    required this.statusOptions,
    required this.onStatusChanged,
    super.key,
  });

  final Booking booking;
  final List<String> statusOptions;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.visitorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Text(rupiah(booking.totalPrice)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.phone} - ${booking.packageName} - ${shortDate(booking.arrivalDate)}',
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: booking.status,
                decoration: const InputDecoration(
                  labelText: 'Status booking',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: statusOptions
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onStatusChanged(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({required this.review, super.key});

  final VisitorReview review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.visitorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  StarRating(value: review.rating),
                ],
              ),
              const SizedBox(height: 6),
              Text(review.comment),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  const StarRating({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < value.round() ? Icons.star : Icons.star_border,
          size: 16,
          color: const Color(0xFFF59E0B),
        ),
      ),
    );
  }
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD7E5E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Kurangi orang',
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            tooltip: 'Tambah orang',
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class PriceAdjuster extends StatelessWidget {
  const PriceAdjuster({
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  final String label;
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label),
                    const SizedBox(height: 4),
                    Text(
                      rupiah(value),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Turunkan harga',
                onPressed: onDecrease,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              IconButton(
                tooltip: 'Naikkan harga',
                onPressed: onIncrease,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipItem extends StatelessWidget {
  const ChipItem({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: const Color(0xFF0F766E)),
      label: Text(text),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFD7E5E1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class BadgePill extends StatelessWidget {
  const BadgePill({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF1D4ED8),
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(icon, size: 42, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class TourismBackgroundPainter extends CustomPainter {
  const TourismBackgroundPainter({
    required this.preset,
    required this.opacity,
  });

  final BackgroundPreset preset;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final strength = opacity.clamp(0.0, 1.0).toDouble();

    final canopyPaint = Paint()
      ..color = preset.patternColor.withAlpha(_opacityAlpha(strength * 0.18));
    final canopy = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.74)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.61,
        size.width * 0.32,
        size.height * 0.86,
        size.width * 0.52,
        size.height * 0.71,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.57,
        size.width * 0.86,
        size.height * 0.82,
        size.width,
        size.height * 0.67,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(canopy, canopyPaint);

    final river = Path()
      ..moveTo(size.width * 0.08, -20)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.18,
        size.width * 0.1,
        size.height * 0.36,
        size.width * 0.33,
        size.height * 0.52,
      )
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.68,
        size.width * 0.49,
        size.height * 0.86,
        size.width * 0.7,
        size.height + 26,
      );
    canvas.drawPath(
      river,
      Paint()
        ..color = preset.waterColor.withAlpha(_opacityAlpha(strength * 0.2))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 34
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      river,
      Paint()
        ..color = Colors.white.withAlpha(_opacityAlpha(strength * 0.22))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    final contourPaint = Paint()
      ..color = preset.patternColor.withAlpha(_opacityAlpha(strength * 0.3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var i = 0; i < 8; i++) {
      final y = size.height * (0.1 + i * 0.1);
      final shift = i.isEven ? -24.0 : 18.0;
      final contour = Path()
        ..moveTo(-30, y + shift)
        ..cubicTo(
          size.width * 0.22,
          y - 38,
          size.width * 0.38,
          y + 42,
          size.width * 0.58,
          y + 4,
        )
        ..cubicTo(
          size.width * 0.76,
          y - 28,
          size.width * 0.88,
          y + 32,
          size.width + 30,
          y - 4,
        );
      canvas.drawPath(contour, contourPaint);
    }

    final leafPaint = Paint()
      ..color = preset.accentColor.withAlpha(_opacityAlpha(strength * 0.24))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 9; i++) {
      final x = size.width * (0.06 + i * 0.11);
      final y = size.height * (0.18 + (i % 3) * 0.18);
      canvas.drawLine(Offset(x, y), Offset(x + 24, y + 18), leafPaint);
      canvas.drawLine(Offset(x + 24, y + 18), Offset(x + 38, y + 7), leafPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TourismBackgroundPainter oldDelegate) {
    return oldDelegate.preset.key != preset.key || oldDelegate.opacity != opacity;
  }
}

class WaterfallScene extends StatelessWidget {
  const WaterfallScene({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.25,
      child: CustomPaint(painter: WaterfallPainter()),
    );
  }
}

class WaterfallPainter extends CustomPainter {
  const WaterfallPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFBAE6FD), Color(0xFFE0F2FE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    final backHill = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.2,
        size.width * 0.46,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.18,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(backHill, Paint()..color = const Color(0xFF86EFAC));

    final frontHill = Path()
      ..moveTo(0, size.height * 0.66)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.36,
        size.width * 0.52,
        size.height * 0.62,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.42,
        size.width,
        size.height * 0.62,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF16A34A));

    final cliffPaint = Paint()..color = const Color(0xFF57534E);
    final cliff = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.3,
        size.width * 0.3,
        size.height * 0.48,
      ),
      const Radius.circular(24),
    );
    canvas.drawRRect(cliff, cliffPaint);

    final waterPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFE0F2FE), Color(0xFF22D3EE), Color(0xFF0891B2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(
          size.width * 0.44,
          size.height * 0.26,
          size.width * 0.13,
          size.height * 0.56,
        ),
      );
    final fall = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.44,
        size.height * 0.24,
        size.width * 0.13,
        size.height * 0.58,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(fall, waterPaint);

    final thinWater = Paint()
      ..color = const Color(0xDDE0F2FE)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.46 + (i * 0.02));
      canvas.drawLine(
        Offset(x, size.height * 0.28),
        Offset(x - 8 + (i * 3), size.height * 0.76),
        thinWater,
      );
    }

    final poolPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF67E8F9), Color(0xFF0E7490)],
      ).createShader(
        Rect.fromLTWH(
          size.width * 0.18,
          size.height * 0.72,
          size.width * 0.64,
          size.height * 0.2,
        ),
      );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.72,
        size.width * 0.64,
        size.height * 0.19,
      ),
      poolPaint,
    );

    final rockPaint = Paint()..color = const Color(0xFF44403C);
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.78, 58, 24),
      rockPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.63, size.height * 0.77, 68, 26),
      rockPaint,
    );

    final trunk = Paint()..color = const Color(0xFF854D0E);
    final leaf = Paint()..color = const Color(0xFF15803D);
    for (final x in [0.08, 0.16, 0.78, 0.88]) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * x,
          size.height * 0.56,
          8,
          size.height * 0.2,
        ),
        trunk,
      );
      canvas.drawCircle(
        Offset(size.width * x + 4, size.height * 0.52),
        28,
        leaf,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GalleryPatternPainter extends CustomPainter {
  const GalleryPatternPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.2 + i * 0.13);
      final path = Path()
        ..moveTo(-20, y)
        ..quadraticBezierTo(size.width * 0.25, y - 30, size.width * 0.55, y)
        ..quadraticBezierTo(size.width * 0.85, y + 30, size.width + 20, y);
      canvas.drawPath(path, paint);
    }

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.22),
      34,
      Paint()..color = Colors.white.withAlpha(30),
    );
  }

  @override
  bool shouldRepaint(covariant GalleryPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class MapPreviewPainter extends CustomPainter {
  const MapPreviewPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE0F2F1);
    canvas.drawRect(Offset.zero & size, background);

    final land = Paint()..color = const Color(0xFFBBF7D0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.12, size.width * 0.82, size.height * 0.72),
        const Radius.circular(36),
      ),
      land,
    );

    final road = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final route = Path()
      ..moveTo(size.width * 0.12, size.height * 0.75)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.62,
        size.width * 0.32,
        size.height * 0.38,
        size.width * 0.52,
        size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.6,
        size.width * 0.72,
        size.height * 0.24,
        size.width * 0.84,
        size.height * 0.28,
      );
    canvas.drawPath(route, road);

    final dash = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, dash);

    _drawPin(canvas, Offset(size.width * 0.12, size.height * 0.75), const Color(0xFF2563EB));
    _drawPin(canvas, Offset(size.width * 0.84, size.height * 0.28), const Color(0xFFDC2626));

    final river = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.62, size.height * 0.12),
      Offset(size.width * 0.72, size.height * 0.84),
      river,
    );
  }

  void _drawPin(Canvas canvas, Offset center, Color color) {
    final paint = Paint()..color = color;
    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: 15))
      ..moveTo(center.dx - 9, center.dy + 8)
      ..lineTo(center.dx, center.dy + 28)
      ..lineTo(center.dx + 9, center.dy + 8)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PackageOption {
  const PackageOption({
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
    required this.includes,
    this.isActive = true,
  });

  final String name;
  final int price;
  final String description;
  final IconData icon;
  final List<String> includes;
  final bool isActive;

  PackageOption copyWith({bool? isActive}) {
    return PackageOption(
      name: name,
      price: price,
      description: description,
      icon: icon,
      includes: includes,
      isActive: isActive ?? this.isActive,
    );
  }
}

class TicketOption {
  const TicketOption({
    required this.name,
    required this.price,
    required this.note,
    required this.icon,
  });

  final String name;
  final int price;
  final String note;
  final IconData icon;
}

class GalleryItem {
  const GalleryItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  final String title;
  final String subtitle;
  final String image;
  final IconData icon;
  final Color startColor;
  final Color endColor;

  GalleryItem copyWith({String? image}) {
    return GalleryItem(
      title: title,
      subtitle: subtitle,
      image: image ?? this.image,
      icon: icon,
      startColor: startColor,
      endColor: endColor,
    );
  }
}

class ImageChoice {
  const ImageChoice({
    required this.label,
    required this.path,
  });

  final String label;
  final String path;
}

class BackgroundPreset {
  const BackgroundPreset({
    required this.key,
    required this.label,
    required this.icon,
    required this.baseColors,
    required this.washTop,
    required this.washMiddle,
    required this.washBottom,
    required this.patternColor,
    required this.accentColor,
    required this.waterColor,
  });

  final String key;
  final String label;
  final IconData icon;
  final List<Color> baseColors;
  final Color washTop;
  final Color washMiddle;
  final Color washBottom;
  final Color patternColor;
  final Color accentColor;
  final Color waterColor;
}

class Booking {
  const Booking({
    required this.id,
    required this.visitorName,
    required this.phone,
    required this.arrivalDate,
    required this.guestCount,
    required this.packageName,
    required this.totalPrice,
    required this.status,
  });

  final int id;
  final String visitorName;
  final String phone;
  final DateTime arrivalDate;
  final int guestCount;
  final String packageName;
  final int totalPrice;
  final String status;

  Booking copyWith({String? status}) {
    return Booking(
      id: id,
      visitorName: visitorName,
      phone: phone,
      arrivalDate: arrivalDate,
      guestCount: guestCount,
      packageName: packageName,
      totalPrice: totalPrice,
      status: status ?? this.status,
    );
  }
}

class VisitorReview {
  const VisitorReview({
    required this.id,
    required this.visitorName,
    required this.rating,
    required this.comment,
  });

  final int id;
  final String visitorName;
  final double rating;
  final String comment;
}

int _opacityAlpha(double value) {
  return (value.clamp(0.0, 1.0) * 255).round();
}

String rupiah(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < raw.length; i++) {
    final positionFromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp$buffer';
}

String shortDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
