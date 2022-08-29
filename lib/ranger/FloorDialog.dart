import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';

class FloorDialog extends StatefulWidget {
  const FloorDialog({Key? key}) : super(key: key);

  @override
  State<FloorDialog> createState() => _FloorDialogState();
}

class _FloorDialogState extends State<FloorDialog> {

  TextEditingController floor = TextEditingController();
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
                controller: floor,
                decoration: InputDecoration(
                  labelText: "Floor",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, floor.text);
                },
                child: const Text(
                  "ADD"
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
