import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData iconData;
  final String? assetRefrence;
  final String lableString;
  final bool isObscure;

  const TextInputWidget(
      {super.key,
      required this.textEditingController,
      required this.iconData,
      this.assetRefrence,
      required this.lableString,
      required this.isObscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: lableString,
        prefixIcon: Icon(iconData), // Icon phía trước
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      obscureText: isObscure, //Ẩn password
    );
  }
}
