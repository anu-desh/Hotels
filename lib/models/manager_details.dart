import 'package:firebase_database/firebase_database.dart';

class ManagerDetails {
  final String number;
  final String address;
  final String age;
  final String image;
  final String joined;
  final String name;

  ManagerDetails(
      this.number, this.address, this.age, this.image, this.joined, this.name);
}
