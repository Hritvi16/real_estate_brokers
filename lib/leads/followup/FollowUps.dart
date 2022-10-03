import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/database/DatabaseHandler.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/main.dart';
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:real_estate_brokers/widgets/Styles.dart';
import 'package:real_estate_brokers/widgets/Widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;

class FollowUps extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  final String id;
  final String name;
  final List<FollowUp>? followUps;
  const FollowUps({Key? key, required this.broker, required this.colorPrimary, required this.id, required this.name, required this.followUps}) : super(key: key);

  @override
  State<FollowUps> createState() => _FollowUpsState();
}

class _FollowUpsState extends State<FollowUps> {
  late Color colorPrimary;
  late Broker broker;
  Widgets w = Widgets();
  Styles s = Styles();

  List<FollowUp> all = [];
  List<FollowUp> filterFollowUp = [];
  List<FollowUp> followUps = [];

  bool load = false;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController search = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  DateTime ddate = DateTime.now();
  
  late DatabaseHandler handler;
  late Database database;

  List<String> filter1 = [
    "All",
    "Today",
    "Tomorrow",
    "Day After Tomorrow"
  ];

  List<String> filter2 = [
    "All",
    "Expired [C]",
    "Expired [NC]",
    "Completed"
  ];

  String fil1 = "All";
  String fil2 = "All";

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
    if(widget.followUps!=null) {
      followUps = widget?.followUps??[];
      all.addAll(followUps);
      filterFollowUp.addAll(followUps);

      load = true;
    }
    else {
      getFollowUps();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.generateMaterialColor(colorPrimary),
        primaryColor: colorPrimary,
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: MyColors.black),
          color: colorPrimary,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorPrimary,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      home: load ? Scaffold(
        appBar: AppBar(
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
            "Follow Up Task",
            style: TextStyle(
              color: MyColors.white
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButton: widget.followUps==null ? FloatingActionButton(
          onPressed: () {
            name.text = "";
            details.text = "";
            date.text = "";
            time.text = "";

            ddate = DateTime.now();
            setState(() {

            });
            addFollowUpForm(APIConstant.add, widget.id);
          },
          backgroundColor: colorPrimary,
          child: Icon(
            Icons.add,
            color: MyColors.white,
          ),
        ) : null,
        body: Container(
          width: MySize.size100(context),
          height: MySize.sizeh100(context),
          color: colorPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MySize.size75(context),
                margin: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  onChanged: (value) {
                    if(value.isNotEmpty) {
                      searchFollowUps(value);
                    }
                    else {
                      filterFollowUp = followUps;
                      setState(() {

                      });
                    }
                  },
                  controller: search,
                  cursorColor: Colors.black,
                  decoration:  const InputDecoration(
                    hintText: "Search Follow Ups",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.black), //<-- SEE HERE
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MySize.size50(context),
                    padding: EdgeInsets.symmetric(horizontal: MySize.size2_5(context)),
                    child:
                    DropdownButton<String>(
                      value: fil1,
                      elevation: 16,
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: MyColors.white,
                      ),
                      dropdownColor: colorPrimary,
                      underline: Container(),
                      style:  TextStyle(color: MyColors.white),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          fil1 = value!;
                        });
                        filterFollowUps();
                        // getLeads("2");
                      },
                      items: filter1.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style:  TextStyle(color: MyColors.white) ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: MySize.size50(context),
                    padding: EdgeInsets.symmetric(horizontal: MySize.size2_5(context)),
                    child:
                    DropdownButton<String>(
                      value: fil2,
                      elevation: 16,
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: MyColors.white,
                      ),
                      dropdownColor: colorPrimary,
                      underline: Container(),
                      style:  TextStyle(color: MyColors.white),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          fil2 = value!;
                        });
                        filterFollowUps();
                        // getLeads("2");
                      },
                      items: filter2.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style:  TextStyle(color: MyColors.white) ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: MySize.sizeh100(context),
                  width: MySize.size100(context),
                  decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: filterFollowUp.isNotEmpty ? ListView.separated(
                        itemCount: filterFollowUp.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext buildContext, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext buildContext, int index) {
                          return getFollowUpCard(filterFollowUp[index]);
                        },
                      )
                          : const Center(
                        child: Text(
                            "No follow ups"
                        ),
                      ),
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      )
      : Container(
        alignment: Alignment.center,
        color: MyColors.white,
        child: CircularProgressIndicator(
          color: colorPrimary,
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

  getActionCard(String action, String contact, IconData iconData, Color color) {
    return GestureDetector(
      onTap: () {
        if(action=="call") {
          Essential().call(contact);
        }
        else if(action=="sms") {
          Essential().sms(contact);
        }
        else if(action=="whatsapp") {
          Essential().whatsapp(contact.replaceAll("+", ""), context);
        }
        else {
          Essential().email(contact);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColors.white
        ),
        child: Icon(
          iconData,
          color: color,
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
                                          addFollowUp(act, id);
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
        if(widget.followUps!=null) {
          Navigator.pop(context, "reload");
        }
        else {
          getFollowUps();
        }
      }
    });
  }

  getTimeDifference(String datetime) {
    DateTime dateTime = DateTime.parse(datetime);

    DateTime now = DateTime.now();
    Duration duration = dateTime.difference(now);

    if(duration.inDays>=1 || (dateTime.day-now.day)>1) {
      return DateFormat("MMM dd yyyy, hh:mm a").format(dateTime);
    }
    else if(duration.inDays==2 || duration.inHours>12) {
      return "Tomorrow, "+DateFormat("hh:mm a").format(dateTime);
    }
    else if(duration.inDays==1 || duration.inHours>12) {
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

  getFollowUps() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getByBID;
    data['id'] = widget.broker.id??"";
    data['lp_id'] = widget.id;

    FollowUpResponse followUpResponse = await APIService().getFollowUps(data);
    followUps = followUpResponse.followUp ?? [];

    all.addAll(followUps);
    filterFollowUp.addAll(followUps);

    load = true;
    setState(() {

    });

    searchFollowUps(search.text);
  }

  Future<void> addFollowUp(String act, String id) async {
    Map<String, String> data = {
      APIConstant.act : act,
      "id" : id,
      "name" : name.text,
      "details" : details.text,
      "datetime" : ddate.toString(),
      "created_by" : widget.broker.id??"",
    };
    
    Response response = await APIService().addFollowUp(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      if(act==APIConstant.add) {
        await handler.addFollowUp(
            database,
            {
              "db_id": response.data,
              "name": name.text,
              "details": details.text,
              "datetime": ddate.toString(),
              "status": "0"
            });
        scheduleNotification(response.data??0, name.text, details.text, ddate.toString());
      }
      else {
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
  }

  Future<void> updateFollowUpStatus(FollowUp followUp) async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.updateStatus,
      "id" : followUp.id??"",
      "status" : followUp.status=="0" ? "1" : "0",
    };

    print(data);

    Response response = await APIService().addFollowUp(data);

    Toast.sendToast(context, response.message??"");
    if(response.status=="Success") {
      followUp.status = data['status'];
      setState(() {

      });
    }
  }

  Future<void> scheduleNotification(int id, String name, String detail, String datettime)
  async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        name,
        detail.replaceAll(".", "</br>"),
        tz.TZDateTime.now(tz.local).add(DateTime.parse(datettime).difference(DateTime.now())),
         NotificationDetails(
            android: AndroidNotificationDetails
              (
                enableVibration: true,
                color: const Color.fromARGB(255, 255, 255, 255),
                playSound: true,
                'taskChannel', 'task',
                enableLights: true,
                // actions: const [
                //   AndroidNotificationAction("call", "Call"),
                //   AndroidNotificationAction("message", "Message"),
                //   AndroidNotificationAction("whatsapp", "WhatsApp"),
                // ],
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

  Future<void> deleteFollowUp(String id) async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.delete,
      "id" : id,
    };


    Response response = await APIService().deleteFollowUp(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      await handler.deleteFollowUp(
          database,
          "db_id = $id",
          );
      Navigator.pop(context, "reload");
    }
  }

  getLeads() async {
    Map<String, dynamic> data = {};

    DateTime d = DateTime.now();
    int weekDay = d.weekday;
    DateTime firstDayOfWeek = d.subtract(Duration(days: weekDay));
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));


    data[APIConstant.act] = APIConstant.getByDate;
    data['start'] = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
    data['end'] = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);
    data['id'] = broker.id??"";

    LeadDetailResponse leadDetailResponse = await APIService().getLeadsDetails(data);
    followUps = leadDetailResponse.followUp ?? [];

    all.addAll(followUps);
    filterFollowUp.addAll(followUps);

    load = true;
    setState(() {

    });
  }

  void filterFollowUps() {
    followUps = [];
    filterFollowUp = [];

    if(fil1=="All") {
      followUps.addAll(all);
      filterFollowUp.addAll(all);
    }
    else {
      for (var element in all) {
        bool add = false;
        if(fil1=="Today") {
          if(DateFormat("yyyy-MM-dd").format(DateTime.parse(element.datetime??""))==DateFormat("yyyy-MM-dd").format(DateTime.now())) {
            add = true;
          }
        }
        else if(fil1=="Tomorrow") {
          if(DateFormat("yyyy-MM-dd").format(DateTime.parse(element.datetime??""))==DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1)))) {
            add = true;
          }
        }
        else {
          if(DateFormat("yyyy-MM-dd").format(DateTime.parse(element.datetime??""))==DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 2)))) {
            add = true;
          }
        }

        if(add) {
          followUps.add(element);
          filterFollowUp.add(element);
        }
      }
    }


    List<FollowUp> followUp = [];

    if(fil2=="All") {
      followUp.addAll(followUps);
    }
    else {
      for (var element in followUps) {
        bool add = false;
        if(fil2.contains("Expired")) {
          Duration duration = DateTime.parse(element.datetime??"").difference(DateTime.now());
          if(duration.isNegative) {
            if(fil2.contains("[NC]") && element.status=="0") {
              add = true;
            }
            else if(fil2.contains("[C]") && element.status=="1") {
              add = true;
            }
          }
        }
        else {
          if(element.status=="1") {
            add = true;
          }
        }


        if(add) {
          followUp.add(element);
        }
      }
    }

    followUps = [];
    filterFollowUp = [];
    followUps.addAll(followUp);
    filterFollowUp.addAll(followUp);
  }

  void searchFollowUps(String value) {
    filterFollowUp = [];
    for (var element in followUps) {
      if(element.name!.toLowerCase().contains(value.toLowerCase())) {
        filterFollowUp.add(element);
      }
    }

    setState(() {

    });
  }
}
