import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'colors/MyColors.dart';

class DropdownDialog extends StatelessWidget {
  final List<String> items, ignore;
  final String title;
  const DropdownDialog({Key? key, required this.items, required this.title, required this.ignore, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: DropdownSearch<String>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            disabledItemFn: (String s) => ignore.contains(s),
            showSearchBox: true,
          ),
          items: items,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                labelText: "Search In $title",
                prefixIcon: const Icon(
                    Icons.search
                )
            ),
          ),
          onChanged: (value) {
            Navigator.pop(context, value);
          },
        ),
      ),
    );
  }
}
