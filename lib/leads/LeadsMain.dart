import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/database/DatabaseHandler.dart';
import 'package:real_estate_brokers/leads/Leads.dart';
import 'package:real_estate_brokers/leads/LeadsStatus.dart';
import 'package:real_estate_brokers/leads/Schedule.dart';
import 'package:real_estate_brokers/leads/followup/FollowUps.dart';
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsMain extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  const LeadsMain({Key? key, required this.broker, required this.colorPrimary}) : super(key: key);

  @override
  State<LeadsMain> createState() => _LeadsMainState();
}

class _LeadsMainState extends State<LeadsMain> {

  List<String> titles = [
    "This Week",
    "Today",
    "Overall"
  ];

  String title = "Overall";

  late SharedPreferences sharedPreferences;
  DatabaseHandler? handler;
  Broker broker = Broker();
  List<LeadDetails> leads = [];
  List<LeadDetails> interested = [];
  List<FollowUp> followUps = [];
  List<LeadDetails> converted = [];

  DateTime sync = DateTime.now();

  bool load = false;

  Color colorPrimary = MyColors.colorPrimary;

  @override
  void initState() {
    broker = widget.broker;
    colorPrimary = widget.colorPrimary;
    handler = DatabaseHandler.instance;
    start();
    super.initState();
  }

  start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await handler!.initializeDB().whenComplete(() async {
      setState(() {});
    });

    getLeads("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          width: MySize.size50(context),
          // child: DropdownSearch<String>(
          //   popupProps: const PopupProps.menu(
          //     showSelectedItems: true,
          //     showSearchBox: false,
          //   ),
          //   dropdownDecoratorProps: DropDownDecoratorProps(
          //     dropdownSearchDecoration: const InputDecoration(
          //         border: OutlineInputBorder(
          //           borderSide: BorderSide.none
          //         )
          //     ),
          //     baseStyle: TextStyle(
          //       color: MyColors.white,
          //     )
          //   ),
          //   dropdownButtonProps: DropdownButtonProps(
          //     color: MyColors.white
          //   ),
          //   items: titles,
          //   dropdownBuilder: (BuildContext buildContext, index) {
          //     return Text(
          //       title,
          //       style: TextStyle(
          //           color: MyColors.white,
          //         )
          //     );
          //   },
          //   onChanged: (value) {
          //     title = value!;
          //     setState(() {
          //
          //     });
          //     getLeads();
          //   },
          //   selectedItem: title,
          // ),
          child: DropdownButton<String>(
            value: title,
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
                    title = value!;
                  });
                  getLeads("2");
                },
                items: titles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style:  TextStyle(color: MyColors.white) ),
                );
                }).toList(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                getLeads("sync");
              },
              child: Icon(
                Icons.sync,
                color: MyColors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: MySize.size100(context),
        height: MySize.sizeh100(context),
        color: colorPrimary,
        child: Column(
          children: [
            Container(
              height: MySize.sizeh10(context),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Last sync at : "+DateFormat("MMM dd yyyy, hh:mm a").format(sync),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: MyColors.white
                ),
              ),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    getCards("leads.png", MyColors.purple500, title+" Leads", (leads.length).toString()),
                    SizedBox(
                      height: 10,
                    ),
                    getCards("interested.png", MyColors.yellow900, "Interested", (interested.length).toString()),
                    SizedBox(
                      height: 10,
                    ),
                    getCards("followup.png", MyColors.pink800, title+" Follow Ups", (followUps.length).toString()),
                    SizedBox(
                      height: 10,
                    ),
                    getCards("converted.png", MyColors.blue900, "Converted", (converted.length).toString()),
                    SizedBox(
                      height: 20,
                    ),
                    getCards("status.png", MyColors.green500, "Leads Status", ""),
                    SizedBox(
                      height: 20,
                    ),
                    getCards("status.png", MyColors.grey, "Schedule", ""),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCards(String image, Color color, String title, String info) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () {
          if(title=="Leads Status") {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeadsStatus(
                    colorPrimary: colorPrimary,
                    broker: broker,
                  )
                )
            );
          }
          else if(title=="Schedule") {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Schedule(
                  colorPrimary: colorPrimary,
                  broker: broker,
                )
                )
            );
          }
          else if(title.contains("Leads") || title=="Interested" || title=="Converted") {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Leads(
                    colorPrimary: colorPrimary,
                    broker: broker,
                    leads: title.contains("Leads") ? leads : title=="Interested" ? interested : converted,
                    status: title=="Interested" ? title : "",
                    act: APIConstant.getByBID,
                    id: broker.id??"",
                  )
                )
            ).then((value) {
              // print(value);
              // if(value=="reload") {
              //   load = false;
              //   setState(() {
              //
              //   });
              //   getLeads();
              // }
            });
          }
          else {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FollowUps(
                    id: "",
                    name: "",
                    colorPrimary: colorPrimary,
                    broker: broker,
                    followUps: followUps,
                  )
                )
            ).then((value) {
              print(value);
              if(value=="reload") {
                load = false;
                setState(() {

                });
                getLeads("");
              }
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: MySize.size3(context)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.6),
                    color.withOpacity(0.8),
                    color,
                  ]

              ),
              borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getTitle(title),
                    SizedBox(
                      height: 5,
                    ),
                    getSubTitle(info),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Image.asset(
                "assets/lead/$image"
              )
            ],
          ),
        ),
      ),
    );
  }

  getIconCard(String image, Color color) {
    return Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(7)
      ),
      child: Image.asset(
        "assets/lead/$image",
        height: 30,
        width: 30,
      ),
    );
  }

  getTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          color: MyColors.white
        ),
      ),
    );
  }

  getSubTitle(String subTitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        subTitle,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyColors.white
        ),
      ),
    );
  }

  getLeads(String value) async {
    Map<String, dynamic> data = {};

    DateTime d = DateTime.now();
    int weekDay = d.weekday;
    DateTime firstDayOfWeek = d.subtract(Duration(days: weekDay));
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));


    data[APIConstant.act] = title=="Overall" ? APIConstant.getByBID : APIConstant.getByDate;
    data['start'] = title=="Today" ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
    data['end'] = title=="Today" ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : DateFormat('yyyy-MM-dd').format(lastDayOfWeek);
    data['id'] = broker.id??"";
    print(data);


    LeadDetailResponse leadDetailResponse = await APIService().getLeadsDetails(data);
    print(leadDetailResponse.toJson());
    leads = leadDetailResponse.leadDetails ?? [];
    followUps = leadDetailResponse.followUp ?? [];

    interested = [];
    converted = [];

    for (var element in leads) {
      if(element.criteria?.status=="Interested") {
        interested.add(element);
      }
      else if(element.criteria?.status=="Converted") {
        converted.add(element);
      }
    }

    load = true;
    sync = DateTime.now();
    setState(() {

    });
    print(data);
    if(value=="sync")
      Toast.sendToast(context, "Synced");
  }
}
