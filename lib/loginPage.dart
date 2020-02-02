import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:demo1/main.dart' as main;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  String _error = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
          color: Colors.amber,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        headerSection(),
                        textSection(),
                        buttonSection(),
                        errorSection(),
                        imageSection(),
                      ],
                    ),
                  ),
                )),
    );
  }

  signIn(String email, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ANDROID
    final response = await http
        // .get("http://10.0.2.2:5000/login/$email/$pass");
        //IOS
        .get('http://127.0.0.1:5000/login/$email/$pass');
    if (response.statusCode != 200) {
      setState(() {
        _isLoading = false;
        _error = 'Холболтын алдаа.';
      });
      print('Response body' + response.body);
    }
    if (response.body == 'Username not found') {
      setState(() {
        _isLoading = false;
        _error = 'Имайл буруу байна.';
      });
      print('Response body' + response.body);
    }
    if (response.body == 'Wrong password') {
      setState(() {
        _isLoading = false;
        _error = 'Нууц үг буруу байна.';
      });
      print('Response body' + response.body);
    } if (response.body.toString().substring(0,7) == 'success') {
      print('1: ${response.body.toString().substring(1,7)}');
      print('2: ${response.body.toString().substring(7)}');
      setState(() {
        _isLoading = false;
      });
      sharedPreferences.setString("email", email);
      sharedPreferences.setString("token", 'logged in');
      sharedPreferences.setString("school", response.body.toString().substring(7));
      // sharedPreferences.setString("email", email);
      // sharedPreferences.setString("pass", pass);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => main.Tabs()),
          (Route<dynamic> route) => false);
    }
    else {
      print (response.body.toString().substring(0,7));
    }
  }

  Container errorSection() {
    return Container(
        margin: EdgeInsets.only(top: 0.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Text(
          _error,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
          ),
        ));
  }

  Container imageSection() {
    return Container(
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: new BoxDecoration(
        // boxShadow: [BoxShadow(color: Colors.black)],
        image: DecorationImage(
            image: new AssetImage('assets/images/bus.png'),
            fit: BoxFit.fitHeight),
      ),
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                signIn(emailController.text, passwordController.text);
              },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Нэвтрэх", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    var white70 = Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Нэр Үг",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 25.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Нүүц Үг",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      // margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(
        "SCHOOL BUS",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Impact-400'),
      ),
    );
  }
}
