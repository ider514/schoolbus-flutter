import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Bus {
  final String phone;
  final String licensenumber;
  // final int _id;
  final int id;
  final double altitude;
  final double calculatedSpeed;
  final double groundSpeed;
  final double heading;
  final double latitude;
  final double longitude;
  Bus(
    this.phone,
    this.licensenumber,
    
    // this._id,
    this.id,
    this.altitude,
    this.calculatedSpeed,
    this.groundSpeed,
    this.heading,
    this.latitude,
    this.longitude,
  );
}

Future<List<Bus>> fetchBuses() async {
  SharedPreferences school = await SharedPreferences.getInstance();
  var userSchool = school.getString("school");
  final response =
      // Android
      // await http.get('http://10.0.2.2:5000/buses/$userSchool');
      //IOS
      await http.get('http://127.0.0.1:5000/buses/$userSchool');
  List<Bus> buses = [];
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    for (var b in jsonResponse) {
      Bus bus = Bus(
        b['phone'],
        b['licensenumber'],
        // b['_id'],
        b['id'],
        b['altitude'],
        b['calculatedSpeed'],
        b['groundSpeed'],
        b['heading'],
        b['latitude'],
        b['longitude'],
      );
      buses.add(bus);
    }
    print('Number of buses: ' + buses.length.toString());
    return buses;
  } else
    print('Response body' + response.body);
  return buses;
}

// Separator

class Stops {
  final String name;
  final double lat;
  final double lon;
  final String here;
  final int eta;
  Stops(
    this.lat,
    this.lon,
    this.name,
    this.here,
    this.eta,
  );
}

Future<List<Stops>> fetchBusStops(busNumber) async {
  SharedPreferences school = await SharedPreferences.getInstance();
  var userSchool = school.getString("school");
  final response =
      // Android
      // await http.post('http://10.0.2.2:5000/busStops?school=$userSchool&bus=$busNumber');
      //IOS
      await http.get(
          'http://127.0.0.1:5000/busStops/${school}/${busNumber}');
  List<Stops> stopss = [];
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    for (var s in jsonResponse) {
      Stops stops = Stops(s['lat'], s['lon'], s['name'], s['here'], s['eta']);
      stopss.add(stops);
    }
    return stopss;
  } else
    print('Response body' + response.body);
  return stopss;
}

class Log {
  final String log;
  Log(
    this.log,
  );
}

Future<List<String>> fetchLog() async {
  SharedPreferences school = await SharedPreferences.getInstance();
  var email = school.getString("email");
  final response =
      // Android
      // await http.get('http://10.0.2.2:5000/log/$email');
      //IOS
      await http.get('http://127.0.0.1:5000/log/$email');
  List<String> logs = [];
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    for (var s in jsonResponse) {
      logs.add(s);
    }
    return logs;
  } else {
    print('Response body' + response.body);
    return logs;
  }
}
