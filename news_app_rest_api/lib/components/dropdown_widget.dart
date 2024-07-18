import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Map<String, String> items;

  DropdownField({
    required this.controller,
    required this.hintText,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.01, horizontal: Get.width * 0.02),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? null : controller.text,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        items: items.entries.map((value) {
          return DropdownMenuItem<String>(
            value: value.key,
            child: Text('${value.value} ${value.key}'),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.text = newValue;
          }
        },
      ),
    );
  }
}
