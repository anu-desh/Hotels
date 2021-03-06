import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hotels/models/table.dart';

class Tables extends StatefulWidget {
  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  var _tablesRef = FirebaseDatabase.instance
      .reference()
      .child("AllHotels")
      .child("+919535744937")
      .child("HotelInfo")
      .child("Tables");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _tablesRef.onValue,
        builder: (context, snap) {
          List<TableModel> tables = [];
          List<TableModel> ready = [];
          List<TableModel> pending = [];
          List<TableModel> available = [];
          List<TableModel> reserved = [];

          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map values = snap.data.snapshot.value;
            if (values != null) {
              values.forEach((key, value) {
                if (value["Status"] == "Ready")
                  ready.add(TableModel(key, value["Status"]));
                if (value["Status"] == "Pending")
                  pending.add(TableModel(key, value["Status"]));
                if (value["Status"] == "Available")
                  available.add(TableModel(key, value["Status"]));
                if (value["Status"] == "Reserved")
                  reserved.add(TableModel(key, value["Status"]));
              });
            }
            tables = ready + pending + available + reserved;

//            tables.forEach((element) {
//              print(element.tableNo);
//            });
//            print(tables.length);

            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: tables.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return FocusedMenuHolder(
                  onPressed: () {},
                  menuWidth: 120,
                  blurSize: 0,
                  blurBackgroundColor: null,
                  menuItemExtent: 40,
                  menuBoxDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  duration: Duration(milliseconds: 100),
                  animateMenuItems: true,
                  menuItems: [
                    FocusedMenuItem(
                        title: Text("Reserve"),
                        trailingIcon: Icon(Icons.check),
                        onPressed: () => _reserve(tables[index].tableNo)),
                    FocusedMenuItem(
                        title: Text("Free Table"),
                        trailingIcon: Icon(Icons.clear),
                        onPressed: () => _free(tables[index].tableNo)),
                  ],
                  child: card(tables[index]),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  card(TableModel table) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    table.tableNo,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: '\nStatus : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black)),
                      TextSpan(
                          text: table.status,
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    ]),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: table.status == "Ready"
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          )),
                    )
                  : table.status == "Pending"
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.more_horiz,
                            size: 30,
                          ),
                        )
                      : table.status == "Reserved"
                          ? Container(
                              height: 35,
                              width: 60,
                              child: Image.asset("images/reserved_icon.png"))
                          : null,
            ),
          ],
        ),
      ),
    );
  }

  _free(tableNo) {
    _tablesRef.child(tableNo).update({"Status": "Available"});
  }

  _reserve(tableNo) {
    _tablesRef.child(tableNo).update({"Status": "Reserved"});
  }
}
