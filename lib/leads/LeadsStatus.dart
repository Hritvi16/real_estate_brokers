import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/leads/Leads.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/models/StatusResponse.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../size/MySize.dart';
import '../models/LoginResponse.dart';

class LeadsStatus extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  const LeadsStatus({Key? key, required this.colorPrimary, required this.broker,}) : super(key: key);

  @override
  State<LeadsStatus> createState() => _LeadsStatusState();
}

class _LeadsStatusState extends State<LeadsStatus> {

  late SharedPreferences sharedPreferences;
  List<Status> status = [];


  Color colorPrimary = MyColors.colorPrimary;
  bool load = false;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  Color color = MyColors.colorPrimary;

  late Color dialogPickerColor;

  @override
  void initState() {
    colorPrimary = widget.colorPrimary;
    dialogPickerColor = Colors.red;
    start();
    super.initState();
  }

  start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getLeadsStatus();
  }
  @override
  Widget build(BuildContext context) {
    return load ? Scaffold(
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
          "Leads Status",
          style: TextStyle(
            color: MyColors.white
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: status.isNotEmpty ? ListView.separated(
          itemCount: status.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext buildContext, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext buildContext, int index) {
            return getStatusCard(status[index]);
          },
        )
        : const Center(
          child: Text(
            "No leads"
          ),
        ),
      ),
    )
    : Container(
      color: MyColors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorPrimary,
      ),
    );
  }

  Widget getStatusCard(Status status) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Leads(
              colorPrimary: colorPrimary,
              broker: widget.broker,
              leads: null,
              status: status.status??"",
              act: APIConstant.getByStatus,
              id: status.id??""
            )
            )
        );
      },
      onLongPress: () {
        if((status.lmId??"").isNotEmpty) {
          controller.text = status.status ?? "";
          dialogPickerColor = Color(int.parse("0xff" + (status.color ?? "")));
          setState(() {

          });
          addStatusSheet(APIConstant.update, status.id ?? "");
        }
        else {
          Toast.sendToast(context, "You cannot edit predefined status");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.grey10)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: MySize.size5(context)),
          margin: EdgeInsets.only(left: 1, right: 1, top: 1),
          decoration: BoxDecoration(
            color: MyColors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(int.parse("0xff"+(status.color??"e6e6e6"))),
                width: 2
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTitle(status.status??""),
              getCountCard(status.count??"", Color(int.parse("0xff"+(status.color??"e6e6e6"))))
            ],
          ),
        ),
      ),
    );
  }


  getTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: MyColors.black
      ),
    );
  }
  
  getCountCard(String count, Color color) {
    return Container(
      height: 35,
      width: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3)
      ),
      child: Text(
        count,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color
        ),
      ),
    );
  }

  getInfo(String desc) {
    return Text(
      desc,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  getLeadsStatus() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data['id'] = sharedPreferences.getString("id") ?? "";

    StatusResponse statusResponse = await APIService().getStatus(data);
    status = statusResponse.status ?? [];

    load = true;
    setState(() {

    });

  }

  addStatusSheet(String act, String id) {
    showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        Color color = dialogPickerColor;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: MyColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: "Enter Status",
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
                      height: 30,
                    ),
                    Text("Select Color"),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          colorPickerDialog().then((value) {
                            if (value == true) {
                              dialogPickerColor = dialogPickerColor;
                            }
                            else {
                              dialogPickerColor = color;
                            }
                            setState(() {

                            });
                          });
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          width: MySize.size100(context),
                          decoration: BoxDecoration(
                              color: dialogPickerColor
                          ),
                        )
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
                                    addStatus(act, id);
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
        getLeadsStatus();
      }
    });
  }

  Future<bool> colorPickerDialog() async {
      return ColorPicker(
        color: dialogPickerColor,
        onColorChanged: (Color color) =>
            setState(() => dialogPickerColor = color),
        width: 40,
        height: 40,
        borderRadius: 4,
        spacing: 5,
        runSpacing: 5,
        wheelDiameter: 155,
        heading: Text(
          'Select color',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subheading: Text(
          'Select color shade',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        wheelSubheading: Text(
          'Selected color and its shades',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        showMaterialName: true,
        showColorName: true,
        showColorCode: true,
        copyPasteBehavior: const ColorPickerCopyPasteBehavior(
          longPressMenu: true,
        ),
        materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
        colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
        colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
        colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
        selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
        pickersEnabled: const <ColorPickerType, bool>{
          ColorPickerType.both: false,
          ColorPickerType.primary: true,
          ColorPickerType.accent: true,
          ColorPickerType.bw: false,
          ColorPickerType.custom: true,
          ColorPickerType.wheel: true,
        },
      ).showPickerDialog(
        context,
        actionsPadding: const EdgeInsets.all(16),
        constraints:
        const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
      );
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
        deleteStatus(id);
    });
  }

  Future<void> addStatus(String act, String id) async {
    print(dialogPickerColor.hex);
    Map<String, String> data = {
      APIConstant.act : act,
      "id" : id,
      "status" : controller.text,
      "color" : dialogPickerColor.hex
    };

    print(data);

    Response response = await APIService().addStatus(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      Navigator.pop(context, "reload");
    }
  }

  Future<void> deleteStatus(String id) async {
    print(dialogPickerColor.hex);
    Map<String, String> data = {
      APIConstant.act : APIConstant.delete,
      "id" : id,
    };

    print(data);

    Response response = await APIService().deleteStatus(data);

    if(response.status=="Success") {
      Navigator.pop(context, "reload");
    }
    else {
      Navigator.pop(context);
    }
    Toast.sendToast(context, response.message??"");
  }
}
