import 'package:flutter/material.dart';
import 'package:hotels/screens/supplier/supply_tables.dart';

class SupplierHome extends StatefulWidget {
  @override
  _SupplierHomeState createState() => _SupplierHomeState();
}

class _SupplierHomeState extends State<SupplierHome> {
  var title = 'Tables';
  int _currentIndex = 0;

  final tabs = [
    SupplyTables(),
    Center(child: Text('Profile')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
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
                title = 'Profile';
              });
              break;
          }
        },
      ),
    );
  }
}
