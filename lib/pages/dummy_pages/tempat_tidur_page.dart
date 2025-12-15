import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/tempat_tidur_controller.dart';
import '/routes/app_routes.dart';

class TempatTidurPage extends StatelessWidget {
  final controller = Get.put(TempatTidurController());

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  BackButton(color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    "Ketersediaan Tempat Tidur",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'LexendExa',
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 0),
            child: Obx(() {
              final list = controller.listBangsal;

              if (list.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  final item = list[index];

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.detailTempatTidur,
                        arguments: item,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.namaRuang,
                            style: const TextStyle(
                              color: Color(0xFF2E8BC0),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'LexendExa',
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.bed,
                                color: Colors.black54,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${item.tersedia} Tersedia",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'LexendExa',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
