import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/PDFDesign.dart';
import 'package:real_estate_brokers/PropertyDetail.dart';
import 'package:real_estate_brokers/home/Search.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart' as c;
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../size/MySize.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final List<Property> properties;
  final Broker broker;
  final List<c.Category> categories;
  const Home({Key? key, required this.properties, required this.broker, required this.categories}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences sharedPreferences;
  Broker broker = Broker();
  List<Property> properties = [];
  List<Property> filterProperties = [];
  List<c.Category> categories = [];

  bool load = false;
  bool loadp = true;

  List<int> selected = [];

  TextEditingController name = new TextEditingController();

  pw.Document pdf = pw.Document();

  Color colorPrimary = MyColors.colorPrimary;

  @override
  void initState() {
    properties = widget.properties;
    filterProperties.addAll(properties);
    broker = widget.broker;
    categories = widget.categories;

    start();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return load ? MaterialApp(
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
        body: RefreshIndicator(
          onRefresh: () async {
            await getCompanyDetails();
          },
          child: Container(
            width: MySize.size100(context),
            height: MySize.sizeh100(context),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
                children: [
                  getDivision1(),
                  getDivision2(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Flexible(
                    child: Container(

                      decoration: BoxDecoration(
                          color: MyColors.white,
                      ),
                      padding:  EdgeInsets.symmetric(horizontal: MySize.size5(context), vertical: 10),
                      child: filterProperties.isNotEmpty ? ListView.separated(
                        itemCount: filterProperties.length,
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext buildContext, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (BuildContext buildContext, int index) {
                          return getPropertyCard(filterProperties[index], index);
                        },
                      )
                      : const Center(
                        child: Text(
                        "No Properties"
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    )
    : Center(
      child: CircularProgressIndicator(color:  colorPrimary,),
    );
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(properties.isEmpty) {
      getCompanyDetails();
    }
    else {
      colorPrimary = Color(int.parse("0xff"+(broker.color??"58835d")));
      sharedPreferences?.setString("color", broker.color??"58835d");
      sharedPreferences?.setString("logo", broker.logo??"");
      load = true;
      setState(() {

      });
    }
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
                      color: colorPrimary
                  )
              ),

            ],
          ),
        ),
      ],
    );
  }

  // getDivision2() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => Search(colorPrimary: colorPrimary,)
  //         )
  //       ).then((value) {
  //         if(value!=null) {
  //           print(value);
  //           if(value=="clear") {
  //             load = false;
  //             getProperties();
  //           }
  //           else {
  //             properties = value;
  //           }
  //
  //           setState(() {
  //
  //           });
  //         }
  //       });
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: MySize.size7(context)),
  //       padding: EdgeInsets.symmetric(horizontal: MySize.size1(context)),
  //       width: MySize.size100(context),
  //       height: 45,
  //       decoration: BoxDecoration(
  //           color: MyColors.white,
  //           borderRadius: BorderRadius.circular(5),
  //           border: Border.all(color: MyColors.grey10),
  //           boxShadow:  [
  //             BoxShadow(
  //               color: colorPrimary,
  //               offset: Offset.zero, //(x,y)
  //               blurRadius: 2.0,
  //             ),
  //           ]
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             "Search Property"
  //           ),
  //           Icon(
  //             Icons.search
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  getDivision2() {
    return Row(
      children: [
        Container(
          width: MySize.size75(context),
          margin: const EdgeInsets.only(left: 10),
          child: TextFormField(
            onChanged: (value) {
              if(value.isNotEmpty) {
                searchProperties(value);
              }
              else {
                filterProperties = properties;
                setState(() {

                });
              }
            },
            cursorColor: Colors.black,
            decoration:  const InputDecoration(
              hintText: "Search Properties",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Search(colorPrimary: colorPrimary,)
                  )
                ).then((value) {
                  if(value!=null) {
                    if(value=="clear") {
                      load = false;
                      getProperties();
                    }
                    else {
                      properties = value;
                      filterProperties = value;
                    }

                    setState(() {

                    });
                  }
                });
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorPrimary.withOpacity(0.5)
                ),
                child: const Icon(
                    Icons.filter_alt_outlined
                ),
              ),
            ),
          ),
        ),
      ],
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
                  getData("Super Sq.Ft.", property.details?.sqftSuper??""),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Carpet Sq.Ft.", property.details?.sqftCarpet??""),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Rate", Environment.rupee+" "+(property.details?.rate??"")),
                  SizedBox(
                    height: 10,
                  ),
                  getData("Amount", Environment.rupee+" "+(Essential().getWrittenValue(double.parse(property.details?.amount??"0")))),
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

                manageWishlist(index);
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


    String text = "Company Name :  ${broker.companyName??""}\n";
    text += "Office No.1 :  ${broker.officeNumber1??""}\n";

    if(broker.officeNumber2!.isNotEmpty) {
      text += "Office No.2 :  ${broker.officeNumber2 ?? ""}\n";
    }
    text += "Email :  ${broker.email??""}\n";


    List<String> paths = [];
    for (var element in selected) {
      if(properties[element].details!.brochure!.isNotEmpty) {
        text += "${broker.companyName??""} Brochure :  ${properties[element].details?.brochure??""}";
        String info = properties[element].details?.brochure??"";
        final docurl = Environment.brochureUrl + info;
        final uri = Uri.parse(docurl);
        final response = await http.get(uri);
        final bytes = response.bodyBytes;
        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/'+(properties[element].details?.projectName??"Project")+"_Brochure"+(info.substring(info.lastIndexOf("."), info.length));
        File(path).writeAsBytesSync(bytes);
        paths.add(path);
      }
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

    paths.insert(0, file.path);

    // await Share.share(text.trim(), subject: text.trim(),
    await Share.shareFiles(paths, text: "text.trim()");
    // await WhatsappShare.shareFile(
    //   text: text.trim(),
    //   filePath: [file.path],
    // );
    loadp = true;
    setState(() {

    });
  }

  createPDF(Property property) async {
    pdf.addPage(
        PDFDesign.getPropertyPage(property, getCategory(property.details?.categoryID??""), broker)
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


  Future<void> getCompanyDetails() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByID;
    data['id'] = sharedPreferences.getString("id")??"";

    LoginResponse loginResponse = await APIService().getAccountDetails(data);
    broker = loginResponse.broker ?? Broker();

    colorPrimary = Color(int.parse("0xff"+(broker.color??"58835d")));
    sharedPreferences?.setString("color", broker.color??"58835d");
    sharedPreferences?.setString("logo", broker.logo??"");

    getProperties();
  }

  getProperties() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByBroker;
    data['id'] = sharedPreferences.getString("id")??"";

    PropertyListResponse propertyListResponse = await APIService().getProperties(data);
    properties = propertyListResponse.property ?? [];
    categories = propertyListResponse.category ?? [];
    filterProperties.addAll(properties);

    load = true;
    setState(() {

    });
  }

  Future<void> manageWishlist(index) async {
    Map<String, dynamic> data = new Map();
    data['id'] = properties[index].details?.id??"";
    data['wishlist'] = properties[index].details?.wishlist??"";
    data.addAll({APIConstant.act : APIConstant.updateWishlist});
    Response response = await APIService().updateWishlist(data);


    if(response.status=="Failure") {
      properties[index].details?.wishlist = "0";
      setState(() {

      });
    }

  }

  c.Category getCategory(String id) {
    c.Category category = c.Category();
    categories.forEach((element) {
      if(element.id==id)
        category = element;
    });
    return category;
  }

  void searchProperties(String value) {
    filterProperties = [];
    for (var element in properties) {
      if(element.details!.projectName!.toLowerCase().contains(value.toLowerCase())) {
        filterProperties.add(element);
      }
    }

    setState(() {

    });
  }
}
