import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_brokers/HomeScreen.dart';
import 'package:real_estate_brokers/Login.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if(Platform.isAndroid)
//     await Firebase.initializeApp();
//   print("handling a background message${message.messageId}");
// }
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     "high_importance_channel", "High Importance notification",
//     importance: Importance.high);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // if(Platform.isAndroid) {
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.generateMaterialColor(MyColors.colorPrimary),
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: MyColors.black),
          color: MyColors.colorPrimary,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.colorPrimary,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences sharedPreferences;
  String fcmId = "";
  @override
  void initState() {
    // if(Platform.isAndroid) {
    //   var initializationSettingsAndroid =
    //   AndroidInitializationSettings("app_icon");
    //   var initializationSettings =
    //   InitializationSettings(android: initializationSettingsAndroid);
    //
    //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
    //
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       flutterLocalNotificationsPlugin.show(
    //           notification.hashCode,
    //           notification.title,
    //           notification.body,
    //           NotificationDetails(
    //               android: AndroidNotificationDetails(channel.id, channel.name,
    //                   playSound: true,
    //                   //,Remove this channel.description,
    //                   icon: "app_icon")));
    //     }
    //   });
    // }
    Future.delayed(Duration(seconds: 0), () async {
      checkStatus();
    });
    Future.delayed(Duration(seconds: 3), () {
      taketo();
    });
    super.initState();
  }

  Future<void> checkStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
  Future<void> taketo() async {
    if (sharedPreferences != null) {
      if (sharedPreferences.getString("status") == "logged in") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()),
                (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
                (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            color: MyColors.white,
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //     "assets/logo/logo.jpg",
                //     height: 150,
                //     width: 150
                // ),
                // SizedBox(
                //   height: 70,
                // ),
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
              ],
            ),
          ),
        )
    );
  }

}


