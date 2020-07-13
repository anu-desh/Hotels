import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hotels/models/food_item.dart';
import 'package:hotels/models/order.dart';
import 'package:path/path.dart' as Path;

class Database {
//  static Future<String> createItem() async {
//    DatabaseReference reference = FirebaseDatabase.instance
//        .reference()
//        .child("AllHotels")
//        .child("ManagerPhone")
//        .child("Hotel Info")
//        .push();
//    reference.set('');
//    return reference.key;
//  }
//
//  static Future<void> saveItem(dynamic key, String name) async {
//    return FirebaseDatabase.instance
//        .reference()
//        .child("AllHotels")
//        .child("ManagerPhone")
//        .child("Hotel Info")
//        .child(key)
//        .set(name);
//  }

  static Future<void> addMember(String num, String role) {
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("Staff")
        .child(role)
        .child(num)
        .set('nil');
  }

  static Future<void> addTable(String table) {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("HotelInfo")
        .child("Tables")
        .child('Table $table');

    reference.child('Orders').set('nil');
    reference.child('Status').set('Available');
  }

  static Future<void> managerDetails() {
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("Staff")
        .child("Managers")
        .child("+919535744937")
        .child("Profile")
        .set({
      "Address": "Address",
      "Age": "Age",
      "Image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSLHvzyqlpe7Aw_qH5ZR5fvjErwjzNuqIlc6A&usqp=CAU",
      "Joined": "Date and Time",
      "Name": "Name"
    });
  }

  static Future<void> removeManager(String num) {
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("Staff")
        .child("Managers")
        .child(num)
        .remove();
  }

  static Future<void> message(String msg, String num) {
    print(DateTime.now().toString());
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("Staff")
        .child("Managers")
        .child(num)
        .child("Notifications")
        .push()
        .set({DateTime.now().millisecondsSinceEpoch.toString(): msg});
  }

  static Future<void> addFood(
      String name, String category, String price, String image) {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("HotelInfo")
        .child("Items")
        .child(category)
        .child(name);

    reference.child('Price').set(price);
    reference.child('Avail').set('Available');
    reference.child('Image').set(image);
  }

  static Future<void> removeFood(FoodItem foodItem) {
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("HotelInfo")
        .child("Items")
        .child(foodItem.category)
        .child(foodItem.name)
        .remove();
  }

  static Future<Widget> search(String phone) {
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child(phone) //manager number
//        .child("Staff")
//        .child("Chefs") //role
//        .child("2589631470") //chef number
        .once()
        .then((DataSnapshot data) {
      if (data.value == null)
        return Container();
      else {
        return Container(
          child: Text("hello"),
        );
      }
    });
  }

  static Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }

  static Future<void> addOrder(String tableNo, Order order) {
    print(tableNo);
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("HotelInfo")
        .child("Tables")
        .child(tableNo)
        .child("Orders")
        .child(order.foodItem.name.toString())
        .set({
      "Quantity": order.quantity,
      "Message": order.message,
    });
  }

  static Future<void> freeTable(String tableNo) {
    return FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("HotelInfo")
        .child("Tables")
        .child(tableNo)
        .update({"status": "Available"});
  }
}
