import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';
import '../screens/drawer_screen.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  var articlesList = <Articles>[].obs;
  var isLoading = false.obs;

  final countryController = TextEditingController();
  final categoryController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    countryController.dispose();
    categoryController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.onClose();
  }

  Future<void> launchURL(String? url) async {
    if (url == null) return;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }

  void showCountryCategoryDialog(BuildContext context) {
    FilterDrawer(
        countryController: countryController,
        categoryController: categoryController,
        fromDateController: fromDateController,
        toDateController: toDateController);
  }

  void fetchData({
    String country = 'us',
    String category = 'business',
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    isLoading(true);

    List<Articles> articles = await ApiService.getNews(
      country: country,
      category: category,
      fromDate: fromDate,
      toDate: toDate,
    );
    articlesList.value = articles;

    isLoading(false);
  }

  void getNewsByDate(
      DateTime fromDate, DateTime toDate, String country, String category) {
    fetchData(
        fromDate: fromDate,
        toDate: toDate,
        country: country,
        category: category);
  }
}
