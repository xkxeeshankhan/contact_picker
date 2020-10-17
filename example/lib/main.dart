import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MainWidget(),
      );
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  PhoneContact _phoneContact;
  EmailContact _emailContact;
  String _contact;
  Image _contactPhoto;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            if (_emailContact != null)
              Column(
                children: <Widget>[
                  const Text("Email contact:"),
                  Text("Name: ${_emailContact.fullName}"),
                  Text(
                      "Email: ${_emailContact.email.email} (${_emailContact.email.label})")
                ],
              ),
            if (_phoneContact != null)
              Column(
                children: <Widget>[
                  const Text("Phone contact:"),
                  Text("Name: ${_phoneContact.fullName}"),
                  Text(
                      "Phone: ${_phoneContact.phoneNumber.number} (${_phoneContact.phoneNumber.label})")
                ],
              ),
            if(_contactPhoto != null) _contactPhoto,
            if (_contact != null) Text(_contact),
            RaisedButton(
              child: const Text("pick phone contact"),
              onPressed: () async {
                final PhoneContact contact =
                    await FlutterContactPicker.pickPhoneContact();
                print(contact);
                setState(() {
                  _phoneContact = contact;
                });
              },
            ),
            RaisedButton(
              child: const Text("pick email contact"),
              onPressed: () async {
                final EmailContact contact =
                    await FlutterContactPicker.pickEmailContact();
                print(contact);
                setState(() {
                  _emailContact = contact;
                });
              },
            ),
            RaisedButton(
              child: const Text("pick full contact"),
              onPressed: () async {
                final FullContact contact =
                    (await FlutterContactPicker.pickFullContact());
                setState(() {
                  _contact = contact.toString();
                  _contactPhoto = contact.photo?.asWidget();
                });
              },
            ),
            RaisedButton(
              child: const Text('Check permission'),
              onPressed: () async {
                final granted = await FlutterContactPicker.hasPermission();
                showDialog(
                    context: context,
                    child: AlertDialog(
                        title: const Text('Granted: '),
                        content: Text('$granted')));
              },
            ),
            RaisedButton(
              child: const Text('Request permission'),
              onPressed: () async {
                final granted = await FlutterContactPicker.requestPermission();
                showDialog(
                    context: context,
                    child: AlertDialog(
                        title: const Text('Granted: '),
                        content: Text('$granted')));
              },
            ),
          ],
        ),
      );
}
