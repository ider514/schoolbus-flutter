import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:demo1/fetch.dart';
import 'dart:async';

Widget getIconForName(here) {
  switch (here) {
    case 'true':
      {
        return Align(
          child: Container(
            width: 32.5,
            height: 55,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/busIcon.png'),
            ),
          ),
        );
      }
      break;
    case 'down':
      {
        return Image.asset(
          'assets/images/downArrow.png',
          height: 55,
        );
      }
      break;
    case 'up':
      {
        return Image.asset(
          'assets/images/upArrow.png',
          height: 55,
        );
      }
      break;
    default:
      {
        return Image.asset(
          'assets/images/busStopIcon.png',
          height: 60,
        );
      }
      break;
  }
}

Widget tile(data, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      SizedBox(
        child: Align(
          child: Text(data.name),
          alignment: Alignment.center,
        ),
        width: MediaQuery.of(context).size.width / 3,
      ),
      SizedBox(
          child: getIconForName(data.here),
          width: MediaQuery.of(context).size.width / 3),
      SizedBox(
          child: Align(
            child: getEta(data.eta),
            alignment: Alignment.center,
          ),
          width: MediaQuery.of(context).size.width / 3)
    ],
  );
}

Widget getEta(eta) {
  switch (eta) {
    case 0:
      {
        return Text('Өнгөрсөн');
      }
      break;
    default:
      {
        return Text('${eta.toString()} мин');
      }
      break;
  }
}

class BottomSheet extends StatefulWidget {
  final String busNumber;
  BottomSheet(this.busNumber);
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  // Timer _everySecond;

  // @override
  // void dispose() {
  //   _everySecond.cancel();
  //   super.dispose();
  // }
  void _timer() {
    Future.delayed(Duration(seconds: 10)).then((_) {
      setState(() {
      });
      _timer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // _timer();
    print('called');
    return SizedBox(
      // 82 + 58 * X
      height: 372,
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Text(
            'Автус № ${this.widget.busNumber.toString()}',
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1)), color: Colors.white),
            child: FutureBuilder(
              future: fetchBusStops(this.widget.busNumber),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return SizedBox(
                    height: snapshot.data.length.toDouble() * 58,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return tile(snapshot.data[index], context);
                      },
                    ),
                  );
                }
              },
            ))
      ]),
    );
  }
}

void modalSheet(context, bus) {
  print('called sheet');
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          child: Container(
            child: BottomSheet(bus),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(13),
                  topRight: const Radius.circular(13),
                )),
          ),
        );
      });
}
