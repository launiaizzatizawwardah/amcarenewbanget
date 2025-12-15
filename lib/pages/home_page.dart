// File: home_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import './widget/service_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AuthController authController;
  late final HomeController homeController;

  late final AnimationController _animController;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _bannerSlide;
  late final Animation<double> _bannerFade;
  late final Animation<Offset> _menuSlide;
  late final Animation<double> _menuFade;
  late final Animation<Offset> _bottomNavSlide;

  // PageController untuk slider
  late final PageController _pageController;
  Timer? _sliderTimer;
  int _currentSliderIndex = 0;

  int _selectedBottomIndex = 0;

  @override
  void initState() {
    super.initState();

    authController = Get.find<AuthController>();
    homeController = Get.put(HomeController());

    _pageController = PageController(viewportFraction: 0.85);

    /// TIMER AUTOPLAY BARU
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && homeController.sliders.isNotEmpty) {
        final nextPage = (_pageController.page ?? 0).toInt() + 1;
        _pageController.animateToPage(
          nextPage % homeController.sliders.length,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });

    // ANIMASI HEADER, BANNER, MENU, NAVBAR
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerSlide = Tween(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.35)));
    _headerFade = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.35)));

    _bannerSlide = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.2, 0.55)));
    _bannerFade = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.25, 0.6)));

    _menuSlide = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.4, 0.9)));
    _menuFade = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.45, 0.95)));

    _bottomNavSlide = Tween(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: const Interval(0.6, 1.0)));

    _animController.forward();
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPaddingForContent = MediaQuery.of(context).padding.bottom + 80;

    return Scaffold(
      backgroundColor: Colors.white,

      //------------------------------------------------------- APP BAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Image.asset('assets/images/logo_rs.png', width: 35, height: 35),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AMCare',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'LexendExa')),
                    Text('Layanan antrian online',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                            fontFamily: 'LexendExa')),
                    Text('Asri Medical Center Yogyakarta',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                            fontFamily: 'LexendExa')),
                  ],
                ),
              ),
            ],
          ),
          actions: const [
            Icon(Icons.support_agent, color: Colors.black87, size: 28),
            SizedBox(width: 8),
          ],
        ),
      ),

      //------------------------------------------------------- BODY
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, bottomPaddingForContent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------------------ HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Halo!',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'LexendExa')),
                          SizedBox(height: 2),
                          Text('Selamat Datang di AmCare',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontFamily: 'LexendExa')),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Daftar Sekarang!',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14)),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            //------------------------------------------------------- SLIDER PROMOSI
            FadeTransition(
              opacity: _bannerFade,
              child: SlideTransition(
                position: _bannerSlide,
                child: Obx(() {
                  if (homeController.isLoadingSlider.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (homeController.sliders.isEmpty) {
                    return const Center(child: Text("Belum ada promosi tersedia."));
                  }

                  return SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: homeController.sliders.length,
                      itemBuilder: (context, index) {
                        double scale = 1.0;

                        if (_pageController.position.hasPixels) {
                          final page = _pageController.page ?? 0;
                          final distance = (page - index).abs();
                          scale = (1 - distance * 0.25).clamp(0.82, 1.0);
                        }

                        final slider = homeController.sliders[index];

                        return Transform.scale(
                          scale: scale,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                slider.foto,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.broken_image)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            //------------------------------------------------------- MENU GRID (BARU)
            _buildMenuGrid(),

            const SizedBox(height: 24),

            //------------------------------------------------------- PAKET LAYANAN
            _buildPaketLayanan(),
          ],
        ),
      ),

      //------------------------------------------------------- BOTTOM NAV
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ================================================================
  // MENU GRID (SAMA PERSIS HOMEPAGE1)
  // ================================================================
  Widget _buildMenuGrid() {
    final items = [
      ["assets/images/pendaftaran.png", "Pendaftaran\nOnline", AppRoutes.pendaftaranOnline],
      ["assets/images/rekam_medis.png", "Riwayat\nRekam Medis", AppRoutes.riwayatRekamMedis],
      ["assets/images/antrian.png", "Pemantauan\nAntrian", AppRoutes.pemantauanAntrian],
      ["assets/images/jadwal.png", "Jadwal\nDokter", AppRoutes.jadwalDokter],
      ["assets/images/klinik.png", "Nama\nKlinik", AppRoutes.namaKlinik],
      ["assets/images/tempat_tidur.png", "Tempat Tidur\nTersedia", AppRoutes.tempatTidur],
      ["assets/images/farmasi.png", "Antrian\nFarmasi", AppRoutes.antrianFarmasi],
      ["assets/images/emergency.png", "Emergency", AppRoutes.emergency],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _menuFade,
        child: SlideTransition(
          position: _menuSlide,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final crossAxisCount = 4;
                final spacing = 12.0;
                final itemWidth =
                    (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

                return Wrap(
                  spacing: spacing,
                  runSpacing: 20,
                  children: items.map((item) {
                    return SizedBox(
                      width: itemWidth,
                      child: _menuItemClassic(item[0], item[1], item[2]),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // ITEM GRID MENU
  // ================================================================
  Widget _menuItemClassic(String img, String title, dynamic route) {
    return InkWell(
      onTap: () => Get.toNamed(route as String),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F6FA),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Image.asset(img, width: 36, height: 36),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'LexendExa',
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAV (TIDAK DIUBAH)
  // ==========================================================
  Widget _buildBottomNavBar() {
    return SlideTransition(
      position: _bottomNavSlide,
      child: Container(
        margin: const EdgeInsets.all(16),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final items = [
              {'icon': Icons.home_rounded, 'label': 'Beranda'},
              {'icon': Icons.folder_shared_rounded, 'label': 'Riwayat RM'},
              {'icon': Icons.medical_services_rounded, 'label': 'Layanan'},
              {'icon': Icons.person_rounded, 'label': 'Akun'},
            ];

            final isActive = _selectedBottomIndex == index;

            return GestureDetector(
              onTap: () {
                if (!authController.isLoggedIn.value && index != 0) {
                  setState(() => _selectedBottomIndex = 0);
                  Get.snackbar('Perlu Login',
                      'Silakan login dulu untuk mengakses menu ini',
                      snackPosition: SnackPosition.BOTTOM);
                  Get.toNamed(AppRoutes.login);
                } else {
                  setState(() => _selectedBottomIndex = index);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[index]['icon'] as IconData,
                        color: isActive ? Colors.blueAccent : Colors.grey,
                        size: isActive ? 28 : 24),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontFamily: 'LexendExa',
                        fontSize: 11,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ==========================================================
  // PAKET LAYANAN (TIDAK DIUBAH)
  // ==========================================================
  Widget _buildPaketLayanan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //----------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Paket Layanan',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LexendExa')),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text('Lihat semua',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontFamily: 'LexendExa')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        //----------------------------------------
        Obx(() {
          if (homeController.isLoadingLayanan.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (homeController.layananList.isEmpty) {
            return const Center(child: Text("Belum ada layanan tersedia."));
          }

          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: homeController.layananList.length,
              itemBuilder: (context, index) {
                final layanan = homeController.layananList[index];
                return Padding(
                  padding:
                      EdgeInsets.only(left: index == 0 ? 16 : 0, right: 12),
                  child: ServiceCard(
                    title: layanan.nama,
                    subtitle: layanan.deskripsi,
                    imageUrl: layanan.fotoUtama,
                    price: layanan.harga,
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
