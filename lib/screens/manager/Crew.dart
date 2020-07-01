import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/manager_details.dart';
import 'file:///D:/hotel/hotels/lib/screens/manager/profile_page.dart';
import 'package:hotels/services/database.dart';

class Crew extends StatefulWidget {
  @override
  _CrewState createState() => _CrewState();
}

class _CrewState extends State<Crew> {
  @override
  Widget build(BuildContext context) {
//    Database.managerDetails();
    return Scaffold(
      appBar: AppBar(
        title: Text("Crew"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          panel("Managers"),
          SizedBox(
            height: 20,
          ),
          panel("Suppliers"),
          SizedBox(
            height: 20,
          ),
          panel("Chefs"),
        ],
      ),
    );
  }

  list() {
    DatabaseReference profileRef = FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("Staff")
        .child("Managers");
//        .child("+919535744937")
//        .child("Profile");

    List<ManagerDetails> managers = [];

    return StreamBuilder(
      stream: profileRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (managers.length != null) managers.clear();
          Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
          if (values != null) {
            values.forEach((key, value) {
              managers.add(ManagerDetails(
                key,
                value["Profile"]["Address"],
                value["Profile"]["Age"],
                value["Profile"]["Image"],
                value["Profile"]["Joined"],
                value["Profile"]["Name"],
              ));
            });
          }
          return ListView.builder(
            itemCount: managers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(managers[index].image),
                ),
                title: Text("Manager ${index + 1}"),
                subtitle: Text(managers[index].name),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(manager: managers[index]),
                    ),
                  );
                },
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  panel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ExpandablePanel(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        expanded: list(),
      ),
    );
  }
}
