import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/toast/Toast.dart';

class BudgetRanger extends StatefulWidget {
  final String looking;
  const BudgetRanger({Key? key, required this.looking}) : super(key: key);

  @override
  State<BudgetRanger> createState() => _BudgetRangerState();
}

class _BudgetRangerState extends State<BudgetRanger> {

  double lowerValue = 0;
  double upperValue = 4;



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
                    Environment.rupee + getWrittenValue(lowerValue),
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
                    Environment.rupee + getWrittenValue(upperValue),
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
                max: 127,
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
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  if(upperValue!=0) {
                    String low = getWrittenValue(lowerValue);
                    String up = getWrittenValue(upperValue);
                    String llast = low.substring(low.length - 1);
                    String ulast = up.substring(up.length - 1);
                    String amt;

                    if (low == up && low=="100+Cr") {
                      amt = "100+Cr";
                    }
                    else if(llast == ulast) {
                      amt = "${low.substring(0, low.length - (llast == 'r' ? 2 : 1))}-$up";
                    }
                    else {
                      amt = "$low-$up";
                    }
                    print(amt);
                    Navigator.pop(context, amt);
                  }
                  else {
                    Toast.sendToast(context, "Invalid Range");
                  }
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
    if(value>=0 &&  value<=10) {
      return value * 5000.0;
    }
    else if(value>=11 &&  value<=28) {
      return ((10 * 5000) + (value - 10) * 25000.0);
    }
    else if(value>=29 &&  value<=67) {
      return ((10 * 5000) + (18 * 25000.0) + (value - 28) * 500000.0);
    }
    else if(value>=68 &&  value<=97) {
      return ((10 * 5000) + (18 * 25000.0) + (39 * 500000.0) + (value - 67) * 1000000.0);
    }
    else if(value>=98 &&  value<=118) {
      return ((10 * 5000) + (18 * 25000.0) + (39 * 500000.0) + (30 * 1000000.0) + (value - 98) * 2500000.0);
    }
    else {
      return ((10 * 5000) + (18 * 25000.0) + (39 * 500000.0) + (30 * 1000000.0) + (20 * 2500000.0) + (value - 118) * 100000000.0);
    }
  }


  String getWrittenValue(double value) {
    double amount = getValue(value);

    String amt = "0";
    double a = 0;
    if(amount >= 1000000000) {
      a = amount / 10000000;
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toString()}+Cr';
    }
    else if (amount >= 10000000) {
      a = amount / 10000000;
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toString()}Cr';
    } else if (amount >= 100000) {
      a = amount / 100000;
      print(a.toString().substring(a.toString().indexOf(".")+1));
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toString()}L';
    }else if (amount >= 1000) {
      a = amount / 1000;
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toString()}k';
    }
    else {
      amt = '0';
    }
    return amt;
  }

}
