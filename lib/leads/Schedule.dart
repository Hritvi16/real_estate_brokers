import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/database/DatabaseHandler.dart';
import 'package:real_estate_brokers/main.dart';
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;

class Schedule extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  const Schedule({Key? key, required this.broker, required this.colorPrimary}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  Color colorPrimary = MyColors.colorPrimary;
  Broker broker = Broker();
  late SharedPreferences sharedPreferences;

  DateTime dateTime = DateTime.now();
  List<DateTime> dates = [];

  List<FollowUp> followUps = [];

  TextEditingController name = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  DateTime ddate = DateTime.now();

  bool load = false;

  late DatabaseHandler handler;
  late Database database;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    date.text = DateFormat("dd MMM, yyyy").format(ddate);
    time.text = DateFormat("hh:mm a").format(ddate);
    colorPrimary = widget.colorPrimary;
    broker = widget.broker;

    handler = DatabaseHandler.instance;
    start();
    super.initState();
  }

  start() async {
    database = await handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
    setDates();
    getFollowUps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: MyColors.white,
          ),
        ),
        title: Text(
          "Schedule",
          style: TextStyle(
              color: MyColors.white
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        width: MySize.size100(context),
        height: MySize.sizeh100(context),
        color: colorPrimary,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getDateTitle(DateFormat("MMM, yyyy").format(dateTime),),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          DateTime date = DateTime(dateTime.year, dateTime.month-1);
                          if(dateTime.day<=28) {
                            dateTime = DateTime(dateTime.year, dateTime.month-1, dateTime.day);
                          }
                          else {
                            if(dateTime.day<=DateTimeRange(start: date, end: DateTime(date.year, date.month+1, 1)).duration.inDays) {
                              dateTime = DateTime(dateTime.year, dateTime.month-1, dateTime.day);
                            }
                            else {
                              dateTime = DateTime(dateTime.year, dateTime.month, 0);
                            }
                          }
                          load = false;
                          setState(() {

                          });
                          setDates();
                          getFollowUps();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          padding: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: MyColors.white)
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: MyColors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          // dateTime = DateTime(dateTime.year, dateTime.month+1);
                          // setState(() {
                          //
                          // });
                          // setDates();
                          DateTime date = DateTime(dateTime.year, dateTime.month+1);
                          if(dateTime.day<=28) {
                            dateTime = DateTime(dateTime.year, dateTime.month+1, dateTime.day);
                          }
                          else {
                            if(dateTime.day<=DateTimeRange(start: date, end: DateTime(date.year, date.month+1, 1)).duration.inDays) {
                              dateTime = DateTime(dateTime.year, dateTime.month+1, dateTime.day);
                            }
                            else {
                              dateTime = DateTime(dateTime.year, dateTime.month+2, 0);
                            }
                          }
                          load = false;
                          setState(() {

                          });
                          setDates();
                          getFollowUps();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          padding: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: MyColors.white)
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: MyColors.white,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (BuildContext buildContext, int index) {
                  return SizedBox(width: 10,);
                },
                itemBuilder: (BuildContext buildContext, int index) {
                  return getDateCard(dates[index]);
                },
              ),
            ),
            Flexible(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    )
                ),
                padding:  EdgeInsets.symmetric(horizontal: MySize.size5(context), vertical: 10),
                child: load ? followUps.isNotEmpty ? ListView.separated(
                  itemCount: followUps.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext buildContext, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext buildContext, int index) {
                    return getFollowUpCard(followUps[index]);
                  },
                )
                    : const Center(
                  child: Text(
                      "No Follow Ups"
                  ),
                ) : Center(
                  child: CircularProgressIndicator(
                    color: colorPrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  getDateCard(DateTime date) {
    return GestureDetector(
      onTap: () {
        dateTime = date;
        load = false;
        setState(() {

        });
        getFollowUps();
      },
      child: Container(
        height: 60,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dateTime.day==date.day ? MyColors.generateMaterialColor(colorPrimary).shade800 : MyColors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(7.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              DateFormat("EEE").format(date),
              style: TextStyle(
                color: dateTime.day==date.day ? MyColors.white : MyColors.grey
              ),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: dateTime.day==date.day ? MyColors.white : MyColors.generateMaterialColor(colorPrimary).shade800,
                fontWeight: FontWeight.w600
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getFollowUpCard(FollowUp followUp) {
    return GestureDetector(
      onTap: () {

        name.text = followUp.name??"";
        details.text = followUp.details??"";
        ddate = DateTime.parse(followUp.datetime??"");
        setState(() {

        });
        date.text = DateFormat("dd MMM, yyyy").format(ddate);
        time.text = DateFormat("hh:mm a").format(ddate);
        addFollowUpForm(APIConstant.update, followUp.id??"");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MySize.size5(context)),
        decoration: BoxDecoration(
            color: followUp.status=="1" ? MyColors.grey10 : MyColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.grey10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 1.0,
              ),
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSubTitle(DateFormat("MMM dd yyyy, hh:mm a").format(DateTime.parse(followUp?.createdAt??"")), Alignment.centerRight),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: followUp.status=="1",
                  onChanged: (value) {
                    updateFollowUpStatus(followUp);
                  },
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTitle(followUp?.name??""),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          getColorText(getTimeDifference(followUp.datetime??""), getColor(followUp.datetime??""), 13),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.grey,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: getSubTitle(followUp.leadName??"", Alignment.centerLeft),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      getColorText("Created by ${widget.broker.id==followUp.createdBy ? "You" : followUp.createdName??""}", MyColors.green500, 12),
                      followUp.status=="0" ?
                      Container(
                        height: 35,
                        margin: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                            onPressed: () {
                              updateFollowUpStatus(followUp);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(MyColors.green500)
                            ),
                            child: Text("MARK  AS  COMPLETE",
                              style: TextStyle(
                                  color: MyColors.white,
                                  fontSize: 10
                              ),
                            )
                        ),
                      )
                          : const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "This follow up has been completed.",
                          style: TextStyle(
                              fontSize: 13
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  addFollowUpForm(String act, String id) {
    showModalBottomSheet<dynamic>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
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
                                        if(act=="add") {
                                          Navigator.pop(context);
                                        }
                                        else {
                                          loginPopUp(id);
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(colorPrimary)
                                      ),
                                      child: Text(act=="add" ? "CANCEL" : "DELETE",
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
                                        if (formkey.currentState!.validate()) {
                                          addFollowUp(id);
                                        }
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
                    ),
                  ),
                ),
              );
            }
        );
      },
    ).then((value) {
      if(value=="reload") {
        load = false;
        setState(() {

        });
        getFollowUps();
      }
    });
  }

  loginPopUp(String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return LoginPopUp(
          text: "Are you sure you want to delete?",
          btn1 : "No",
          btn2: "Yes", colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if(value=="Yes")
        deleteFollowUp(id);
    });
  }

  getTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  getSubTitle(String subTitle, AlignmentGeometry alignmentGeometry) {
    return Align(
      alignment: alignmentGeometry,
      child: Text(
        subTitle,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
      ),
    );
  }


  getColorText(String subTitle, Color color, double size) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        subTitle,
        style: TextStyle(
            fontSize: size,
            color: color
        ),
      ),
    );
  }

  getTimeDifference(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    DateTime now = DateTime.now();
    Duration duration = dateTime.difference(now);

    print("datetime");
    print(datetime);
    print(duration.inDays);
    print(duration.inHours);
    print(duration.inMinutes);

    if(duration.inDays.abs()>=1 || (dateTime.day-now.day)>1) {
      return DateFormat("MMM dd yyyy, hh:mm a").format(dateTime);
    }
    else if(duration.inDays.abs()==2 || duration.inHours.abs()>24) {
      return "Tomorrow, "+DateFormat("hh:mm a").format(dateTime);
    }
    else if(duration.inDays.abs()==1 || duration.inHours.abs()>12) {
      // return "${duration.isNegative ? "" : "In "}${duration.inHours.abs()} Hours${duration.isNegative ? " Ago" : ""}";
      return "Today, "+DateFormat("hh:mm a").format(dateTime);
    }
    else if(duration.inHours.abs()>0) {
      return "${duration.isNegative ? "" : "In "}${duration.inHours.abs()} Hours${duration.isNegative ? " Ago" : ""}";
    }
    else {
      return "${duration.isNegative ? "" : "In "}${duration.inMinutes.abs()} Minutes${duration.isNegative ? " Ago" : ""}";
    }
  }

  getColor(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);
    Duration duration = dateTime.difference(DateTime.now());

    return duration.isNegative ? MyColors.red : MyColors.orange;
  }

  setDates() {
    dates = [];
    for(int i = 1; i<=DateTime(dateTime.year, dateTime.month+1, 0).day; i++) {
      dates.add(DateTime(dateTime.year, dateTime.month, i));
    }
    setState(() {

    });
  }


  getDateTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: MyColors.white
      ),
    );
  }

  Future<void> updateFollowUpStatus(FollowUp followUp) async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.updateStatus,
      "id" : followUp.id??"",
      "status" : followUp.status=="0" ? "1" : "0",
    };


    Response response = await APIService().addFollowUp(data);

    Toast.sendToast(context, response.message??"");
    if(response.status=="Success") {
      followUp.status = data['status'];
      setState(() {

      });
    }
  }

  Future<void> deleteFollowUp(String id) async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.delete,
      "id" : id,
    };


    Response response = await APIService().deleteFollowUp(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      Navigator.pop(context, "reload");
    }
  }

  getFollowUps() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getByDate;
    data['id'] = widget.broker.id??"";
    data['date'] = DateFormat("yyyy-MM-dd").format(dateTime);

    print(data);

    FollowUpResponse followUpResponse = await APIService().getFollowUps(data);
    followUps = followUpResponse.followUp ?? [];

    load = true;
    setState(() {

    });
  }

  Future<void> addFollowUp(String id) async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.update,
      "id" : id,
      "name" : name.text,
      "details" : details.text,
      "datetime" : ddate.toString(),
      "created_by" : widget.broker.id??"",
    };

    Response response = await APIService().addFollowUp(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      print(response.data);
      await handler.updateFollowUp(
          database,
          {
            "db_id": id,
            "name": name.text,
            "details": details.text,
            "datetime": ddate.toString(),
          });
      scheduleNotification(int.parse(id), name.text, details.text, ddate.toString());
    }
    Navigator.pop(context, "reload");
  }

  Future<void> scheduleNotification(int id, String name, String detail, String datettime)
  async {
    print("scheduled");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        name,
        detail,
        tz.TZDateTime.now(tz.local).add(DateTime.parse(datettime).difference(DateTime.now())),
        NotificationDetails(
            android: AndroidNotificationDetails
              (
                enableVibration: true,
                color: const Color.fromARGB(255, 255, 255, 255),
                playSound: true,
                'taskChannel', 'task',
                enableLights: true,
                actions: const [
                  // AndroidNotificationAction("call", "Call"),
                  // AndroidNotificationAction("message", "Message"),
                  // AndroidNotificationAction("whatsapp", "WhatsApp"),
                ],
                styleInformation: BigTextStyleInformation(
                  // sharedPreferences.getString("company")??"",
                  detail,
                  htmlFormatBigText: true,
                  htmlFormatContent: true,
                  htmlFormatContentTitle: true,
                  htmlFormatTitle: true,
                  contentTitle: name,
                  // summaryText: notification.body,
                ),
                icon: "app_icon",
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,

        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

}


