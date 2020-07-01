import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';
import 'Crew.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          profileDetails(),
          ListTile(
            title: Text(
              'Add Chefs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              _showDialog('Add Chef');
            },
          ),
          ListTile(
            title: Text(
              'Add Suppliers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              _showDialog('Add Supplier');
            },
          ),
          ListTile(
            title: Text(
              'Crew',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Crew(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Add Tables',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              _showTableDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget profileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('images/profile.png'),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Manager',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDialog(String title) {
    final TextEditingController textController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (val) =>
                val.isEmpty || val.length < 10 || val.length > 10
                    ? 'Enter valid number'
                    : null,
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: 'Enter the Phone Number', prefixText: '+91'),
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: StadiumBorder(),
            color: Colors.deepPurple,
            child: Text('Add'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Database.addMember(textController.text,
                    title == 'Add Chef' ? "Chefs" : "Suppliers");
                print(textController.text);
                textController.clear();
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  void _showTableDialog() {
    TextEditingController tableController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Table'),
        content: TextField(
          controller: tableController,
          decoration: InputDecoration(hintText: "Enter the table number"),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: StadiumBorder(),
            color: Colors.deepPurple,
            child: Text('Add'),
            onPressed: () {
              Database.addTable(tableController.text);
              tableController.clear();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
