import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';

class SQFTRanger extends StatefulWidget {
  final Color colorPrimary;
  const SQFTRanger({Key? key, required this.colorPrimary}) : super(key: key);

  @override
  State<SQFTRanger> createState() => _SQFTRangerState();
}

class _SQFTRangerState extends State<SQFTRanger> {

  double lowerValue = 0.0;
  double upperValue = 2.0;



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
              Row(
                children: [
                  Text(
                    int.parse(getValue(lowerValue).round().toString()).toString(),
                    style: const TextStyle(
                        fontSize: 20
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "to",
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    int.parse(getValue(upperValue).round().toString()).toString(),
                    style: const TextStyle(
                        fontSize: 20
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RangeSliderFlutter(
                values: [lowerValue, upperValue],
                rangeSlider: true,
                tooltip: RangeSliderFlutterTooltip(
                  alwaysShowTooltip: false,
                ),
                max: 32,
                handlerWidth: 25,
                textColor: Colors.white,
                textPositionTop: 100,
                touchSize: 5,
                trackBar:RangeSliderFlutterTrackBar(
                  activeTrackBarHeight: 5,
                  inactiveTrackBarHeight: 5,
                  activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.colorPrimary,
                  ),
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),

                min: 0,
                fontSize: 15,
                textBackgroundColor: widget.colorPrimary,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  this.lowerValue = lowerValue;
                  this.upperValue = upperValue;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  String low = int.parse(getValue(lowerValue).round().toString()).toString();
                  String up = int.parse(getValue(upperValue).round().toString()).toString();
                  String amt = "$low-$up";
                  print(amt);
                  Navigator.pop(context, amt);
                },
                child: Text(
                  "ADD"
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  double getValue(double value) {
    if(value>=0 &&  value<=5) {
      return value * 100.0;
    }
    else if(value>=6 &&  value<=14) {
      return ((5 * 100) + (value - 5) * 500.0);
    }
    else if(value>=15 &&  value<=19) {
      return ((5 * 100) + (9 * 500.0) + (value - 14) * 1000.0);
    }
    else if(value>=20 &&  value<=27) {
      return ((5 * 100) + (9 * 500.0) + (5 * 1000.0) + (value - 19) * 5000.0);
    }
    else {
      return ((5 * 100) + (9 * 500.0) + (5 * 1000.0) + (8 * 5000.0) + (value - 27) * 10000.0);
    }
  }


  String getWrittenValue(double value) {
    double amount = getValue(value);

    String amt = "";
    //
    // if(amount==0) {
    //   amt = amount.toString();
    // }
    // else if(amount>0 && )
    if(amount >= 1000000000) {
      amt = '${(amount / 10000000).toStringAsFixed(2)}+Cr';
    }
    else if (amount >= 10000000) {
      amt = '${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) {
      amt = '${(amount / 100000).toStringAsFixed(2)}L';
    }else if (amount >= 1000) {
      amt = '${(amount / 1000).toStringAsFixed(2)}k';
    }
    else {
      amt = '0';
    }
    return amt;
  }

}
