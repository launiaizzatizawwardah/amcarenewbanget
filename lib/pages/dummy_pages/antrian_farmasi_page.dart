import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/farmasi_controller.dart';
import '/routes/app_routes.dart';

class AntrianFarmasiPage extends StatelessWidget {
  const AntrianFarmasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(FarmasiController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background-marble.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 HEADER
          Container(
            height: 95,
            decoration: const BoxDecoration(
              color: Color(0xFF2E8BC0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.offAllNamed(AppRoutes.home1),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Antrian Farmasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'LexendExa',
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 0),
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.daftarFarmasi.isEmpty) {
                return const Center(
                  child: Text(
                    "Tidak ada antrian farmasi ditemukan",
                    style: TextStyle(
                      fontFamily: 'LexendExa',
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                );
              }

              // 🔥 Pisahkan racikan & non racikan
              final nonRacik = c.daftarFarmasi.where((e) => e["racikan"] == "1").toList();
final racik = c.daftarFarmasi.where((e) => e["racikan"] == "2").toList();

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _AntrianCard(
                    title: "Non Racikan",
                    currentNumber: nonRacik.isNotEmpty
                        ? nonRacik.first["nomor"]
                        : "-",
                  ),
                  const SizedBox(height: 20),
                  _AntrianCard(
                    title: "Racikan",
                    currentNumber: racik.isNotEmpty
                        ? racik.first["nomor"]
                        : "-",
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 🔹 CARD COMPONENT
// ============================================================
class _AntrianCard extends StatelessWidget {
  final String title;
  final String currentNumber;

  const _AntrianCard({
    required this.title,
    required this.currentNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8BC0),
              fontFamily: 'LexendExa',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2E8BC0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                currentNumber,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E8BC0),
                  letterSpacing: 1.5,
                  fontFamily: 'LexendExa',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
