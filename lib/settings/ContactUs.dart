import 'package:flutter/material.dart';
import 'package:real_estate_brokers/Essential.dart';
import 'package:real_estate_brokers/api/Environment.dart';
import 'package:real_estate_brokers/models/LoginResponse.dart';
import 'package:real_estate_brokers/size/MySize.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContactUs extends StatefulWidget {
  final Broker broker;
  final Color colorPrimary;
  const ContactUs({Key? key, required this.broker, required this.colorPrimary}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}


class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MySize.size100(context),
        height: MySize.sizeh100(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: MySize.sizeh5(context)),
                child: CachedNetworkImage(
                  imageUrl: Environment.companyUrl + (widget.broker.logo??""),
                  errorWidget: (context, url, error) {
                    return Icon(
                        Icons.apartment
                    );
                  },
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: getDesign(Icons.phone_iphone, widget.broker.mobile??"", "mobile"),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: getDesign(Icons.email, widget.broker.email??"", "email"),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: getDesign(Icons.desktop_mac, "http://www.karmbhoomirealtors.in", "website"),
            ),
            // Flexible(
            //   flex: 1,
            //   fit: FlexFit.tight,
            //   child: getDesign(Icons.location_on, widget.broker.cityID??"", "city"),
            // )
          ],
        ),
      ),
    );
  }

  getDesign(IconData icon, String info, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              print(title.contains("mobile"));
              print(icon);
              if(title.contains("mobile"))
                Essential().call(info);
              else if(title.contains("email"))
                Essential().email(info);
              else if(title.contains("website"))
                Essential().link("http://www.karmbhoomirealtors.in");
            },
            child: Icon(
              icon,
              size: MySize.sizeh5(context),
              color: widget.colorPrimary,
            ),
          ),
        ),
        SizedBox(
          height: MySize.sizeh3(context),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              print(title.contains("mobile"));
              if(title.contains("mobile"))
                Essential().call(info);
              else if(title.contains("email"))
                Essential().email(info);
              else if(title.contains("website"))
                Essential().link("http://www.karmbhoomirealtors.in");
            },
            child: Text(
              info,
            ),
          ),
        )
      ],
    );
  }
}
