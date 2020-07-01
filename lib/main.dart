import 'package:flutter/material.dart';
import 'package:hotels/screens/supplier/supplier_home.dart';
import 'package:provider/provider.dart';
import 'screens/manager/manager_home.dart';
import 'screens/chef/chef_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SupplierHome(),
    );
  }
}