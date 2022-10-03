import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/leads/deal/Deals.dart';
import 'package:real_estate_brokers/leads/followup/FollowUps.dart';
import 'package:real_estate_brokers/leads/status/StatusList.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/widgets/Styles.dart';
import 'package:real_estate_brokers/widgets/Widgets.dart';

class LeadDetail extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  final LeadDetails leadDetails;
  const LeadDetail({Key? key, required this.broker, required this.colorPrimary, required this.leadDetails}) : super(key: key);

  @override
  State<LeadDetail> createState() => _LeadDetailState();
}

class _LeadDetailState extends State<LeadDetail> {
  late Broker broker;
  late Color colorPrimary;
  late LeadDetails leadDetails;
  Widgets w = Widgets();
  Styles s = Styles();

  @override
  void initState() {
    broker = widget.broker;
    colorPrimary = widget.colorPrimary;
    leadDetails = widget.leadDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.generateMaterialColor(colorPrimary),
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
      home: Scaffold(
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
          elevation: 0,
        ),
        body: Container(
          width: MySize.size100(context),
          height: MySize.sizeh100(context),
          color: colorPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    w.getText(leadDetails?.lead?.name??"", s.title(MyColors.white)),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getActionCard("call", leadDetails.lead?.mobile1??"", Icons.call, MyColors.blue300),
                    getActionCard("sms", leadDetails.lead?.mobile1??"", Icons.sms, MyColors.orange),
                    getActionCard("whatsapp", leadDetails.lead?.mobile1??"", Icons.whatsapp, MyColors.green500),
                    getActionCard("email", leadDetails.lead?.email??"", Icons.email_outlined, MyColors.red500)
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: MySize.sizeh100(context),
                  decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        getCards("status.png", MyColors.blue300, "Status", leadDetails.criteria?.status??""),
                        SizedBox(
                          height: 20,
                        ),
                        getCards("followup.png", MyColors.orange, "Follow Up", "Tap to add follow-up/task"),
                        SizedBox(
                          height: 20,
                        ),
                        getCards("deal.png", MyColors.pink600, "Deals", "Tap to add deals")
                      ],
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getCards(String image, Color color, String title, String info) {
    return GestureDetector(
      onTap: () {
        if(title=="Status") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StatusList(colorPrimary: colorPrimary, id: leadDetails.criteria?.id??"")
              )
          ).then((value) {
            if(value!=null) {
              leadDetails.criteria?.sId = value['s_id'];
              leadDetails.criteria?.status = value['status'];
              setState(() {

              });
            }
          });
        }
        else if(title=="Follow Up") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FollowUps(
                  broker: broker,
                  colorPrimary: colorPrimary,
                  id: leadDetails.criteria?.id??"",
                  name: leadDetails.lead?.name??"",
                  followUps: null,
                )
              )
          ).then((value) {
            // if(value!=null) {
            //   leadDetails.criteria?.sId = value['s_id'];
            //   leadDetails.criteria?.status = value['status'];
            //   setState(() {
            //
            //   });
            // }
          });
        }
        else if(title=="Deals") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Deals(broker: broker, colorPrimary: colorPrimary, id: leadDetails.criteria?.id??"", name: leadDetails.lead?.name??"")
              )
          ).then((value) {
            // if(value!=null) {
            //   leadDetails.criteria?.sId = value['s_id'];
            //   leadDetails.criteria?.status = value['status'];
            //   setState(() {
            //
            //   });
            // }
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: MySize.size2(context)),
        decoration: BoxDecoration(
            color: MyColors.white,
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
        child: Row(
          children: [
            getIconCard(image, color),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Column(
                children: [
                  getTitle(title),
                  const SizedBox(
                    height: 5,
                  ),
                  (leadDetails.followUp?.id??"").isNotEmpty && title=="Follow Up" ?
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: MyColors.orange,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          getTimeDifference(leadDetails.followUp?.datetime??""),
                          style: TextStyle(
                              color: MyColors.orange
                          ),
                        )
                      ],
                    ) :
                  getSubTitle(info)
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              // onTap: () {
              //   openOptions(lead);
              // },
              child: const Icon(
                  Icons.arrow_forward_ios
              ),
            )
          ],
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
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  getSubTitle(String subTitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        subTitle,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey
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
          print(contact);
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

  String getTimeDifference(String datetime) {
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
    else if(duration.inDays.abs()==2 && duration.inHours.abs()>12) {
      return "Tomorrow, "+DateFormat("hh:mm a").format(dateTime);
    }
    // else if(duration.inHours.abs()==1|| duration.inHours.abs()<24) {
    else if(duration.inHours.abs()<24) {
      return "${duration.isNegative ? "" : "In "}${duration.inHours.abs()} Hours${duration.isNegative ? " Ago" : ""}";
    }
    else {
      return "${duration.isNegative ? "" : "In "}${duration.inMinutes.abs()} Minutes${duration.isNegative ? " Ago" : ""}";
    }
  }
}
