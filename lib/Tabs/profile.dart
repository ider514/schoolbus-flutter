import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:demo1/fetch.dart';
import 'package:demo1/loginPage.dart' as login;
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void callback() {
    setState(() {});
  }

  LogDialog logDialog;
  Widget currentPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(children: <Widget>[
            logOutButton(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logWindow(context),
                spacer(context),
                logButton(),
              ],
            ),
          ])),
    );
  }

  Widget spacer(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
    );
  }

  ioColor(data) {
    if (data.toString().substring(0, 1) == 'O') {
      return Colors.red;
    }
    if (data.toString().substring(0, 1) == 'I') {
      return Colors.green;
    }
  }

  logWindow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      // color: Colors.black,
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width - 33,
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.only(top: 15, left: 20),
              height: 40,
              child: Text(
                'Бүртгэл:',
                style: TextStyle(
                  fontSize: 22,
                ),
              )),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 3 - 42,
          child: FutureBuilder(
            future: fetchLog(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemExtent: 60,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            snapshot.data[index].toString().substring(2, 21),
                            style: TextStyle(
                                fontSize: 20,
                                color: ioColor(snapshot.data[index])),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

  Widget logOutButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 50.0),
        child: RaisedButton(
          onPressed: logOut,
          elevation: 10.0,
          color: Colors.purple,
          child: Text("Гарах", style: TextStyle(color: Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  Container logButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 60.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return LogDialog(this.callback);
              });
        },
        elevation: 3.0,
        color: Colors.amber,
        child: Text("Бүртгэх",
            style: TextStyle(color: Colors.white, fontSize: 25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", null);
    print('logged out');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => login.LoginPage()),
        (Route<dynamic> route) => false);
  }
}

class LogDialog extends StatefulWidget {
  final Function callback;
  LogDialog(this.callback);

  @override
  _LogDialogState createState() => _LogDialogState();
}

class _LogDialogState extends State<LogDialog> {
  final myController = TextEditingController();
  double fontSize = 0;
  String responseText = '';
  Color responseColor = Colors.black;

  verify(id, context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var school = sharedPreferences.getString('school');
    var email = sharedPreferences.getString('email');

    // ANDROID
    final response = await http
        // .post("http://10.0.2.2:5000/login?username=$email&password=$pass");
        //IOS
        .post(
            "http://127.0.0.1:5000/verify?school=$school&id=$id&email=$email");
    switch (response.body) {
      case 'logged':
        {
          setState(() {
            responseText = 'Амжилттай!';
            responseColor = Colors.green;
          });
          new Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
            this.widget.callback();
          });
        }
        break;
      case 'logged twice':
        {
          setState(() {
            responseText = 'Буусан байна.';
            responseColor = Colors.black;
          });
          new Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
            this.widget.callback();
          });
        }
        break;
      case 'wrong id':
        {
          setState(() {
            responseText = 'Буруу дугаар!';
            responseColor = Colors.red;
          });
          print('failed to log');
        }
        break;
      default:
        {
          setState(() {
            responseText = 'Алдаа гарсан байна.';
            responseColor = Colors.red;
          });
          print('connection failed');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Дугаар',
      ),
      content: SizedBox(
        height: 114,
        child: Column(children: <Widget>[
          TextField(
            controller: myController,
          ),
          FlatButton(
            onPressed: () {
              verify(myController.text, context);
            },
            child: Text('Бүртгэх'),
          ),
          Text(
            responseText,
            style: TextStyle(color: responseColor, fontSize: 15),
          )
        ]),
      ),
    );
  }
}
