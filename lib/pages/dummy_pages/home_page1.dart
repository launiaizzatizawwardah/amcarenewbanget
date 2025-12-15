import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home1_controller.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';

// TAB PAGES
import 'riwayat_rekam_medis_page1.dart';
import '../dummy_pages/layanan_page.dart';
import '../dummy_pages/profile_page.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Home1Controller());
    final home = Get.put(HomeController());

    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Obx(() {
        switch (c.selectedIndex.value) {
          case 0:
            return _beranda(context, bottomPadding, home);
          case 1:
            return RiwayatRekamMedisPage1();
          case 2:
            return const LayananPage();
          case 3:
            return const ProfilePage();
          default:
            return _beranda(context, bottomPadding, home);
        }
      }),

      bottomNavigationBar: _bottomNav(c),
    );
  }

  // =============================================================
  // BOTTOM NAV
  // =============================================================
  Widget _bottomNav(Home1Controller c) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.all(16),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.60),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final icons = [
              Icons.home_rounded,
              Icons.folder_shared_rounded,
              Icons.medical_services_rounded,
              Icons.person_rounded,
            ];

            final labels = [
              "Beranda",
              "Riwayat RM",
              "Layanan",
              "Akun",
            ];

            final active = c.selectedIndex.value == index;

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => c.changeTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: active ? Colors.blue.shade50 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index],
                      color: active ? Colors.blueAccent : Colors.grey,
                      size: active ? 28 : 23,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontFamily: 'LexendExa',
                        fontSize: 11,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        color: active ? Colors.blueAccent : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  // =============================================================
  // BERANDA
  // =============================================================
  Widget _beranda(
      BuildContext context, double bottomPadding, HomeController home) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 20),
            _welcome(),
            const SizedBox(height: 12),

            /// 🔥 SLIDER FINAL TANPA CROP + ZOOM + NO SPACE
            _sliderZoomAuto(home),

            const SizedBox(height: 30),
            _menuGrid(),
            const SizedBox(height: 26),
            _paketLayanan(home),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================
  Widget _header() {
    return Row(
      children: [
        Image.asset('assets/images/logo_rs.png', width: 40, height: 40),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AMCare',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LexendExa')),
              Text('Layanan antrian online',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontFamily: 'LexendExa')),
              Text('Asri Medical Center Yogyakarta',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontFamily: 'LexendExa')),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.emergency),
          child: const Icon(Icons.support_agent,
              size: 28, color: Colors.black87),
        )
      ],
    );
  }

  Widget _welcome() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Halo!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'LexendExa',
          ),
        ),
        SizedBox(height: 2),
        Text(
          "Selamat Datang di AmCare",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontFamily: 'LexendExa',
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SLIDER AUTO + ZOOM + TIDAK CROP + NO SPACE ATAS/BWH
  // =============================================================
  Widget _sliderZoomAuto(HomeController home) {
    final pc = PageController(viewportFraction: 0.92);

    // AUTOPLAY
    Timer.periodic(const Duration(seconds: 4), (_) {
      if (pc.hasClients && home.sliders.isNotEmpty) {
        final next = ((pc.page ?? 0).toInt() + 1) % home.sliders.length;
        pc.animateToPage(next,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut);
      }
    });

    return Obx(() {
      if (home.isLoadingSlider.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (home.sliders.isEmpty) {
        return const Center(child: Text("Belum ada promosi tersedia."));
      }

      return LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width * 0.55; // Rasio otomatis → NO SPACE

        return SizedBox(
          width: width,
          height: height,
          child: PageView.builder(
            controller: pc,
            physics: const BouncingScrollPhysics(),
            itemCount: home.sliders.length,
            itemBuilder: (_, index) {
              double scale = 1;

              if (pc.position.hasPixels) {
                final page = pc.page ?? 0;
                final dist = (page - index).abs();
                scale = (1 - dist * 0.20).clamp(0.90, 1.0); // zoom
              }

              final slider = home.sliders[index];

              return Transform.scale(
                scale: scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    slider.foto,
                    width: width,
                    height: height,
                    fit: BoxFit.contain, // 🔥 NO CROP
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              );
            },
          ),
        );
      });
    });
  }

  // =============================================================
  // MENU GRID
  // =============================================================
  Widget _menuGrid() {
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

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final crossAxisCount = 4;
      final spacing = 12.0;
      final itemWidth =
          (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

      return Wrap(
        spacing: spacing,
        runSpacing: 20,
        children: items
            .map((item) => SizedBox(
                  width: itemWidth,
                  child: _menuItemClassic(item[0], item[1], item[2]),
                ))
            .toList(),
      );
    });
  }

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

  // =============================================================
  // PAKET LAYANAN
  // =============================================================
  Widget _paketLayanan(HomeController home) {
    return Obx(() {
      if (home.isLoadingLayanan.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (home.layananList.isEmpty) {
        return const Text("Belum ada layanan tersedia.");
      }

      return SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: home.layananList.length,
          itemBuilder: (_, i) {
            final l = home.layananList[i];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Image.network(
                        l.fotoUtama,
                        height: 90,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        l.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'LexendExa',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
