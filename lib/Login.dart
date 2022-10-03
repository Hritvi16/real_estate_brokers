import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:real_estate_brokers/HomeScreen.dart';
import 'package:real_estate_brokers/api/APIConstant.dart';
import 'package:real_estate_brokers/api/APIService.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'size/MySize.dart';

class Login extends StatefulWidget {
  const Login({Key? key,}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobile = TextEditingController();
  bool ignore = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Real Estate Brokers",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        foreground: Paint()..shader = LinearGradient(
                          colors: <Color>[
                            MyColors.colorDarkPrimary,
                            MyColors.colorDarkSecondary,
                          ],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 100.0))
                    )
                ),
                SizedBox(
                  height: MySize.sizeh5(context),
                ),
                Text(
                    "Client Panel Login",
                    style: TextStyle(
                        fontSize: 22,
                        color: MyColors.colorDarkSecondary
                    )
                ),
                SizedBox(
                  height: MySize.sizeh15(context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: mobile,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Mobile No.",
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                IgnorePointer(
                  ignoring: ignore,
                  child: SizedBox(
                    height: 45,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () {
                          if (mobile.text.length==10) {

                            ignore = true;
                            setState(() {

                            });
                            login();
                          }
                        },
                        child: const Text("Login")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  start() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> login() async {
    Map<String, dynamic> data = new Map();
    data['mobile'] = mobile.text;
    data.addAll({APIConstant.act : APIConstant.auth});
    LoginResponse loginResponse = await APIService().login(data);

    ignore = false;
    setState(() {

    });

    if(loginResponse.status=="Success" && loginResponse.message=="Logged In") {

      sharedPreferences.setString("id", loginResponse.broker?.id??"");
      sharedPreferences?.setString("color", loginResponse.broker?.color??"58835d");
      sharedPreferences?.setString("logo", loginResponse.broker?.logo??"");
      sharedPreferences.setString("username", loginResponse.broker?.username??"");
      sharedPreferences.setString("company", loginResponse.broker?.companyName??"");
      sharedPreferences.setString("logo", loginResponse.broker?.logo??"");
      sharedPreferences.setString("mobile", mobile.text);
      sharedPreferences.setString("status", "logged in");

      print("hello login");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
      // Navigator.of(context).push(
      //     MaterialPageRoute(
      //         builder: (BuildContext context) =>
      //     OTPScreen(id: loginResponse.account?.id??"", name: loginResponse.account?.name??"", mobile: mobile.text)));
    }
    else {
      Toast.sendToast(context, loginResponse.message??"");
    }
  }
}
