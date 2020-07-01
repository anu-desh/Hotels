import 'package:flutter/material.dart';
import 'package:hotels/screens/manager/profile.dart';
import 'package:hotels/screens/manager/tables.dart';

class ManagerHome extends StatefulWidget {
  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  var title = 'Tables';
  int _currentIndex = 0;

  final tabs = [
    Tables(),
    Center(child: Text('Notifications')),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 25,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('Tables'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              setState(() {
                title = 'Tables';
              });
              break;
            case 1:
              setState(() {
                title = 'Notifications';
              });
              break;
            case 2:
              setState(() {
                title = 'Profile';
              });
              break;
          }
        },
      ),
    );
  }
}
