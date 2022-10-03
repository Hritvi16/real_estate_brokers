import 'package:flutter/material.dart';

class Widgets {
  getText(String info, TextStyle textStyle) {
    return Text(
      info,
      style: textStyle
    );
  }

  getTextField(TextEditingController controller, String label, IconData prefix, {IconData? suffix, Function()? onTap}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix
        ),
        suffixIcon: suffix!=null ? GestureDetector(
          onTap: onTap,
          child: Icon(
            suffix
          ),
        ) : null,
      ),
    );
  }
}