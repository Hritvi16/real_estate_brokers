import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/leads/status/StatusList.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/DealResponse.dart';
import 'package:real_estate_brokers/models/FollowUpResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:real_estate_brokers/widgets/Styles.dart';
import 'package:real_estate_brokers/widgets/Widgets.dart';

class Deals extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  final String id;
  final String name;
  const Deals({Key? key, required this.broker, required this.colorPrimary, required this.id, required this.name}) : super(key: key);

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  late Color colorPrimary;
  Widgets w = Widgets();
  Styles s = Styles();

  List<Deal> deals = [];

  bool load = false;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController amount = TextEditingController(text: "0");
  TextEditingController comm = TextEditingController(text: "0");
  bool type = false;


  @override
  void initState() {
    colorPrimary = widget.colorPrimary;
    getDeals();
    super.initState();
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
            "Deal",
            style: TextStyle(
              color: MyColors.white
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            name.text = "";
            details.text = "";
            amount.text = "0";
            comm.text = "0";

            addDealForm(APIConstant.add, widget.id);
          },
          backgroundColor: colorPrimary,
          child: Icon(
            Icons.add,
            color: MyColors.white,
          ),
        ),
        body: Container(
          width: MySize.size100(context),
          height: MySize.sizeh100(context),
          color: colorPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      child: deals.isNotEmpty ? ListView.separated(
                        itemCount: deals.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext buildContext, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext buildContext, int index) {
                          return getDealCard(deals[index]);
                        },
                      )
                          : const Center(
                        child: Text(
                            "No leads"
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

  Widget getDealCard(Deal deal) {
    return GestureDetector(
      onTap: () {
        addDealForm(APIConstant.update, deal.id??"");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MySize.size5(context)),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getSubTitle(DateFormat("MMM dd yyyy, hh:mm a").format(DateTime.parse(deal?.createdAt??"")), Alignment.centerRight),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 5, bottom: 10),
              child: getTitle("Proposal: "+(deal?.name??"")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.file_copy_outlined,
                  color: MyColors.green500,
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          getSubTitle(widget.name, Alignment.centerLeft),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.circle,
                              size: 5,
                              color: Colors.grey,
                            ),
                          ),
                          getSubTitle(getCommissionAmount(deal.commission??"0", deal.amount??"0", (deal.type??"0")=="0" ? true : false), Alignment.centerLeft)
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      getSubTitle(Environment.rupee+(deal.amount??""), Alignment.centerLeft),
                      const SizedBox(
                        height: 5,
                      ),
                      getColorText("Created by ${widget.broker.id==deal.createdBy ? "You" : deal.createdName??""}", MyColors.green500, 12),
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

  addDealForm(String act, String id) {
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
                              labelText: "Deal Name",
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
                          TextFormField(
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            controller: amount,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Deal Amount",
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
                                  onChanged: (value) {
                                    setState(() {

                                    });
                                  },
                                  controller: comm,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Commission",
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
                                child: FlutterSwitch(
                                  activeText: Environment.rupee,
                                  inactiveText: "%",
                                  value: type,
                                  activeTextFontWeight: FontWeight.w400,
                                  inactiveTextFontWeight: FontWeight.w400,
                                  activeColor: colorPrimary.withOpacity(0.6),
                                  inactiveColor: colorPrimary.withOpacity(0.6),
                                  width: 80,
                                  borderRadius: 30.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      type = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            getCommissionAmount(comm.text.isEmpty ? "0" : comm.text, amount.text.isEmpty ? "0" : amount.text, type)
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
                                          addDeal(act, id);
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
      print(value);
      if(value=="reload") {
        load = false;
        setState(() {

        });
        getDeals();
      }
    });
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
        deleteDeal(id);
    });
  }

  getDeals() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getByBID;
    data['id'] = widget.broker.id??"";
    data['lp_id'] = widget.id;

    DealResponse dealResponse = await APIService().getDeals(data);
    deals = dealResponse.deal ?? [];

    load = true;
    setState(() {

    });
  }

  Future<void> addDeal(String act, String id) async {
    print(type);
    Map<String, String> data = {
      APIConstant.act : act,
      "id" : id,
      "name" : name.text,
      "details" : details.text,
      "amount" : amount.text,
      "commission" : comm.text,
      "type" : type ? "0" : "1",
      "created_by" : widget.broker.id??"",
    };

    print(data);

    Response response = await APIService().addDeal(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      Navigator.pop(context, "reload");
    }
  }

  Future<void> deleteDeal(String id) async {
    print(type);
    Map<String, String> data = {
      APIConstant.act : APIConstant.delete,
      "id" : id,
    };

    print(data);

    Response response = await APIService().deleteDeal(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      Navigator.pop(context, "reload");
    }
  }

  String getCommissionAmount(String comm, String amount, bool type) {
    if(type) {
      return Environment.rupee + (comm);
    }
    else {
      return Environment.rupee + (double.parse(amount) * (double.parse(comm)/100)).toString();
    }
  }
}
