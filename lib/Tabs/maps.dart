import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:demo1/fetch.dart' as fetch;

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin {
  BitmapDescriptor busLocationIcon;
  BitmapDescriptor stopLocationIcon;

  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    busLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 8),
        'assets/images/mapBusIcon.png');
    stopLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 8),
        'assets/images/busStopMapIcon.png');
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    //  _timer();
    return new Container(
      child: new Scaffold(
        body: new GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(49.025930, 104.045969),
            zoom: 15.0,
          ),
          markers: _markers,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins(controller);
    // setPolylines();
  }

  Future<void> setMapPins(GoogleMapController controller) async {
    final buses = await fetch.fetchBuses();
    final stops = await fetch.fetchBusStops(481);
    if (!mounted) return;
    setState(() {
      for (final b in buses) {
        print(b.licensenumber);
        _markers.add(Marker(
            markerId: MarkerId(b.licensenumber),
            position: LatLng(b.latitude, b.longitude),
            icon: busLocationIcon));
      }
      for (final s in stops) {
        print(s.name);
        _markers.add(Marker(
            markerId: MarkerId(s.name),
            position: LatLng(s.lat, s.lon),
            icon: stopLocationIcon));
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
