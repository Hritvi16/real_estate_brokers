import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_brokers/FollowUpDetail.dart';
import 'package:real_estate_brokers/HomeScreen.dart';
import 'package:real_estate_brokers/Login.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if(Platform.isAndroid)
    await Firebase.initializeApp();
  print("handling a background message${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel", "High Importance notification",
    importance: Importance.high);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


final androidConfig = FlutterBackgroundAndroidConfig(
  notificationTitle: "Real Estate Broker",
  notificationText: "Background notification for keeping the Reminder Service",
  notificationImportance: AndroidNotificationImportance.High,
  notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
);

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();





  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp( MyApp(color: Color(int.parse("0xff"+(sharedPreferences?.getString("color")??"58835d"))), logo: sharedPreferences?.getString("logo")??"",));
}

class MyApp extends StatelessWidget {
  final Color color;
  final String logo;
  const MyApp({Key? key, required this.color, required this.logo, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.generateMaterialColor(color),
        textTheme: GoogleFonts.latoTextTheme(),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: MyColors.black),
          color: color,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: color,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      home: MyHomePage(logo: logo),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String logo;
  const MyHomePage({Key? key, required this.logo}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences sharedPreferences;

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  String fcmId = "";
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    //enableBackgroundService(androidConfig);
    if(Platform.isAndroid) {




      enableBackgroundExecution();
      var initializationSettingsAndroid =
      AndroidInitializationSettings("app_icon");
      var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
          onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      playSound: true,
                      enableVibration: true,
                      enableLights: true,
                      styleInformation: BigTextStyleInformation(
                        // sharedPreferences.getString("company")??"",
                        notification.body??"",
                        htmlFormatBigText: true,
                        htmlFormatContent: true,
                        htmlFormatContentTitle: true,
                        htmlFormatTitle: true,
                        contentTitle: notification.title,
                        // summaryText: notification.body,
                      ),
                      //,Remove this channel.description,
                      icon: "app_icon")));
        }
      });
    }
    Future.delayed(Duration(seconds: 0), () async {
      checkStatus();
    });
    Future.delayed(Duration(seconds: 3), () {

      taketo();
    });

  }
// 9328922587
  Future<void> checkStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    print("payloadddddd");
    print(payload);
    print(notificationResponse.id);
    print(notificationResponse.actionId);
    print(notificationResponse.input);
    // if (notificationResponse.payload != null) {
    //   debugPrint('notification payload: $payload');
    // }
    Navigator.push(
      key.currentContext!,
      MaterialPageRoute<void>(builder: (context) => FollowUpDetail(
        id: notificationResponse.id.toString(),
        colorPrimary:  Color(int.parse("0xff"+(sharedPreferences.getString("color")??"e6e6e6"))),
      )),
    );
  }

  // Future<void> enableBackgroundService(FlutterBackgroundAndroidConfig androidConfig)
  // async {
  //   await FlutterBackground.initialize(androidConfig: androidConfig).whenComplete(() {
  //     enableBackgroundWork();
  //   });
  // }


  Future<void> taketo() async {
    if (sharedPreferences != null) {
      if (sharedPreferences.getString("status") == "logged in") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login()),
                (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
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
                widget.logo.isEmpty ? Text(
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
                ) : Container(
                  color: MyColors.white,
                  child: CachedNetworkImage(
                    imageUrl: Environment.companyUrl + widget.logo,
                    errorWidget: (context, url, error) {
                      return Icon(
                          Icons.apartment
                      );
                    },
                    width: MySize.size75(context),
                    height: MySize.size75(context),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Future<void> enableBackgroundExecution()
  async {
    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
  }

}


