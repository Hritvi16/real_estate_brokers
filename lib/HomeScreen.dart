
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:real_estate_brokers/filters/Filters.dart';
import 'package:real_estate_brokers/leads/Leads.dart';
import 'package:real_estate_brokers/leads/LeadsMain.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:real_estate_brokers/wishlist/Wishlist.dart';
import 'package:real_estate_brokers/home/Home.dart';
import 'package:real_estate_brokers/settings/Settings.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/models/PropertyResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate_brokers/models/CategoryResponse.dart' as c;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences sharedPreferences;
  Broker broker = Broker();
  List<Property> properties = [];
  List<c.Category> categories = [];

  bool load = false;
  
  int index = 0;


  late List<Widget> screens;

  Color colorPrimary = MyColors.grey10;

  late List<Widget> items;

  bool back = false;

  @override
  void initState() {
    start();
    super.initState();
  }

  change(int index) {
    this.index = index;
    back = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return load ? WillPopScope(
      onWillPop: () async {
        print(index);
        if(index!=0) {
          change(0);
          return false;
        }
        else {
          if(back) {
            print("exit");
            return true;
          }
          else {
            Toast.sendToast(context, "Press back 2 time to exit from the app.");
            back = true;
            setState(() {

            });
            return false;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          color: colorPrimary,
          height: 85,
          child: CurvedNavigationBar(
            backgroundColor: colorPrimary,
            height: 75,
            items: items,
            index: index,
            onTap: (index) {
              this.index = index;
              properties = [];
              setState(() {

              });
            },
          ),
        ),
        body: screens[index],
      ),
    )
    : Container(
      color: MyColors.white,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: MyColors.grey10,
      ),
    );
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getCompanyDetails();
  }

  setItems() {
    items = [
      Icon(
        Icons.home,
        color: MyColors.generateMaterialColor(colorPrimary).shade500,
      ),
      Icon(
        Icons.group,
        color: MyColors.generateMaterialColor(colorPrimary).shade500,
      ),
      Icon(
        Icons.favorite,
        color: MyColors.generateMaterialColor(colorPrimary).shade500,
      ),
      // Icon(
      //   Icons.save,
      //   color: MyColors.generateMaterialColor(colorPrimary).shade500,
      // ),
      Icon(
        Icons.settings,
        color: MyColors.generateMaterialColor(colorPrimary).shade500,
      ),
    ];
    setState(() {

    });
  }

  Future<void> getCompanyDetails() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByID;
    data['id'] = sharedPreferences.getString("id")??"";

    LoginResponse loginResponse = await APIService().getAccountDetails(data);
    broker = loginResponse.broker ?? Broker();

    print(broker.color);

    colorPrimary = Color(int.parse("0xff"+(broker.color??"e6e6e6")));
    setItems();

    getProperties();
  }

  getProperties() async {
    Map<String, dynamic> data = new Map();
    data[APIConstant.act] = APIConstant.getByBroker;
    data['id'] = sharedPreferences.getString("id")??"";

    PropertyListResponse propertyListResponse = await APIService().getProperties(data);
    properties = propertyListResponse.property ?? [];
    categories = propertyListResponse.category ?? [];


    load = true;
    screens = [
      Home(properties: properties, broker: broker, categories: categories,),
      LeadsMain(broker: broker, colorPrimary: colorPrimary),
      // Leads(broker: broker, colorPrimary: colorPrimary, contacts: widget.contacts,),
      Wishlist(broker: broker, colorPrimary: colorPrimary),
      // Filters(broker: broker, colorPrimary: colorPrimary),
      Settings()
    ];
    setState(() {

    });
  }

}
