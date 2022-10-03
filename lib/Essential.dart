import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_estate_brokers/toast/Toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Essential {

  call(String number) async {
    print("hello");
    print("hello");
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);

  }

  sms(String number) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: <String, String>{
        'body': Uri.encodeComponent('Hello'),
      },
    );
    await launchUrl(smsLaunchUri);

  }


  whatsapp(String number, BuildContext context) async {
    var whatsapp ="+91"+(number);
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    print(whatsappURl_android);
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isIOS){
      // for iOS phone only
      if(await launch(whatappURL_ios, forceSafariVC: false)){

      }else{
        Toast.sendToast(context, "Whatsapp not installed");

      }

    }else{
      // android , web
      if( await launch(whatsappURl_android)) {
      }else{
        Toast.sendToast(context, "Whatsapp not installed");
      }


    }
  }

  link(String link) {
    launchUrlString(link);
  }

  email(String email) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Property Broker'
      }),
    );

    launchUrl(emailLaunchUri);
  }

  String getWrittenValue(double value) {
    double amount = value;

    String amt = "0";
    double a = 0;
    if(amount >= 1000000000) {
      a = amount / 10000000;
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toStringAsFixed(2)}Cr';
    }
    else if (amount >= 10000000) {
      a = amount / 10000000;
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) {
      a = amount / 100000;
      print(a.toString().substring(a.toString().indexOf(".")+1));
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toStringAsFixed(2)}L';
    }else if (amount >= 1000) {
      a = amount / 1000;
      amt = '${a.toString().substring(a.toString().indexOf(".")+1)=="0" ? int.parse(a.round().toString()).toString() : a.toStringAsFixed(2)}k';
    }
    else {
      amt = '0';
    }
    return amt;
  }
}