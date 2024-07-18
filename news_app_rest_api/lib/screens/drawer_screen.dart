import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/data_list.dart';
import '../controllers/home_controllers.dart';
import '../components/dropdown_widget.dart';

// ignore: must_be_immutable
class FilterDrawer extends StatelessWidget {
  final TextEditingController countryController;
  final TextEditingController categoryController;
  final TextEditingController fromDateController;
  final TextEditingController toDateController;
  DateTime? fromDate;
  DateTime? toDate;

  FilterDrawer({
    super.key,
    required this.countryController,
    required this.categoryController,
    required this.fromDateController,
    required this.toDateController,
    this.fromDate,
    this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 148, 180, 206),
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Center(
              child: Icon(Icons.newspaper_rounded,
                  size: 60, color: Color.fromARGB(255, 104, 97, 105)),
            ),
          ),
          DropdownField(
            controller: countryController,
            hintText: "Country",
            items: DataList.countries,
          ),
          DropdownField(
            controller: categoryController,
            hintText: "Category",
            items: DataList.categories,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.00, horizontal: Get.width * 0.02),
            child: TextField(
              controller: fromDateController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "From Date",
                hintStyle: TextStyle(fontSize: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: fromDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  fromDate = pickedDate;
                  fromDateController.text =
                      pickedDate.toLocal().toString().split(' ')[0];

                  if (toDate != null && toDate!.isBefore(pickedDate)) {
                    toDate = null;
                    toDateController.clear();
                  }
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Get.height * 0.01, horizontal: Get.width * 0.02),
            child: TextField(
              controller: toDateController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "To Date",
                hintStyle: TextStyle(fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: toDate ?? DateTime.now(),
                  firstDate: fromDate ?? DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  toDate = pickedDate;
                  toDateController.text =
                      pickedDate.toLocal().toString().split(' ')[0];
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Get.height * 0.03,
                left: Get.width * 0.05,
                right: Get.width * 0.05,
                bottom: Get.height * 0.01),
            child: SizedBox(
              height: Get.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  _submitFilters();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 213, 25, 25)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: const Text('Submit',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Get.width * 0.05,
              right: Get.width * 0.05,
              top: Get.height * 0.02,
              bottom: Get.height * 0.01,
            ),
            child: SizedBox(
              height: Get.height * 0.05,
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 40, 37, 37)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ))),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitFilters() {
    final countryCode = countryController.text.trim();
    final category = categoryController.text.trim();
    final fromDateStr = fromDateController.text.trim();
    final toDateStr = toDateController.text.trim();

    final fromDate =
        fromDateStr.isNotEmpty ? DateTime.parse(fromDateStr) : DateTime.now();
    final toDate =
        toDateStr.isNotEmpty ? DateTime.parse(toDateStr) : DateTime.now();

    final fromDateTime = DateTime(
      fromDate.year,
      fromDate.month,
      fromDate.day,
    );
    final toDateTime = DateTime(
      toDate.year,
      toDate.month,
      toDate.day,
    );

    Get.find<HomeController>().getNewsByDate(
      fromDateTime,
      toDateTime,
      countryCode,
      category,
    );
    Get.back();
  }
}
