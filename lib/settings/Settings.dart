import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:real_estate_brokers/filters/Filters.dart';
import 'package:real_estate_brokers/settings/ContactUs.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/Login.dart';
import 'package:real_estate_brokers/LoginPopUp.dart';
import 'package:real_estate_brokers/settings/MyProfile.dart';
import 'package:real_estate_brokers/wishlist/Wishlist.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key,}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool load = false;
  Broker broker = Broker();
  late SharedPreferences sharedPreferences;
  Color colorPrimary = MyColors.grey10;
  
  @override
  void initState() {
    start();
    super.initState();
  }

  start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.white,
        elevation: 0,
        title: Text(
            broker.companyName??"",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorPrimary
            )
        ),
      ),
      body: load ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MySize.size100(context),
              height: 150,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: MyColors.grey10
                      )
                  )
              ),
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
            getInfo("VISIT WEBSITE", "website"),
            SizedBox(
              height: 20,
            ),
            getInfo(broker.mobile??"", "mobile"),
            SizedBox(
              height: 5,
            ),
            getInfo(broker.email??"", "email"),
            SizedBox(
              height: 20,
            ),
            getSettingsCard(Icons.account_circle, "My Profile"),
            getSettingsCard(Icons.favorite, "My Favorites"),
            getSettingsCard(Icons.save, "Saved"),
            getSettingsCard(Icons.contact_mail_outlined, "Contact Us"),
            getSettingsCard(Icons.power_settings_new, "Logout")
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getInfo(String info, String label) {
    return GestureDetector(
      onTap: () {
        if(label=="mobile")
          Essential().call(info);
        else if(label=="email")
          Essential().email(info);
        else
          Essential().link("http://www.karmbhoomirealtors.in");
      },
      child: Text(
        info,
        style: TextStyle(
            color: MyColors.generateMaterialColor(colorPrimary).shade300,
            fontSize: 14,
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  getSettingsCard(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: MySize.size10(context)),
      child: GestureDetector(
        onTap: () {
          if(title=="My Profile") {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MyProfile()));
          }
          else if(title=="Contact Us") {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ContactUs(colorPrimary: colorPrimary, broker: broker,)));
          }
          else if(title=="My Favorites") {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Wishlist(colorPrimary: colorPrimary, broker: broker,)));
          }
          else if(title=="Saved") {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Filters(colorPrimary: colorPrimary, broker: broker,)));
          }
          else if(title=="Logout") {
            loginPopUp();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                  size: 25,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> getCompanyDetails() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByID;
    data['id'] = sharedPreferences.getString("id")??"";

    LoginResponse loginResponse = await APIService().getAccountDetails(data);
    broker = loginResponse.broker ?? Broker();


    colorPrimary = Color(int.parse("0xff"+(broker.color??"58835d")));

    load = true;
    setState(() {

    });
  }

  loginPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return LoginPopUp(
          text: "Are you sure you want to logout?",
          btn1 : "Cancel",
          btn2: "Logout", colorPrimary: colorPrimary,
        );
      },
    ).then((value) {
      if(value=="Logout")
        logout();
    });
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("id", "");
    sharedPreferences.setString("name", "");
    sharedPreferences.setString("mobile", "");
    sharedPreferences.setString("status", "logged out");
    sharedPreferences?.setString("color", "58835d");
    sharedPreferences?.setString("logo", "");


    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => Login()),
            (Route<dynamic> route) => false);
  }
}
