
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/filters/FilterProperties.dart';
import 'package:real_estate_brokers/leads/AddLead.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/leads/LeadDetail.dart';
import 'package:real_estate_brokers/models/BrokerResponse.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LeadSourceResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/models/StatusResponse.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../size/MySize.dart';

class Leads extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  final List<LeadDetails>? leads;
  final String status;
  final String act;
  final String id;
  const Leads({Key? key, required this.colorPrimary, required this.broker, this.leads, required this.status, required this.act, required this.id}) : super(key: key);

  @override
  State<Leads> createState() => _LeadsState();
}

enum WISE {ASC, DESC}
class _LeadsState extends State<Leads> {

  late SharedPreferences sharedPreferences;
  Broker broker = Broker();
  List<LeadDetails> all = [];
  List<LeadDetails> leads = [];
  List<LeadDetails> filterLeads = [];

  List<Broker> brokers = [];
  List<Broker> createdBy = [];
  Broker? selectedcb;
  Broker? selecteda;
  List<Status> status = [];
  Status? selecteds;
  List<LeadSources> leadSources = [];
  LeadSources? selectedls;

  WISE wise = WISE.ASC;

  bool load = false;

  Color colorPrimary = MyColors.grey10;
  Broker? selectedb;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    broker = widget.broker;
    colorPrimary = widget.colorPrimary;
    start();
    super.initState();
  }

  start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(widget.leads!=null) {
      leads = widget.leads??[];
      filterLeads.addAll(widget.leads??[]);
      all.addAll(widget.leads??[]);

      load = true;
      setState(() {

      });
      getBrokers();
    }
    else {
      getLeads();
    }
  }

  @override
  Widget build(BuildContext context) {
    return load ? Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddLead(colorPrimary: colorPrimary, lead: null, criteria: null, status: widget.status,)
              )
          ).then((value) {
            if(value=="reload") {
              load = false;
              setState(() {

              });
              getLeads();
            }
          });
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
          children: [
            Container(
              height: 200,
              child: Row(
                children: [
                  Container(
                    width: MySize.size75(context),
                    margin: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      onChanged: (value) {
                        if(value.isNotEmpty) {
                          searchLeads(value);
                        }
                        else {
                          filterLeads = leads;
                          setState(() {

                          });
                        }
                      },
                      cursorColor: Colors.black,
                      decoration:  const InputDecoration(
                        hintText: "Search Leads",
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
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      alignment: Alignment.center,
                        height: 40,
                        decoration: const BoxDecoration(
                        ),
                        child: GestureDetector(
                          onTap: () {
                            openFilter();
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.white.withOpacity(0.5)
                            ),
                            child: const Icon(
                              Icons.filter_alt_outlined
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
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
                child: filterLeads.isNotEmpty ? ListView.separated(
                  itemCount: filterLeads.length,
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext buildContext, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext buildContext, int index) {
                    return getLeadCard(filterLeads[index], index);
                  },
                )
                : const Center(
                  child: Text(
                    "No Leads"
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : Container(
      height: MySize.sizeh100(context),
      color: MyColors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator(color:  colorPrimary,),
    );
  }

  Widget getLeadCard(LeadDetails lead, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                LeadDetail(broker: broker, colorPrimary: colorPrimary, leadDetails: lead)
            )
        ).then((value) {
          if(value!=null)
          {
            lead.criteria?.sId = sharedPreferences.getString("s_id");
            lead.criteria?.status = sharedPreferences.getString("leadstatus");
            setState(() {

            });
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: MySize.size2(context)),
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
          children: [
            getSubTitle(DateFormat("MMM dd yyyy, hh:mm a").format(DateTime.parse(lead.lead?.createdAt??"")), Alignment.centerRight),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                getInitialCard(getInitials(lead.lead?.name??"")),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    children: [
                      getTitle(lead.lead?.name??""),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      getSubTitle(lead.criteria?.status??"", Alignment.centerLeft)
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    openOptions(lead);
                  },
                  child: const Icon(
                    Icons.more_vert
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lead.lead?.mobile1??""
                ),
                GestureDetector(
                  onTap: () {
                    Essential().call(lead.lead?.mobile1??"");
                  },
                  child: Icon(
                      Icons.call,
                    color: MyColors.green500,
                  ),
                ),
              ],
            ),
            if((lead.followUp?.id??"").isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            if((lead.followUp?.id??"").isNotEmpty)
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
                    "Next Follow Up: ${getTimeDifference(lead.followUp?.datetime??"")}",
                    style: TextStyle(
                      color: MyColors.orange
                    ),
                  )
                ],
              ),
            const SizedBox(
              height: 10,
            ),
            getBody("Assigned to "+(lead.criteria?.assignedName??"")),
            const SizedBox(
              height: 10,
            ),
            getBody("Source :   "+(lead.criteria?.source??""))
          ],
        ),
      ),
    );
  }

  openOptions(LeadDetails lead) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: MyColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getOptionText("EDIT", lead),
              const SizedBox(
                height: 30,
              ),
              getOptionText("DELETE", lead),
              const SizedBox(
                height: 30,
              ),
              getOptionText("ASSIGN LEAD", lead),
              const SizedBox(
                height: 30,
              ),
              getOptionText("MATCHING PROPERTIES", lead),
            ],
          ),
        );
      },
    );
  }

  assignOptions(Lead lead, Criteria criteria) {
    showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: MyColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getTitle(lead.name??""),
                const SizedBox(
                  height: 15,
                ),
                getSubTitle("Assign Lead", Alignment.centerLeft),
                const SizedBox(
                  height: 10,
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
                    labelText: "Select User",
                  ),
                  validator: (value) {
                    if (value==null) {
                      return "* Required";
                    }  else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      height: 45,
                      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(colorPrimary)
                          ),
                          child: Text("CANCEL", style: TextStyle(color: MyColors.white),)
                      ),
                    ),
                    Container(
                      height: 45,
                      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            if(formkey.currentState!.validate()) {
                              assignLead(criteria.id??"");
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(colorPrimary)
                          ),
                          child: Text("ASSIGN", style: TextStyle(color: MyColors.white),)
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if(value=="reload") {
        load = false;
        setState(() {

        });
        getLeads();
      }
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
        style: const TextStyle(
          fontSize: 13,
            fontWeight: FontWeight.w400,
          color: Colors.grey
        ),
      ),
    );
  }


  getBody(String subTitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        subTitle,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 12,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  getOptionText(String title, LeadDetails lead) {
    return GestureDetector(
      onTap: () {
        if(title=="EDIT") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddLead(colorPrimary: colorPrimary, lead: lead.lead, criteria: lead.criteria, status: widget.status)
            )
          ).then((value) {
            Navigator.pop(context);
            if(value=="reload") {
              load = false;
              setState(() {

              });
              getLeads();
            }
          });
        }
        else if(title=="DELETE") {
          deleteDialog(lead.lead!);
        }
        else if(title=="ASSIGN LEAD"){
          Navigator.pop(context);
          assignOptions(lead.lead!, lead.criteria!);
        }
        else {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  FilterProperties(broker: broker, colorPrimary: colorPrimary, filter: lead.criteria?.filter??"", desc: lead.criteria?.description??"")
              )
          );
        }
      },
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  deleteDialog(Lead lead) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return LoginPopUp(
          text: "Are you sure you want to delete this deal?",
          btn1 : "NO",
          btn2: "YES", colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if(value=="YES") {
        deleteLead(lead);
        Navigator.pop(context);
      }
    });
  }

  getInfo(String desc) {
    return Text(
      desc,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  getInitials(String name) {
    if(name.contains(" ")) {
      int index = name.indexOf(" ");
      return name.substring(0, 1)+name.substring(index+1, index+2);
    }
    else if(name.length>1) {
      return name.substring(0, 2);
    }
    else {
      return name;
    }
  }

  getInitialCard(String name) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(7)
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorPrimary
        ),
      ),
    );
  }


  openFilter() {
    WISE w = wise;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: MyColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField(
                    value: selectedcb,
                    items: createdBy.map((Broker items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.email ?? "",
                          style: TextStyle(
                              fontSize: 15
                          ),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedcb = value as Broker;
                      setState(() {

                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Created By",
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "* Required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  DropdownButtonFormField(
                    value: selecteda,
                    items: brokers.map((Broker items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.name ?? "",
                          style: TextStyle(
                              fontSize: 15
                          ),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selecteda = value as Broker;
                      setState(() {

                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Assign Lead",
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "* Required";
                      } else {
                        return null;
                      }
                    },
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
                                child: Text(items.status ?? "",
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
                            labelText: "Status",
                          ),
                          validator: (value) {
                            if (value == null) {
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
                        flex: 1,
                        child: DropdownButtonFormField(
                          value: selectedls,
                          items: leadSources.map((LeadSources items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Container(
                                  width: MySize.size35(context),
                                  child: Text(items.source ?? "",
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
                            if (value == null) {
                              return "* Required";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  RadioListTile(
                    title: const Text("Ascending"),
                    value: WISE.ASC,
                    groupValue: w,
                    // selected: w==WISE.ASC,
                    onChanged: (WISE? value) {
                      print(value);
                      w = WISE.ASC;
                      setState(() {
                        wise = WISE.ASC;
                      });
                      this.setState(() {

                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    title: const Text("Descending"),
                    value: WISE.DESC,
                    groupValue: w,
                    // selected: w==WISE.DESC,
                    onChanged: (WISE? value) {
                      print(value);
                      w = WISE.DESC;
                      setState(() {
                        wise = WISE.DESC;
                      });
                      this.setState(() {

                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 45,
                        width: MySize.size45(context),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    colorPrimary)
                            ),
                            child: Text("CANCEL",
                              style: TextStyle(color: MyColors.white),)
                        ),
                      ),
                      Container(
                        height: 45,
                        width: MySize.size45(context),
                        child: ElevatedButton(
                            onPressed: () {
                              applyFilter();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    colorPrimary)
                            ),
                            child: Text("APPLY FILTER",
                              style: TextStyle(color: MyColors.white),)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  getLeads() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = widget.act;
    data['id'] = widget.id;
    data['b_id'] = broker.id??"";

    LeadDetailResponse leadDetailResponse = await APIService().getLeadsDetails(data);
    leads = leadDetailResponse.leadDetails ?? [];
    filterLeads = [];

    filterLeads.addAll(leads);
    all.addAll(leads);

    load = true;
    setState(() {

    });
    getBrokers();
  }

  getBrokers() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data["id"] = broker.id??'';

    BrokerResponse brokerResponse = await APIService().getBrokers(data);
    brokers = brokerResponse.broker ?? [];
    createdBy.addAll(brokers);

    createdBy.insert(0, Broker(id: "-1", name: "All", email: "All"));
    createdBy.first.email = "All";
    createdBy.first.name = "All";

    selectedcb = createdBy.first;

    getStatus();
  }

  getStatus() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data['id'] = sharedPreferences.getString("id") ?? "";

    StatusResponse statusResponse = await APIService().getStatus(data);
    status = statusResponse.status ?? [];

    getLeadSources();

  }

  getLeadSources() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;

    LeadSourceResponse leadSourceResponse = await APIService().getLeadSources(data);
    leadSources = leadSourceResponse.leadSources ?? [];

    setState(() {

    });
  }

  Future<void> deleteLead(Lead lead) async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.delete;
    data['id'] = lead.id??"";


    Response response = await APIService().deleteLead(data);

    if(response.status=="Success") {
      Toast.sendToast(context, "Deleted: "+(lead.name??""));

      leads.remove(lead);
      all.remove(lead);
      filterLeads.remove(lead);

      setState(() {

      });
    }
    else {
      Toast.sendToast(context, response.message??"");
    }

  }

  Future<void> assignLead(String id) async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.assign;
    data['id'] = id;
    data['lm_id'] = selectedb?.id??"";


    Response response = await APIService().assignLead(data);

    if(response.status=="Success") {
      Toast.sendToast(context, "Assigned to: "+(selectedb?.name??""));
      Navigator.pop(context, "reload");
    }
    else {
      Toast.sendToast(context, response.message??"");
    }
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
    else if(duration.inDays.abs()==2 || duration.inHours.abs()>12) {
      return "Tomorrow, "+DateFormat("hh:mm a").format(dateTime);
    }
    else if(duration.inDays.abs()==1 || duration.inHours.abs()<24) {
      return "Today, "+DateFormat("hh:mm a").format(dateTime);
    }
    return "--";
  }

  void applyFilter() {
    List<LeadDetails> fil = [];
    if(selectedcb?.email=="All") {
      fil = all;
    }
    else {
      for (var element in all) {
        if(element.lead!.createdBy==selectedcb!.id) {
          fil.add(element);
        }
      }
    }

    if(selecteda!=null) {
      List<LeadDetails> all = [];
      all.addAll(fil);
      fil = [];

      for (var element in all) {
        if(element.criteria!.lmId==selecteda!.id) {
          fil.add(element);
        }
      }
    }

    if(selecteds!=null) {
      List<LeadDetails> all = [];
      all.addAll(fil);
      fil = [];

      for (var element in all) {
        if(element.criteria!.sId==selecteds!.id) {
          fil.add(element);
        }
      }
    }

    if(selectedls!=null) {
      List<LeadDetails> all = [];
      all.addAll(fil);
      fil = [];

      for (var element in all) {
        if(element.criteria!.lsId==selectedls!.id) {
          fil.add(element);
        }
      }
    }

    if(wise==WISE.ASC) {
      fil.sort((a, b) => DateTime.parse(a.criteria!.createdAt??"").compareTo(DateTime.parse(b.criteria!.createdAt??"")));
    }
    else {
      fil.sort((a, b) => DateTime.parse(b.criteria!.createdAt??"").compareTo(DateTime.parse(a.criteria!.createdAt??"")));
    }

    filterLeads = fil;
    leads = [];
    leads.addAll(fil);

    setState(() {

    });

    Navigator.pop(context);
  }

  void searchLeads(String value) {
    filterLeads = [];
    for (var element in leads) {
      if(element.lead!.name!.toLowerCase().contains(value.toLowerCase()) || element.lead!.mobile1!.toLowerCase().contains(value.toLowerCase())) {
        filterLeads.add(element);
      }
    }

    setState(() {

    });
  }
}
