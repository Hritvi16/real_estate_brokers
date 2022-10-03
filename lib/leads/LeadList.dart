import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LeadResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../size/MySize.dart';

class LeadList extends StatefulWidget {
  final Color colorPrimary;
  final List<Lead> leads;
  const LeadList({Key? key, required this.colorPrimary, required this.leads}) : super(key: key);

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {

  late SharedPreferences sharedPreferences;
  List<Lead> all = [];
  List<Lead> leads = [];


  Color colorPrimary = MyColors.grey10;


  @override
  void initState() {
    all = widget.leads;
    leads = widget.leads;
    colorPrimary = widget.colorPrimary;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: MyColors.white,
        elevation: 0,
        iconTheme: IconThemeData(
            color: colorPrimary
        ),
        title: TextFormField(
          onChanged: (value) {
            if(value.isNotEmpty) {
              searchLeads(value);
            }
            else {
              leads = all;
              setState(() {

              });
            }
          },
          decoration:  InputDecoration(
            labelText: "Search Lead",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: leads.isNotEmpty ? ListView.separated(
          itemCount: leads.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext buildContext, int index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext buildContext, int index) {
            return getLeadCard(leads[index], index);
          },
        )
        : const Center(
          child: Text(
            "No leads"
          ),
        ),
      ),
    );
  }

  Widget getLeadCard(Lead lead, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, lead);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: MySize.size5(context)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(lead.name??""),
            SizedBox(
              height: 10,
            ),
            getInfo(lead.mobile1??""),
          ],
        ),
      ),
    );
  }


  getTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
          fontWeight: FontWeight.w600
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

  void searchLeads(String value) {
    leads = [];
    for (var element in all) {
      if(element.name!.toLowerCase().contains(value.toLowerCase()) || element.mobile1!.toLowerCase().contains(value.toLowerCase())) {
        leads.add(element);
      }
    }

    setState(() {

    });
  }
}
