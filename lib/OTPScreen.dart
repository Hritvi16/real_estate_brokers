import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:real_estate_brokers/HomeScreen.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'colors/MyColors.dart';

class OTPScreen extends StatefulWidget {
  final String id, name, mobile;
  const OTPScreen({Key? key, required this.id, required this.name, required this.mobile}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpFieldController otpController = new OtpFieldController();

  late String id, name, mobile, otp;
  late SharedPreferences sharedPreferences;
  late String verificationIDReceived;

  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime limit = DateTime.now();
  var temp;
  // String signature = "";
  // String codeValue = "";

  late Timer timer;
  int start_time = 0;

  @override
  void initState() {
    id =widget.id;
    name =widget.name;
    mobile =widget.mobile;
    otp = "";
    start();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec, (Timer timer) {
        if (start_time == 0) {
          // setState(() {
            timer.cancel();
          // });
        } else {
          if (mounted) {
          setState(() {
            start_time--;
          });
          }
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(00.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "VERIFY OTP",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Padding(
                padding: EdgeInsets.all(MySize.size10(context)),
                child: Center(
                  child: OTPTextField(
                      controller: otpController,
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 40,
                      fieldStyle: FieldStyle.box,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      otpFieldStyle: OtpFieldStyle(
                          focusBorderColor: MyColors.colorPrimary
                      ),
                      outlineBorderRadius: 5,
                      style: TextStyle(fontSize: 17),
                      onChanged: (pin) {
                        print("Changed: " + pin);
                      },
                      onCompleted: (pin) async {
                        // print(pin);
                        // print(otp);
                        // print(limit.difference(DateTime.now()).isNegative);
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: verificationIDReceived, smsCode: pin);
                        try {
                          await auth.signInWithCredential(credential).then((value) {
                            if (value.user != null) {
                            // if("123456"==pin){
                              sharedPreferences.setString("id", id);
                              sharedPreferences.setString("name", name);
                              sharedPreferences.setString("mobile", mobile);
                              sharedPreferences.setString("status", "logged in");

                              getToken();

                                print("hello login");
                                setState(() {

                                });
                                timer.cancel();
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) => const HomeScreen(contacts: ,)),
                                //         (Route<dynamic> route) => false);
                            }
                            else {
                              SnackBar snackBar = SnackBar(
                                  content: Text("Invalid OTP"),
                                  duration: const Duration(seconds: 1)
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });
                        } catch (e1) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Invalid Code")));
                        }

                      }
                      ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              start_time>0 ?
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: MySize.size16(context)),
                child: Text(
                  "Resend OTP in "+start_time.toString()+" secs",
                  style: TextStyle(
                      color: MyColors.grey,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ) :
              GestureDetector(
                onTap: () {
                  start_time = 60;
                  setState(() {

                  });
                  startTimer();
                  getOTP("OTP Resent");
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: MySize.size16(context)),
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                        color: MyColors.colorPrimary,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              // GestureDetector(
              //   onTap: () {
              //     print(otp);
              //     print(otpController.);

              //   },
              //   child: Container(
              //     height: 40,
              //     width: MediaQuery.of(context).size.width * 0.5,
              //     padding: EdgeInsets.all(8),
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //         color: MyColors.colorPrimary,
              //         borderRadius: BorderRadius.circular(20)
              //     ),
              //     child: Text(
              //       "VERIFY",
              //       style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.w500,
              //           color: MyColors.white
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();

    start_time = 60;
    setState(() {

    });
    startTimer();
    getOTP("OTP Sent");
    // getToken();
  }
  getOTP(String message) async {
    int otp = generateOTP();
print(mobile);
if(Platform.isAndroid) {
  await auth.verifyPhoneNumber(
    phoneNumber: '+91 $mobile',
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential).then((value) async {
        if (value.user != null) {
          setState(() {});
          print("user Logged in");
        }
      });
    },
    codeSent: (String verificationId, int? forceResendingToken) async {
      verificationIDReceived = verificationId;
      otpController.setFocus(0);
      // Toast.sendToast(context, message);
      print("verificationId");
      print(verificationId);
      // signature = await SmsAutoFill().getAppSignature;
      // setState(() {
      //
      // });
      // await SmsAutoFill().listenForCode;
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      verificationIDReceived = verificationId;
      print("timeout");
    },
    verificationFailed: (FirebaseAuthException error) {
      print('fail');
      print(error.message);
    },
  );
}

    // Map<String, dynamic> data = new Map();
    // data['apikey'] = "62978f044f56f";
    // data['route'] = "trans_dnd";
    // data['sender'] = "OLRROM";
    // data['mobileno'] = mobile;
    // DateTime dateTime = DateTime.now().add(Duration(minutes: 10));
    // limit = dateTime;
    // String formattedTime = DateFormat("HH:mm a").format(dateTime);
    // print(formattedTime);
    // print(type);
    // if (type=="Logged In") {
    //   data['text'] = "$otp is the OTP to verify your mobile number with OLR Rooms. OTP is valid till $formattedTime IST. Do not Share with anyone.";
    // }
    // else {
    //   data['text'] = "$otp is the OTP to register your mobile number with OLR Rooms. OTP is valid till $formattedTime IST. Do not Share with anyone.";
    // }
    // String response = await APIService().sendSMS(data);
    // print(response);
    // temp = await FirebaseAuthentication().sendOTP(mobile);
    this.otp = otp.toString();
    setState(() {

    });
    // print("this.otp");
    // print(this.otp);
    //
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text(
    //     response.trim()=="1 messages scheduled for delievery" ?
    //     message : "There's some issue with the server.")));
    otpController.setFocus(0);
  }

  generateOTP() {
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    print(next.toInt());
    return next.toInt();
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("token");
    print(token);
    print("token");
    insertUserFCM(token!);
  }

  Future<void> insertUserFCM(String token) async {
    Map<String, dynamic> data = new Map();
    data['fcm'] = token;
    data['id'] = id;

    print(data);

    // Response response = await APIService().insertUserFCM(data);

    print("response.message");
    // print(response.message);
  }

  @override
  void codeUpdated() {
    // otpController.set([pin])
    print("updatedddd");
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}