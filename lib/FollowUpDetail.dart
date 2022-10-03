import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowUpDetail extends StatefulWidget {
  final String id;
  final Color colorPrimary;
  const FollowUpDetail({Key? key, required this.id, required this.colorPrimary}) : super(key: key);

  @override
  State<FollowUpDetail> createState() => _FollowUpDetailState();
}

class _FollowUpDetailState extends State<FollowUpDetail> {

  TextEditingController name = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  DateTime ddate = DateTime.now();

  bool load = false;

  late Color colorPrimary;

  FollowUp followUp = FollowUp();

  @override
  void initState() {
    colorPrimary = widget.colorPrimary;
    getFollowUp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "Follow - Ups task name",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: details,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Details",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "* Required";
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: ddate,
                          firstDate: DateTime(ddate.year-10),
                          lastDate: DateTime(ddate.year+10)
                      ).then((value) {
                        if(value!=null) {
                          ddate = DateTime(value.year, value.month, value.day, ddate.hour, ddate.minute);
                          setState(() {

                          });
                          date.text = DateFormat("dd MMM, yyyy").format(ddate);
                        }
                      });
                    },
                    controller: date,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "Date",
                        prefixIcon: Icon(
                            Icons.date_range
                        )
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: TextFormField(
                    onTap: () {
                      showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: ddate.hour, minute: ddate.minute)
                      ).then((value) {
                        if(value!=null) {
                          ddate = DateTime(ddate.year, ddate.month, ddate.day, value.hour, value.minute);
                          setState(() {

                          });
                          time.text = DateFormat("hh:mm a").format(ddate);
                        }
                      });
                    },
                    controller: time,
                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: "Time",
                        prefixIcon: Icon(
                            Icons.access_time
                        )
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* Required";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(
                        bottom: 15, left: 10, right: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          // if(act=="add") {
                          //   Navigator.pop(context);
                          // }
                          // else {
                          //   loginPopUp(id);
                          // }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(colorPrimary)
                        ),
                        child: Text("CANCEL",
                          style: TextStyle(color: MyColors.white),)
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(
                        bottom: 15, left: 10, right: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          // if (formkey.currentState!.validate()) {
                          //   addFollowUp(act, id);
                          // }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                colorPrimary)
                        ),
                        child: Text("SAVE",
                          style: TextStyle(color: MyColors.white),)
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
      : Center(
        child: CircularProgressIndicator(
          color: colorPrimary,
        ),
      ),
    );
  }

  Future<void> getFollowUp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getByID;
    data['id'] = widget.id;

    FollowUpDetailResponse followUpDetailResponse = await APIService().followUpDetail(data);
    followUp = followUpDetailResponse.followUp ?? FollowUp();


    name.text = followUp.name??"";
    details.text = followUp.details??"";
    ddate = DateTime.parse(followUp.datetime??"");
    setState(() {

    });
    date.text = DateFormat("dd MMM, yyyy").format(ddate);
    time.text = DateFormat("hh:mm a").format(ddate);

    load = true;
    setState(() {

    });
  }
}
