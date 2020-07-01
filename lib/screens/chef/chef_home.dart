import 'package:flutter/material.dart';

import 'all_food_items.dart';

class ChefHome extends StatefulWidget {
  @override
  _ChefHomeState createState() => _ChefHomeState();
}

class _ChefHomeState extends State<ChefHome> {
  var title = 'Tables';
  int _currentIndex = 0;

  final tabs = [
    Center(child: Text('Tables')),
    AllFoodItems(),
    Center(child: Text('Profile')),
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
            icon: Icon(Icons.fastfood),
            title: Text('Food'),
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
                title = 'Food';
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
