import 'package:demo1/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Tabs/maps.dart' as map;
import './Tabs/buses.dart' as buses;
import './Tabs/profile.dart' as settings;
import 'dart:async';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loginState = prefs.getString('token');
  runApp(MaterialApp(home: loginState == null ? LoginPage() : Tabs()));
}

class Tabs extends StatefulWidget {
  @override
  MyTabState createState() => new MyTabState();
}

class MyTabState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController controller;
  // Future<fetch.Data> post;

  @override
  void initState() {
    super.initState();
    // post = fetch.fetchPost();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              new buses.BusLines(),
              new map.Maps(),
              new settings.Profile(),
            ],
          ),
          bottomNavigationBar: new TabBar(
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.only(
              bottom: 70,
            ),
            indicatorColor: Colors.purple,
            tabs: [
              Container(
                height: 70.0,
                alignment: Alignment(0, -0.5),
                child: new Tab(
                  icon: new Icon(Icons.directions_bus, size: 35,),
                ),
              ),
              Container(
                height: 60.0,
                alignment: Alignment(0, -0.5),
                child: new Tab(
                  icon: new Icon(Icons.map, size: 35,),
                ),
              ),
              Container(
                height: 60.0,
                alignment: Alignment(0, -0.5),
                child: new Tab(
                  icon: new Icon(Icons.account_box, size: 35,),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }
}