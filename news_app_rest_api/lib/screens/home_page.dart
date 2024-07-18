import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controllers.dart';
import 'drawer_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final homeController = Get.put(HomeController());

    final TextEditingController countryController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController fromDateController = TextEditingController();
    final TextEditingController toDateController = TextEditingController();
    DateTime? fromDate;
    DateTime? toDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("News", style: TextStyle(fontSize: 28)),
        backgroundColor: const Color.fromARGB(255, 148, 180, 206),
      ),
      drawer: FilterDrawer(
        countryController: countryController,
        categoryController: categoryController,
        fromDateController: fromDateController,
        toDateController: toDateController,
        fromDate: fromDate,
        toDate: toDate,
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeController.articlesList.isEmpty) {
          return const Center(child: Text("No news available"));
        } else {
          return ListView.builder(
            itemCount: homeController.articlesList.length,
            itemBuilder: (context, index) {
              final article = homeController.articlesList[index];

              return GestureDetector(
                onTap: () {
                  homeController.launchURL(article.url);
                },
                child: Column(children: [
                  Stack(
                    children: [
                      Image.network(
                        article.urlToImage ?? "",
                        width: screenWidth,
                        height: screenHeight * 0.3,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset("assets/images/no_image2.png",
                                width: screenWidth,
                                height: screenHeight * 0.3,
                                fit: BoxFit.cover),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              color: Colors.black54.withOpacity(0.45),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Text(
                                article.title ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )))
                    ],
                  )
                ]),
              );
            },
          );
        }
      }),
    );
  }
}
