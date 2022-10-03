import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/filters/FilterProperties.dart';
import 'package:real_estate_brokers/PropertyDetail.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/FilterResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:cached_network_image/cached_network_image.dart';
import '../size/MySize.dart';

class Filters extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  const Filters({Key? key, required this.colorPrimary, required this.broker}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {

  late SharedPreferences sharedPreferences;
  Broker broker = Broker();
  List<Filter> filters = [];

  bool load = false;

  Color colorPrimary = MyColors.colorPrimary;


  @override
  void initState() {
    broker = widget.broker;
    colorPrimary = widget.colorPrimary;
    getFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load ? Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.white,
        elevation: 0,
        title: Text(
            "Saved Filters",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorPrimary
            )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: filters.isNotEmpty ? ListView.separated(
          itemCount: filters.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext buildContext, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext buildContext, int index) {
            return getFilterCard(filters[index], index);
          },
        )
        : const Center(
          child: Text(
            "No Saved Filters"
          ),
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

  Widget getFilterCard(Filter filter, int index) {
    return SwipeActionCell(
      key: ValueKey(filter),
      trailingActions: <SwipeAction>[
        SwipeAction(
            onTap: (CompletionHandler handler) async {
              // await handler(true);
              handler(false);
              deleteFilterDialog(filter);
            },
            icon: Icon(
              Icons.delete,
              color: MyColors.white,
            ),
            color: Colors.red
        ),  
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  FilterProperties(broker: broker, colorPrimary: colorPrimary, filter: filter.filter??"", desc: filter.description??"",)
              )
          );
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
              getSubTitle(DateFormat("MMM dd yyyy, hh:mm a").format(DateTime.parse(filter?.createdAt??"")), Alignment.centerRight),
              getTitle(filter.name??""),
              SizedBox(
                height: 10,
              ),
              getInfo(filter.description??""),
            ],
          ),
        ),
      ),
    );
  }
  
  deleteFilterDialog(Filter filter) {
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
    ).then((value) async {
      if(value=="Yes") {
        deleteFilter(filter.id??"");
        filters.remove(filter);
        setState(() {

        });
      }
    });
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

  getInfo(String desc) {
    return Text(
      desc,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  getFilters() async {
    Map<String, dynamic> data = {};
    data[APIConstant.act] = APIConstant.getAll;
    data['id'] = broker.id??"";

    FilterResponse filterResponse = await APIService().getFilters(data);
    filters = filterResponse.filter ?? [];

    load = true;
    setState(() {

    });
  }
  
  Future<void> deleteFilter(String id) async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.delete,
      "id" : id,
    };


    Response response = await APIService().deleteFilter(data);
    Toast.sendToast(context, response.message??"");

  }

}
