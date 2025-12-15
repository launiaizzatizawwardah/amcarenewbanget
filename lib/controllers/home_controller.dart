import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/slider_model.dart';
import '../models/layanan_model.dart';

class HomeController extends GetxController {
  var sliders = <SliderModel>[].obs;
  var layananList = <Layanan>[].obs;
  var isLoadingSlider = true.obs;
  var isLoadingLayanan = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSlider();
    fetchLayanan();
  }

  Future<void> fetchSlider() async {
    const url = 'https://admin.rsamcmuhammadiyah.com/api/slider';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'];
        sliders.value = list.map((e) => SliderModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetch slider: $e');
    } finally {
      isLoadingSlider(false);
    }
  }

  Future<void> fetchLayanan() async {
    const url = 'https://admin.rsamcmuhammadiyah.com/api/layanan';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'];
        layananList.value = list.map((e) => Layanan.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetch layanan: $e');
    } finally {
      isLoadingLayanan(false);
    }
  }
}
