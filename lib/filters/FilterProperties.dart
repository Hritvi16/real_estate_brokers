import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:real_estate_brokers/PDFDesign.dart';
import 'package:real_estate_brokers/PropertyDetail.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:real_estate_brokers/models/CategoryResponse.dart' as c;
import 'package:cached_network_image/cached_network_image.dart';
import '../size/MySize.dart';

class FilterProperties extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  final String filter;
  final String desc;
  const FilterProperties({Key? key, required this.colorPrimary, required this.broker, required this.filter, required this.desc}) : super(key: key);

  @override
  State<FilterProperties> createState() => _FilterPropertiesState();
}

class _FilterPropertiesState extends State<FilterProperties> {

  late SharedPreferences sharedPreferences;
  Broker broker = Broker();
  List<Property> properties = [];
  List<c.Category> categories = [];

  bool load = false;

  bool loadp = true;

  List<int> selected = [];

  Color colorPrimary = MyColors.grey10;

  pw.Document pdf = pw.Document();

  @override
  void initState() {
    broker = widget.broker;
    colorPrimary = widget.colorPrimary;
    getProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return load ? Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                showFilter(widget.desc);
              },
              child: Icon(
                Icons.description
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: selected.isNotEmpty ? Container(
        height: 45,
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: ElevatedButton(
            onPressed: () {
              pdf = pw.Document();
              loadp = false;
              setState(() {

              });
              sharePDF();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorPrimary)
            ),
            child: loadp ? Text("Share", style: TextStyle(color: MyColors.white),) : Center(child: CircularProgressIndicator(color: MyColors.white,),)
        ),
      )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: properties.isNotEmpty ? ListView.separated(
          itemCount: properties.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext buildContext, int index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext buildContext, int index) {
            return getPropertyCard(properties[index], index);
          },
        )
        : const Center(
          child: Text(
            "No Properties"
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

  Widget getPropertyCard(Property property, int index) {
    return GestureDetector(
      onTap: () {
        if(selected.isEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  PropertyDetail(id: property.details?.id ?? "", colorPrimary: colorPrimary,)
              )
          );
        }
        else {
          if(selected.contains(index)) {
            selected.remove(index);
          }
          else {
            selected.add(index);
          }
          setState(() {

          });
        }
      },
      onLongPress: () async {
        if(selected.contains(index)) {
          selected.remove(index);
        }
        else {
          selected.add(index);
        }
        setState(() {

        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: MySize.size2(context)),
        decoration: BoxDecoration(
            color: selected.contains(index) ? colorPrimary.withOpacity(0.2) : MyColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.grey10),
            boxShadow: !selected.contains(index) ? const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 1.0,
              ),
            ] : null
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (property.images?.length??0) > 0 ? CachedNetworkImage(
              imageUrl: Environment.propertyUrl + (property.images?.first.image??""),
              errorWidget: (context, url, error) {
                return Icon(
                    Icons.apartment
                );
              },
              width: 100,
              height: 80,
            )
                : Container(
              width: 100,
              height: 100,
              child: Icon(
                Icons.apartment,
                size: 70,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                children: [
                  getData("Project", property.details?.projectName??""),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Area", property.details?.areaName??""),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Super Sq.Ft.", property.details?.sqftSuper??"Not Mentioned"),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Carpet Sq.Ft.", property.details?.sqftCarpet??"Not Mentioned"),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Price", Environment.rupee+" "+(property.details?.amount??"")),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if((property.details?.wishlist??"0")=="1") {
                  properties[index].details?.wishlist = "0";
                }
                else {
                  properties[index].details?.wishlist = "1";
                }
                setState(() {

                });
                manageWishlist(properties[index].details?.id??"", properties[index].details?.wishlist??"0");

              },
              child: Icon(
                (property.details?.wishlist??"0")=="1" ? Icons.favorite : Icons.favorite_border,
                color: colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }


  getData(String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MySize.size20(context),
          child: getTitle(title+" : "),
        ),
        Expanded(
          child: getInfo(info),
        )
      ],
    );
  }

  getTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w600
      ),
    );
  }

  getInfo(String info) {
    return Text(info);
  }


  sharePDF() async {
    final netImage = await networkImage(Environment.companyUrl + (broker.logo??""));
    pdf.addPage(
        PDFDesign.getFirstPage(netImage, broker)
    );


    for (var element in selected) {
      await createPDF(properties[element]);
    }

    final imageByteData = await rootBundle.load('assets/thankyou.jpg');
    // Convert ByteData to Uint8List
    final imageUint8List = imageByteData.buffer
        .asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    final image = pw.MemoryImage(imageUint8List);
    pdf.addPage(
        PDFDesign.getLastPage(broker, image, netImage)
    );

    String name = DateTime.now().millisecondsSinceEpoch.toString();

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$name.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareFiles([file.path]);
    loadp = true;
    setState(() {

    });
  }

  createPDF(Property property) async {
    pdf.addPage(
        PDFDesign.getPropertyPage(property, getCategory(property.details?.id??""), broker)
    ); //

    for (int i=0; i<(property.images ?? []).length; i+=2)  {
      var element1 = property.images![i];
      final netImage1 = await networkImage(Environment.propertyUrl + (element1.image??""));
      var element2;
      var netImage2;
      if((i+1)<(property.images?.length??0)) {
        element2 = property.images![i + 1];
        netImage2 = await networkImage(Environment.propertyUrl + (element2.image ?? ""));
      }
      pdf.addPage(
          PDFDesign.getImages(netImage1, netImage2, broker)
      );


    }
  }

  getProperties() async {
    Map<String, String> data = {
      APIConstant.act : APIConstant.getByFilter,
      "filter" : widget.filter,
      "id" : broker.id??""
    };

    print(data);

    PropertyListResponse propertyListResponse = await APIService().getProperties(data);
    properties = propertyListResponse.property ?? [];
    categories = propertyListResponse.category ?? [];


    load = true;
    setState(() {

    });
  }

  Future<void> manageWishlist(String id, String wishlist) async {
    Map<String, dynamic> data = new Map();
    data['id'] = id;
    data['wishlist'] = wishlist;
    data.addAll({APIConstant.act : APIConstant.updateWishlist});
    Response response = await APIService().updateWishlist(data);
  }

  c.Category getCategory(String id) {
    c.Category category = c.Category();
    categories.forEach((element) {
      if(element.id==id)
        category = element;
    });
    return category;
  }

  void showFilter(String desc) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: MyColors.white,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(desc),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text('CLOSE'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }

}
