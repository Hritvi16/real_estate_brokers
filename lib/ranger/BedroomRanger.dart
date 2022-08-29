import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';

class BedroomRanger extends StatefulWidget {
  const BedroomRanger({Key? key}) : super(key: key);

  @override
  State<BedroomRanger> createState() => _BedroomRangerState();
}

class _BedroomRangerState extends State<BedroomRanger> {

  double lowerValue = 0.0;
  double upperValue = 10.0;



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
              Text(
                "${int.parse(lowerValue.round().toString())} BHK",
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RangeSliderFlutter(
                values: [lowerValue],
                rangeSlider: false,
                tooltip: RangeSliderFlutterTooltip(
                  alwaysShowTooltip: false,
                ),
                max: 50,
                handlerWidth: 25,
                textColor: Colors.white,
                textPositionTop: 100,
                touchSize: 5,
                trackBar:RangeSliderFlutterTrackBar(
                  activeTrackBarHeight: 5,
                  inactiveTrackBarHeight: 5,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyColors.colorPrimary,
                  ),
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),

                min: 0,
                fontSize: 15,
                textBackgroundColor: MyColors.colorPrimary,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  this.lowerValue = lowerValue;
                  this.upperValue = upperValue;
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  String low = int.parse(lowerValue.round().toString()).toString();
                  Navigator.pop(context, low);
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
