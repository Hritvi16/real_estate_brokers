import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/AreaResponse.dart';
import 'package:real_estate_brokers/models/CityResponse.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/Response.dart';
import 'package:real_estate_brokers/photoView/PhotoView.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  bool load = false;
  late SharedPreferences sharedPreferences;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Broker broker = Broker();

  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cn = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController web1 = TextEditingController();
  TextEditingController web2 = TextEditingController();
  TextEditingController off1 = TextEditingController();
  TextEditingController off2 = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pincode = TextEditingController();

  DateTime? dob;
  DateTime? anniversary;

  Color colorPrimary = MyColors.grey10;

  List<City> cities = [];
  List<String> citiesString = [];
  String? city;

  List<Area> areas = [];
  List<String> areasString = [];
  String? area;

  @override
  void initState() {
    start();
    super.initState();
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    return load ? Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
            "MY PROFILE",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorPrimary
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhotoView(
                            images: [],
                            image: [Environment.companyUrl + (broker.logo??"")],
                          )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: colorPrimary,
                    radius: 71,
                    child: CircleAvatar(
                      foregroundColor: Colors.transparent,
                      radius: 70,
                      child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: Environment.companyUrl + (broker.logo??""),
                            errorWidget: (context, url, error) {
                              return ClipOval(
                                child: Icon(
                                  Icons.account_circle,
                                  size: 120,
                                ),
                              );
                            },
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              getUserDetails(),
              SizedBox(
                height: 20,
              ),
              getCompanyDetails(),
              SizedBox(
                height: 20,
              ),
              getGeneralDetails(),
              SizedBox(
                height: 30,
              ),
              Container(
                  height: 45,
                  width: MySize.size70(context),
                  margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        if(formkey.currentState!.validate()) {
                          updateProfile();
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(colorPrimary)
                      ),
                      child: Text("UPDATE", style: TextStyle(color: MyColors.white),)
                  ),
                ),
            ],
          ),
        ),
      )
    )
    : Container(
      color: MyColors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorPrimary,
      ),
    );
  }

  getCardLabel(String label) {
    return Container(
        width: MySize.size100(context),
        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorPrimary,
        ),
        child: getLabel(label)
    );
  }

  getLabel(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: MyColors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600
      ),
    );
  }

  getInfoController(String title, TextEditingController controller) {
    return Row(
      children: [
        getTitle(title),
        title=="Address" ? getAddController(title, controller) : getController(title, controller)
      ],
    );
  }

  getTitle(String title) {
    return Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: MyColors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  getController(String title, TextEditingController controller) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: TextFormField(
        controller: controller,
        readOnly: title=="Username" || title=="Mobile No.",
        enabled: title!="Username" && title!="Mobile No.",
        keyboardType: title.contains("Office No") || title =="Pincode" ? TextInputType.phone : title=="Email" ?  TextInputType.emailAddress : TextInputType.text,
        inputFormatters: [
          if(title.contains("Office No") || title =="Pincode")
            FilteringTextInputFormatter.digitsOnly
        ],
        cursorColor: colorPrimary,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: colorPrimary
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: colorPrimary
                )
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10)
        ),
        validator: (value) {
          if(title!="GST" && title!="Office No. 2" && title!="Website 2") {
            if (value!.isEmpty) {
              return "* Required";
            }
            else {
              return null;
            }
          }
          else {
            return null;
          }

        },
      ),
    );
  }

  getAddController(String title, TextEditingController controller) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: TextFormField(
        controller: controller,
        maxLines: 5,
        cursorColor: colorPrimary,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: colorPrimary
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: colorPrimary
                )
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10)
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "* Required";
          }  else {
            return null;
          }

        },
      ),
    );
  }

  getInfoDropdown(String title) {
    return Row(
      children: [
        getTitle(title),
        title=="City" ? getCityDropdown() : getAreaDropdown()
      ],
    );
  }

  getCityDropdown() {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: IgnorePointer(
        ignoring: true,
        child: DropdownSearch<String>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            showSearchBox: true,
          ),
          items: citiesString,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Select City",
            ),
          ),
          validator: (value) {
            if (value==null) {
              return "* Required";
            }
            else {
              return null;
            }
          },
          onChanged: (value) {
            city = value;
            setState(() {});
            getAreas();
          },
          selectedItem: city,
        ),
      ),
    );
  }

  getAreaDropdown() {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: IgnorePointer(
        ignoring: true,
        child: DropdownSearch<String>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            showSearchBox: true,
          ),
          items: areasString,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Select Area",
            ),
          ),
          validator: (value) {
            if (value==null) {
              return "* Required";
            }
            else {
              return null;
            }
          },
          onChanged: (value) {
            area = value;
            setState(() {});
          },
          selectedItem: area,
        ),
      ),
    );
  }

  getCompanyDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          getCardLabel("Company Details"),
          SizedBox(
            height: 10,
          ),
          getInfoController("Company Name", cn),
          SizedBox(
            height: 15,
          ),
          getInfoController("Email", email),
          SizedBox(
            height: 15,
          ),
          getInfoController("Website 1", web1),
          SizedBox(
            height: 15,
          ),
          getInfoController("Website 2", web2),
          SizedBox(
            height: 15,
          ),
          getInfoController("Office No. 1", off1),
          SizedBox(
            height: 15,
          ),
          getInfoController("Office No. 2", off2),
          SizedBox(
            height: 15,
          ),
          getInfoController("GST", gst),
          SizedBox(
            height: 15,
          ),
          getInfoController("Address", address),
        ],
      ),
    );
  }

  getUserDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          getCardLabel("User Details"),
          SizedBox(
            height: 10,
          ),
          getInfoController("Username", username),
          SizedBox(
            height: 15,
          ),
          getInfoController("Mobile No.", phone),
        ],
      ),
    );
  }

  getGeneralDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          getCardLabel("General Details"),
          SizedBox(
            height: 10,
          ),
          getInfoController("State", state),
          SizedBox(
            height: 15,
          ),
          getInfoDropdown("City"),
          SizedBox(
            height: 15,
          ),
          getInfoDropdown("Area"),
          SizedBox(
            height: 15,
          ),
          getInfoController("Pincode", pincode),
        ],
      ),
    );
  }

  getCities() async {
    Map<String, dynamic> data = {
      APIConstant.act : APIConstant.getAll,
    };

    CityResponse cityResponse = await APIService().getCities(data);
    cities = cityResponse.city ?? [];

    for (var element in cities) {
      citiesString.add(element.name!);
    }

    setState(() {

    });

    getProfile();
  }

  getAreas() async {
    Map<String, dynamic> data = {
      APIConstant.act : APIConstant.getByCID,
      "id" : cities[citiesString.indexOf(city!)].id??""
    };

    AreaResponse areaResponse = await APIService().getAreas(data);
    areas = areaResponse.area ?? [];

    for (var element in areas) {
      areasString.add(element.name!);
      if(element.id==broker.areaID) {
        area = element.name;
      }
    }

    load = true;
    setState(() {

    });
  }

  getProfile() async {
    Map<String,String> queryParameters = {
      APIConstant.act : APIConstant.getByID,
      "id" : sharedPreferences.getString("id")??"",
    };

    LoginResponse loginResponse = await APIService().getAccountDetails(queryParameters);

    broker = loginResponse.broker ?? Broker();

    colorPrimary = Color(int.parse("0xff"+(broker.color??"e6e6e6")));

    setState(() {

    });

    setData();

  }

  void setData() {
    username.text = broker.username??"";
    phone.text = broker.mobile??"";
    cn.text = broker.companyName??"";
    email.text = broker.email??"";
    web1.text = broker.website1??"";
    web2.text = broker.website2??"";
    off1.text = broker.officeNumber1??"";
    off2.text = broker.officeNumber2??"";
    gst.text = broker.gstin??"";
    address.text = broker.address??"";
    state.text = broker.state??"";
    pincode.text = broker.pincode??"";

    print(broker.cityID);
    for (var element in cities) {
      if(element.id==broker.cityID) {
        city = element.name;
      }
    }

    setState(() {

    });

    if(city!=null) {
      getAreas();
    }
    else {
      load = true;
      setState(() {

      });
    }
  }

  Future<void> updateProfile() async {
    Map<String, dynamic> data = new Map();
    data['id'] = sharedPreferences.getString("id");
    data['company_name'] = cn.text;
    data['gstin'] = gst.text;
    data['address'] = address.text;
    data['email'] = email.text;
    data['website1'] = web1.text;
    data['website2'] = web2.text;
    data['office_number_1'] = off1.text;
    data['office_number_2'] = off2.text;
    data['state'] = state.text;
    data['cityID'] = cities[citiesString.indexOf(city??"")].id??"";
    data['areaID'] = areas[areasString.indexOf(area??"")].id??"";
    data['pincode'] = pincode.text;
    data.addAll({APIConstant.act : APIConstant.update});

    Response response = await APIService().updateProfile(data);



    Toast.sendToast(context, response.message??"");
  }
}
