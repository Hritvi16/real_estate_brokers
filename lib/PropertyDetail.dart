import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/PDFViewer.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/AmenityResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart' as c;
import 'package:real_estate_brokers/photoView/PhotoView.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_brokers/strings/Strings.dart';
import 'package:share_plus/share_plus.dart';

class PropertyDetail extends StatefulWidget {
  final String id;
  final Color colorPrimary;
  const PropertyDetail({Key? key, required this.id, required this.colorPrimary}) : super(key: key);

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {

  List<Widget> slideShow = [];

  String id = "";
  bool load = false;

  Property property = Property();
  c.Category category = c.Category();

  String selectedTab = Strings.details;

  late Color colorPrimary;
  @override
  void initState() {
    id = widget.id;
    colorPrimary = widget.colorPrimary;
    getPropertyDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: load ? SafeArea(
        child: Column(
          children: [
            getTabs(),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: selectedTab==Strings.details ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getImageView(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child:  getDetails()
                      )
                    ],
                  ) : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: getAmenities(),
                  )
                ),
              ),
            ),
          ],
        ),
      )
      :  Center(
        child: CircularProgressIndicator(color: colorPrimary,),
      ),
    );
  }


  getTabs() {
    return Container(
      width: MySize.size100(context),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: MyColors.grey1))
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: getTab(Strings.details),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: getTab(Strings.amenities),
          ),
        ],
      ),
    );
  }

  getTab(String title) {
    bool select = title==selectedTab;
    return GestureDetector(
      onTap: () {
        if(!select) {
          selectedTab = title;
          setState(() {

          });
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: select ? Border(bottom: BorderSide(color: colorPrimary, width: 1.5)) : null
          ),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: select ? FontWeight.w500 : FontWeight.w400
            ),
          ),
        ),
    );
  }

  getDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getHeadTitle(property.details?.projectName??""),
        SizedBox(
          height: 10,
        ),
        getSubTitle(Environment.rupee+(property.details?.rate??"")+" (RATE)"),
        getSubTitle(Environment.rupee+(Essential().getWrittenValue(double.parse(property.details?.amount??"0")))),
        SizedBox(
          height: 20,
        ),
        getDataColumn("Property On", property.details?.purpose??""),
        getDataColumn("Category", property.details?.categoryName??""),
        getDataColumn("Area", property.details?.areaName??""),
        if(category.ssqft=="1")
          getDataColumn("Super SqFt", property.details?.sqftSuper??""),
        if(category.csqft=="1")
          getDataColumn("Carpet SqFt", property.details?.sqftCarpet??""),
        if(category.bhk=="1")
          getDataColumn("BHK", property.details?.bhk??""),
        if(category.varr=="1")
          getDataColumn("Var", property.details?.varr??""),
        if(category.vigha=="1")
          getDataColumn("Vigha", property.details?.vigha??""),
        if(category.number=="1")
          getDataColumn("Number", property.details?.number??""),
        if(category.blockNumber=="1")
          getDataColumn("Block Number", property.details?.blockNumber??""),
        if(category.tPSurveyNo=="1")
          getDataColumn("TP Survey No", property.details?.tPSurveyNo??""),
        if(category.furnishedOrNot=="1")
          getDataColumn("Furnishing Status", property.details?.furnishedOrNot??""),
        if(category.floor=="1")
          getDataColumn("Floor", property.details?.floor??""),
        if(category.condition=="1")
          getDataColumn("Condition", property.details?.condition??""),
        if(category.remarks=="1")
          getDataColumn("Remarks", property.details?.remarks??""),
        getDataColumn("Construction", (property.details?.construction??"")=="UNDER CONSTRUCTION" ? property.details?.possessionDate??"" : property.details?.construction??""),
        getDataColumn("Property Type", property.details?.saleType??""),
        getDataColumn("Rera", property.details?.rera??""),
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
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(colorPrimary)
                    ),
                    child: Text("View Brochure",  style: TextStyle(color: MyColors.white),)
                ),
              ),
            ),
            if(property.details!.brochure!.isNotEmpty)
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: ElevatedButton(
                      onPressed: () async {
                        String info = property.details?.brochure??"";
                        print(info);
                        final docurl = Environment.brochureUrl + info;
                        final uri = Uri.parse(docurl);
                        final response = await http.get(uri);
                        final bytes = response.bodyBytes;
                        final temp = await getTemporaryDirectory();
                        final path = '${temp.path}/'+(property.details?.projectName??"Project")+"_Brochure"+(info.substring(info.lastIndexOf("."), info.length));
                        File(path).writeAsBytesSync(bytes);
                        await Share.shareFiles([path]);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(colorPrimary)
                      ),
                      child: Text("Share Brochure", style: TextStyle(color: MyColors.white),)
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }

  getAmenities() {
    print(property.amenities?.length);
    return ListView.separated(
      itemCount: property.amenities?.length??0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (BuildContext buildContext, int index) {
        return const SizedBox(
          width: 10,
        );
      },
      itemBuilder: (BuildContext buildContext, int index) {
        return getAmenityCard(property.amenities![index]);
      },
    );
  }

  getAmenityCard(Amenity amenity) {
    return Row(
      children: [
        Image.network(
            Environment.amenitiesUrl + (amenity.icon ?? ""),
            fit: BoxFit.fill,
            width: 30,
            height: 30
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          amenity.amenity??"",
          style: TextStyle(
            fontSize: 16
          ),
        )
      ],
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

  getDataColumn(String title, String info) {
    return Column(
      children: [
        getData(title, info),
        SizedBox(
          height: 10,
        ),
      ],
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
    category = propertyResponse.category ?? c.Category();

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
                MaterialPageRoute(builder: (context) => PhotoView(images: property.images ?? [], image: [],)
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
