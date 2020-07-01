import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/manager_details.dart';
import 'file:///D:/hotel/hotels/lib/screens/manager/Crew.dart';
import 'package:hotels/services/database.dart';

class ProfilePage extends StatefulWidget {
  final ManagerDetails manager;

  const ProfilePage({Key key, this.manager}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.manager.image),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.manager.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(widget.manager.age),
                Text(widget.manager.address),
                Text(widget.manager.number),
                Divider(
                  thickness: 1.5,
                ),
                Text(
                  "History",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.blue[400],
                      shape: StadiumBorder(),
                      child: Text("Text"),
                      onPressed: () {
                        _textDialog();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.red[400],
                      shape: StadiumBorder(),
                      child: Text("Remove"),
                      onPressed: () {
                        _removeDialog();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _removeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert!'),
        content: Text("Are you sure you want to remove?"),
        actions: <Widget>[
          RaisedButton(
            shape: StadiumBorder(),
            color: Colors.red[400],
            child: Text('Remove'),
            onPressed: () {
              Database.removeManager(widget.manager.number);
              Navigator.of(context).pop();
              print(widget.manager.number);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Crew(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _textDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send a Message'),
        content: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          decoration: InputDecoration(hintText: "Enter the message here!"),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: StadiumBorder(),
            color: Colors.deepPurple,
            child: Text('Send'),
            onPressed: () {
              Database.message(controller.text, widget.manager.number);
              controller.clear();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
