import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_estate_brokers/PDFViewer.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/photoView/PhotoView.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class PropertyDetail extends StatefulWidget {
  final String id;
  const PropertyDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {

  List<Widget> slideShow = [];

  String id = "";
  bool load = false;

  Property property = Property();

  @override
  void initState() {
    id = widget.id;
    getPropertyDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: load ? SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getImageView(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getHeadTitle(property.details?.projectName??""),
                      SizedBox(
                        height: 10,
                      ),
                      getSubTitle(Environment.rupee+(property.details?.rate??"")),
                      SizedBox(
                        height: 20,
                      ),
                      getData("Property On", property.details?.purpose??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Category", property.details?.categoryName??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Area", property.details?.areaName??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Super SqFt", property.details?.sqftSuper??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Carpet SqFt", property.details?.sqftCarpet??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("BHK", property.details?.bhk??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Var", property.details?.varr??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Vigha", property.details?.vigha??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Number", property.details?.number??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Block Number", property.details?.blockNumber??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("TP Survey No", property.details?.tPSurveyNo??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Furnishing Status", property.details?.furnishedOrNot??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Floor", property.details?.floor??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Condition", property.details?.condition??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Remarks", property.details?.remarks??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Construction", property.details?.construction??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Property Type", property.details?.saleType??""),
                      SizedBox(
                        height: 10,
                      ),
                      getData("Rera", property.details?.rera??""),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PDFViewer(
                                        url: Environment.brochureUrl + (property.details?.brochure??"")
                                      )
                                    )
                                  );
                                },
                                child: Text("View Brochure")
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  String info = property.details?.brochure??"";
                                  final docurl = Environment.brochureUrl + info;
                                  final uri = Uri.parse(docurl);
                                  final response = await http.get(uri);
                                  final bytes = response.bodyBytes;
                                  final temp = await getTemporaryDirectory();
                                  final path = '${temp.path}/'+(property.details?.projectName??"Project")+"_Brochure"+(info.substring(info.lastIndexOf("."), info.length));
                                  File(path).writeAsBytesSync(bytes);
                                  await Share.shareFiles([path]);
                                },
                                child: Text("Share Brochure")
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
      : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getHeadTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600
      ),
    );
  }

  getSubTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
    );
  }
  getData(String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: getTitle(title+" : "),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 2,
          child: getInfo(info.isNotEmpty ? info : "Not Mentioned"),
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
    return Text(
      info,
      style: TextStyle(
        fontSize: 16
      ),
    );
  }

  Future<void> getPropertyDetails() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByID;
    data['id'] = id;

    PropertyResponse propertyResponse = await APIService().getPropertyDetails(data);
    property = propertyResponse.property ?? Property();

    setState(() {

    });
    setImage();
  }

  setImage() {
    int len = property.images?.length??0;
    for (int i = 0; i < len; i++) {
      slideShow.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PhotoView(images: property.images ?? [],)
                )
            );
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      ),
                    ]),
                child: Image.network(
                    Environment.propertyUrl + (property.images?[i].image ?? ""),
                    fit: BoxFit.fill,
                    width: 1000),
                // child: Image.asset(
                //   banners[i].banImage,
                //   fit: BoxFit.fill,
                // ),
              )
          ),
        ),
      );
    }

    load = true;

    setState(() {

    });
  }

  getImageView() {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: slideShow.isNotEmpty ? CarouselSlider(
          options: CarouselOptions(
              enlargeCenterPage: true,
              height: 200,
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3)
          ),
          items: slideShow)
      : Container(
        width: MySize.size100(context),
        alignment: Alignment.center,
        height: 200,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: MyColors.grey10
            )
          )
        ),
        child: const Icon(
          Icons.apartment,
          size: 100,
        ),
      ),
    );
  }


}
