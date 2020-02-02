import 'package:demo1/fetch.dart';
import 'package:flutter/material.dart';
import 'package:demo1/modalSheet.dart' as modalSheet;

class BusLines extends StatefulWidget {
  @override
  _BusLinesState createState() => _BusLinesState();
}

infoWindow(BuildContext context, data) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            data.licensenumber.toString(),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: Text('Утас'),
                        alignment: Alignment.centerRight,
                      ),
                      Align(
                        child: Text('Id'),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(" : "),
                    Text(" : "),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Align(
                      child: Text(
                        data.phone.toString(),
                        textAlign: TextAlign.left,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Align(
                      child: Text(
                        data.id.toString(),
                        textAlign: TextAlign.left,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class _BusLinesState extends State<BusLines>
    with AutomaticKeepAliveClientMixin {     

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:
          // Column(children: <Widget>[
          //   Expanded(
          //     flex: 1,
          //     child: Container(child: Text('Hello')),
          //   ),
          //   Expanded(
          //     flex: 10,
          //     child: Container(
          //       child:
          FutureBuilder(
        future: fetchBuses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(child: Center(child: CircularProgressIndicator()));
          } else {
            return ListView.builder(
              itemExtent: 60,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                print('Bus id: ' + snapshot.data[index].id.toString());
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.directions_bus,
                      size: 50,
                    ),
                    title: FlatButton(
                      child: Text(
                        snapshot.data[index].licensenumber.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: (){
                        // modalSheet.BottomSheet(snapshot.data[index].id.toString());
                        modalSheet.modalSheet(context, snapshot.data[index].id.toString());
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        size: 35,
                      ),
                      onPressed: () =>
                          infoWindow(context, snapshot.data[index]),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      //     ),
      //   ),
      // ]
      // )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
