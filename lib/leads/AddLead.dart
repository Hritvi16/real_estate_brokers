import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_brokers/leads/ContactList.dart';
import 'package:real_estate_brokers/leads/LeadCriteria.dart';
import 'package:real_estate_brokers/leads/LeadList.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/main.dart';
import 'package:real_estate_brokers/models/BrokerResponse.dart';
import 'package:real_estate_brokers/models/LeadSourceResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/models/StatusResponse.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/strings/Strings.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:real_estate_brokers/widgets/Styles.dart';
import 'package:real_estate_brokers/widgets/Widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/LeadResponse.dart';

class AddLead extends StatefulWidget {
  final Color colorPrimary;
  final Lead? lead;
  final Criteria? criteria;
  final String status;
  const AddLead({Key? key, required this.colorPrimary, this.lead, this.criteria,required this.status}) : super(key: key);

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  late Color colorPrimary;
  Widgets w = Widgets();
  Styles s = Styles();
  List<Status> status = [];
  Status? selecteds;
  List<LeadSources> leadSources = [];
  LeadSources? selectedls;
  List<Broker> brokers = [];
  List<Lead> leads = [];
  Broker? selectedb;
  Lead? lead;
  String lead_id = "";

  bool select = false;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile1 = TextEditingController();
  TextEditingController mobile2 = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController remarks = TextEditingController();

  late SharedPreferences sharedPreferences;

  bool load = false;
  Criteria? criteria;


  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    colorPrimary = widget.colorPrimary;
    lead = widget.lead;
    criteria = widget.criteria;
    print("lead.toJson()");
    print(criteria?.toJson());
    start();
    super.initState();
  }

  start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    name.text = lead?.name??"";
    email.text = lead?.email??"";
    mobile1.text = lead?.mobile1??"";
    mobile2.text = lead?.mobile2??"";
    address.text = lead?.address??"";
    remarks.text = criteria?.remarks??"";
    // await fetchContacts();
    getStatus();
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
        bottomNavigationBar: Container(
          height: 45,
          margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
          child: ElevatedButton(
              onPressed: () {
                if(load) {
                  if (formkey.currentState!.validate()) {
                    // if(deal!=null) {
                    //   updateLead();
                    // }
                    // else {
                    Map<String, String> data = getDetails();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            LeadCriteria(colorPrimary: colorPrimary,
                              data: data,
                              criteria: widget.criteria,)
                        )
                    );
                    // }
                  }
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorPrimary)
              ),
              child: load ? Text("NEXT", style: TextStyle(color: MyColors.white),) : CircularProgressIndicator(color: MyColors.white,)
          ),
        ),
        body: Container(
          width: MySize.size100(context),
          height: MySize.sizeh100(context),
          color: colorPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    w.getText("Add Lead", s.title(MyColors.white)),
                    const SizedBox(
                      height: 5,
                    ),
                    w.getText(Strings.lead_desc, s.body(MyColors.white)),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: name,
                            readOnly: select,
                            decoration: InputDecoration(
                              labelText: "Name",
                              prefixIcon: const Icon(
                                Icons.person_outline
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  readContacts();
                                },
                                child: const Icon(
                                  Icons.contact_phone
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              }  else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: email,
                            readOnly: select,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email_outlined
                              ),
                            ),
                            validator: (value) {
                              if(value!.isNotEmpty) {
                                if (!EmailValidator.validate(email.text)) {
                                  return "Enter valid email address";
                                } else {
                                  return null;
                                }
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: mobile1,
                            readOnly: select,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: Icon(
                                Icons.phone_outlined
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  readLeads();
                                },
                                child: const Icon(
                                    Icons.people
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              }
                              else if(value!.length!=10) {
                                return "* Invalid Mobile No.";
                              }
                              else if(value!.startsWith("+91") || value!.startsWith("91")) {
                                return "* Invalid Mobile No.";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: mobile2,
                            readOnly: select,
                              keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Alternate Number",
                              prefixIcon: Icon(
                                Icons.phone_outlined
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }
                              else if(value!.length!=10) {
                                return "* Invalid Mobile No.";
                              }
                              else if(value!.startsWith("+91") || value!.startsWith("91")) {
                                return "* Invalid Mobile No.";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: address,
                            readOnly: select,
                            decoration: const InputDecoration(
                              labelText: "Address",
                              prefixIcon: Icon(
                                Icons.location_on_outlined
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: DropdownButtonFormField(
                                  value: selecteds,
                                  items: status.map((Status items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Container(
                                        width: MySize.size35(context),
                                        child: Text(items.status??"",
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    selecteds = value as Status;
                                    setState(() {

                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Lead",
                                  ),
                                  validator: (value) {
                                    if (value==null) {
                                      return "* Required";
                                    }  else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                flex: 1,
                                child: DropdownButtonFormField(
                                  value: selectedls,
                                  items: leadSources.map((LeadSources items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Container(
                                          width: MySize.size35(context),
                                          child: Text(items.source??"",
                                            style: TextStyle(
                                                fontSize: 15
                                            ),)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    selectedls = value as LeadSources;
                                    setState(() {

                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Lead Sources",
                                  ),
                                  validator: (value) {
                                    if (value==null) {
                                      return "* Required";
                                    }  else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField(
                            value: selectedb,
                            items: brokers.map((Broker items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items.name??""),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedb = value as Broker;
                              setState(() {

                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Assign Lead",
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: remarks,
                              decoration: const InputDecoration(
                                labelText: "Remarks",
                              )
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  readContacts() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
            ContactList(colorPrimary: colorPrimary,)
        )
    ).then((value) {
      if(value!=null) {
        Contact contact = value;
        name.text = contact.displayName;
        email.text = contact.emails.isNotEmpty ? contact.emails.first.address : "";
        mobile1.text = (contact.phones.isNotEmpty ? contact.phones.first.number : "").replaceAll("+91", "").replaceAll("-", "").replaceAll(" ", "");
        if(mobile1.text.startsWith("0")) {
          mobile1.text = mobile1.text.substring(1);
        }
        mobile2.text = contact.phones.length>1 ? contact.phones[1].number : "";
        address.text = contact.addresses.isNotEmpty ? contact.addresses.first.address : "";

        select = false;

        setState(() {

        });
      }
    });
  }

  readLeads() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
            LeadList(colorPrimary: colorPrimary, leads: leads,)
        )
    ).then((value) {
      if(value!=null) {
        Lead lead = value;
        name.text = lead.name??"";
        email.text = lead.email??"";
        mobile1.text = (lead.mobile1??"").replaceAll("+91", "");
        mobile2.text = lead.mobile2??"";
        address.text = lead.address??"";
        lead_id = lead.id??"";
        select = true;
        setState(() {

        });
      }
    });
  }


  getStatus() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data['id'] = sharedPreferences.getString("id") ?? "";

    StatusResponse statusResponse = await APIService().getStatus(data);
    status = statusResponse.status ?? [];
    for (var element in status) {
      if("New Lead"==element.status) {
        selecteds = element;
      }
    }
    if(lead!=null) {
      for (var element in status) {
        if(criteria?.status==element.status) {
          selecteds = element;
        }
      }
    }
    else {
      for (var element in status) {
        if(widget.status==element.status) {
          selecteds = element;
        }
      }
    }

    getLeadSources();

  }

  getLeadSources() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;

    LeadSourceResponse leadSourceResponse = await APIService().getLeadSources(data);
    leadSources = leadSourceResponse.leadSources ?? [];

    if(lead!=null) {
      for (var element in leadSources) {
        if(criteria?.source==element.source) {
          selectedls = element;
        }
      }
    }

    getBrokers();
  }

  getBrokers() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data["id"] = sharedPreferences.getString("id");

    BrokerResponse brokerResponse = await APIService().getBrokers(data);
    brokers = brokerResponse.broker ?? [];

    if(lead!=null) {
      for (var element in brokers) {
        print(criteria?.assignedName);
        if(criteria?.assignedName==element.name) {
          selectedb = element;
        }
      }
    }
    else {
      for (var element in brokers) {
        print(criteria?.assignedName);
        if("Self"==element.name) {
          selectedb = element;
        }
      }
    }

    getLeads();
  }

  getLeads() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data["id"] = sharedPreferences.getString("id");

    LeadResponse leadResponse = await APIService().getLeads(data);
    leads = leadResponse.lead ?? [];
    print("Leadsssssss");
    print(data);
    print(leadResponse.lead?.length);
    print(leadResponse.toJson());

    load = true;
    setState(() {

    });
  }

  Map<String, String> getDetails() {
    Map<String, String> data = {
      "name" : name.text,
      "email" : email.text,
      "mobile1" : mobile1.text.replaceAll("+91", ""),
      "mobile2" : mobile2.text.replaceAll("+91", ""),
      "address" : address.text,
      "s_id" : selecteds?.id??"",
      "ls_id" : selectedls?.id??"",
      "lm_id" : selectedb?.id??"",
      "remarks" : remarks.text,
      "info" : select ? "old" : "new",
      "l_id" : lead_id,
      if(lead!=null)
        "id" : lead?.id??""
    };
    print(data);
    return data;
  }

  Future<void> updateLead() async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.update,
      "id" : lead?.id??""
    };
    data.addAll(getDetails());

    print(data);

    Response response = await APIService().addLead(data);
    Toast.sendToast(context, response.message??"");

    if(response.status=="Success") {
      Navigator.pop(context, "reload");
    }
  }
}
