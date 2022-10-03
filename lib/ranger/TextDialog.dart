import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';

class TextDialog extends StatefulWidget {
  final String label;
  final Color colorPrimary;
  const TextDialog({Key? key, required this.label, required this.colorPrimary}) : super(key: key);

  @override
  State<TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<TextDialog> {

  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog(
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                cursorColor: widget.colorPrimary,
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(
                      color: widget.colorPrimary
                  )
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, name.text);
                },
                child: Text(
                  "ADD",
                  style: TextStyle(
                    color: widget.colorPrimary
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
