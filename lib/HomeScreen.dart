import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:real_estate_brokers/PropertyDetail.dart';
import 'package:real_estate_brokers/Search.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'size/MySize.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' show get;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences sharedPreferences;
  Broker broker = Broker();
  List<Property> properties = [];

  bool load = false;
  bool loadp = true;

  List<int> selected = [];

  TextEditingController name = new TextEditingController();

  pw.Document pdf = pw.Document();

  @override
  void initState() {
    start();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return load ? Scaffold(
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
            child: loadp ? Text("Share") : Center(child: CircularProgressIndicator(color: MyColors.white,),)
        ),
      )
      : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              getDivision1(),
              getDivision2(),
              SizedBox(
                height: 10,
              ),
              ListView.separated(
                itemCount: properties.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext buildContext, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (BuildContext buildContext, int index) {
                  return getPropertyCard(properties[index], index);
                },
              ),
            ],
          ),
        ),
      ),
    )
    : Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getCompanyDetails();
  }

  getDivision1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              // Essential().link("http://grassrootsinvestors.com");
            },
            child: Container(
              color: MyColors.white,
              margin: EdgeInsets.only(right: 10),
              child: CachedNetworkImage(
                imageUrl: Environment.companyUrl + (broker.logo??""),
                errorWidget: (context, url, error) {
                  return Icon(
                      Icons.apartment
                  );
                },
                width: 100,
                height: 80,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 6,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  broker.companyName??"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: MyColors.colorPrimary
                  )
              ),

            ],
          ),
        ),
      ],
    );
  }

  getDivision2() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Search()
          )
        ).then((value) {
          if(value!=null) {
            properties = value;
            setState(() {

            });
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MySize.size7(context)),
        padding: EdgeInsets.symmetric(horizontal: MySize.size1(context)),
        width: MySize.size100(context),
        height: 45,
        decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.grey10),
            boxShadow:  [
              BoxShadow(
                color: MyColors.colorPrimary,
                offset: Offset.zero, //(x,y)
                blurRadius: 2.0,
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Search Property"
            ),
            Icon(
              Icons.search
            )
          ],
        ),
      ),
    );
  }

  Widget getPropertyCard(Property property, int index) {
    return GestureDetector(
      onTap: () {
        if(selected.isEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  PropertyDetail(id: property.details?.id ?? "")
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
            color: selected.contains(index) ? MyColors.colorPrimary.withOpacity(0.5) : MyColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.grey10),
            boxShadow: selected.contains(index) ? const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 1.0,
              ),
            ] : []
        ),
        child: Row(
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
              height: 80,
              child: Icon(
                Icons.apartment,

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
                  getData("Price", Environment.rupee+" "+(property.details?.rate??"")),
                ],
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
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                  children: [
                    pw.Container(
                      height: 500,
                      width: 500,
                      alignment: pw.Alignment.center,
                      child: pw.Image(netImage),
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.companyName??"",
                        style: pw.TextStyle(
                            fontSize: 25,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.mobile??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                    pw.SizedBox(
                        height: 10
                    ),
                    pw.Text(
                        broker.email??"",
                        style: pw.TextStyle(
                            fontSize: 20,
                            font: pw.Font.helveticaBold()
                        )
                    ),
                  ]
              );
            }
        )
    );


    for (var element in selected) {
      await createPDF(properties[element]);
    }

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
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Center(
                      child: pw.Text(
                          "PROJECT",
                          style: pw.TextStyle(
                              fontSize: 30,
                              font: pw.Font.helveticaBold()
                          )
                      ),
                    ),
                    pw.SizedBox(
                        height: 30
                    ),
                    pw.Center(
                      child: pw.Text(
                          property.details?.projectName??"",
                          style: pw.TextStyle(
                              fontSize: 35,
                              font: pw.Font.helveticaBold()
                          )
                      ),
                    )
                  ]
              ); // Center
            }
        )
    ); //

    for (var element in (property.images ?? []))  {
      final netImage = await networkImage(Environment.propertyUrl + (element.image??""));
      pdf.addPage(
          pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Image(netImage),
                );
              }
          )
      );
    }
  }

  Future<void> getCompanyDetails() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByID;
    data['id'] = sharedPreferences.getString("id")??"";

    LoginResponse loginResponse = await APIService().getAccountDetails(data);
    broker = loginResponse.broker ?? Broker();

    getProperties();
  }

  getProperties() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByBroker;
    data['id'] = sharedPreferences.getString("id")??"";

    PropertyListResponse propertyListResponse = await APIService().getProperties(data);
    properties = propertyListResponse.property ?? [];

    load = true;
    setState(() {

    });
  }

}
