import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData iconData;
  final String? assetRefrence;
  final String lableString;
  final bool isObscure;
  final ValueChanged<String>? onChanged;

  const TextInputWidget(
      {super.key,
      required this.textEditingController,
      required this.iconData,
      this.assetRefrence,
      required this.lableString,
      required this.isObscure,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onChanged: onChanged,

      decoration: InputDecoration(
        labelText: lableString,
        prefixIcon: Icon(iconData),

        // Icon phía trước
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
