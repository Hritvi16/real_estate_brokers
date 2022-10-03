import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:real_estate_brokers/colors/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../size/MySize.dart';

class ContactList extends StatefulWidget {
  final Color colorPrimary;
  const ContactList({Key? key, required this.colorPrimary}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {

  late SharedPreferences sharedPreferences;
  List<Contact> all = [];
  List<Contact> contacts = [];


  Color colorPrimary = MyColors.grey10;

  bool load = false;


  @override
  void initState() {
    print("widget.contacts.length");
    colorPrimary = widget.colorPrimary;
    start();
    super.initState();
  }

  Future<void> start() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {

    });

    if((sharedPreferences.getString("contacts")??"").isNotEmpty) {
      all = decode(sharedPreferences.getString("contacts")??"");
      contacts = decode(sharedPreferences.getString("contacts")??"");
    }

    load = true;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colorPrimary
        ),
        title: TextFormField(
          onChanged: (value) {
            if(value.isNotEmpty) {
              searchContacts(value);
            }
            else {
              contacts = all;
              setState(() {

              });
            }
          },
          decoration:  InputDecoration(
            labelText: "Search Contact",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                fetchContacts();
              },
              child: const Icon(
                Icons.sync
              ),
            ),
          )
        ],
      ),
      body: load ? Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: contacts.isNotEmpty ? ListView.separated(
          itemCount: contacts.length,
          separatorBuilder: (BuildContext buildContext, int index) {
            return SizedBox(
              height: 10,
              // height: contacts[index].phones.isNotEmpty ? 10 : 0,
            );
          },
          itemBuilder: (BuildContext buildContext, int index) {
            return getContactCard(contacts[index], index);
            // return contacts[index].phones.isNotEmpty ? getContactCard(contacts[index], index) : Container(height: 0,);
          },
        )
            : Center(
          child: Text(
              "No contacts"
          ),
        ),
      ) : Center(
        child: CircularProgressIndicator(
          color: colorPrimary,
        ),
    ),
    );
  }

  Widget getContactCard(Contact contact, int index) {
    return GestureDetector(
      onTap: () async {
        print(contact.id??"");
        final fullContact =
            await FlutterContacts.getContact(contact.id??"");

        print(fullContact?.toJson());
        Navigator.pop(context, fullContact);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: MySize.size5(context)),
        decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyColors.grey10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 1.0,
              ),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(contact.displayName),
            SizedBox(
              height: 10,
            ),
            // getInfo(contact.phones.first.number),
          ],
        ),
      ),
    );
  }


  getTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
          fontWeight: FontWeight.w600
      ),
    );
  }

  getInfo(String desc) {
    return Text(
      desc,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  void searchContacts(String value) {
    contacts = [];
    for (var element in all) {
      if(element.displayName.toLowerCase().contains(value.toLowerCase())) {
        contacts.add(element);
      }
    }

    setState(() {

    });
  }

  fetchContacts() async {
    load = false;
    setState(() {

    });
    if (await FlutterContacts.requestPermission()) {
      all = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: false
      );
    }
    contacts = [];
    contacts.addAll(all);
    load = true;
    setState(() {

    });
    sharedPreferences.setString("contacts", encode(contacts));
  }

  static String encode(List<Contact> contacts) => json.encode(
    contacts
        .map<Map<String, dynamic>>((contact) => contact.toJson())
        .toList(),
  );

  static List<Contact> decode(String contacts) =>
      (json.decode(contacts) as List<dynamic>)
          .map<Contact>((item) => Contact.fromJson(item))
          .toList();
}
