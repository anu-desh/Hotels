import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hotels/screens/chef/add_food_item.dart';
import 'package:hotels/models/food_item.dart';
import 'package:hotels/services/database.dart';

class AllFoodItems extends StatefulWidget {
  @override
  _FoodItemsState createState() => _FoodItemsState();
}

class _FoodItemsState extends State<AllFoodItems> {
  var _itemsRef = FirebaseDatabase.instance
      .reference()
      .child("AllHotels")
      .child("+919535744937")
      .child("HotelInfo")
      .child("Items");

  List options = ["Remove", "Update"];
  var selectedAction;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _itemsRef.onValue,
      builder: (context, snap) {
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          List<FoodItem> foodItems = [];
//          print(snap.data.snapshot.value);

          Map values = snap.data.snapshot.value;
          if (values != null) {
            values.forEach((key, value) {
              var category = key;
              Map items = value;
              items.forEach((key, item) {
                foodItems.add(FoodItem(key, category, item['Avail'],
                    item['Price'], item['Image']));
              });
            });
          }
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: foodItems.length + 1,
              itemBuilder: (context, index) {
//                print(index);
                if (index == foodItems.length)
                  return addItemCard();
                else
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
                            title: foodItems[index].avail == 'Available'
                                ? Text("Not Available")
                                : Text("Available"),
                            onPressed: () {
                              _changeStatus(foodItems[index]);
                            }),
                      ],
                      child: foodCard(foodItems[index]));
              });
        } else
          return GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children: <Widget>[addItemCard()],
          );
      },
    );
  }

  Widget foodCard(FoodItem foodItem) {
    return Stack(
      children: <Widget>[
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 63,
                child: ClipOval(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: foodItem.image == null
                        ? Image.asset(
                            'images/food.png',
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            foodItem.image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Align(alignment: Alignment.topLeft, child: Container()),
              Text('Name : ${foodItem.name}'),
              Text('price : Rs ${foodItem.price}'),
              Text('Availability : ${foodItem.avail}'),
            ],
          ),
        ),
        Align(alignment: Alignment.topRight, child: popUpOptions(foodItem)),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Text(foodItem.category),
          ),
        ),
      ],
    );
  }

  addItemCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: IconButton(
        icon: Icon(
          Icons.add_circle,
          color: Colors.black54,
          size: 50,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddFoodItem()));
        },
      ),
    );
  }

  void _changeStatus(FoodItem foodItem) {
    if (foodItem.avail == 'Not Available')
      _itemsRef
          .child(foodItem.category)
          .child(foodItem.name)
          .update({"Avail": 'Available'});
    else
      _itemsRef
          .child(foodItem.category)
          .child(foodItem.name)
          .update({"Avail": 'Not Available'});
  }

  popUpOptions(FoodItem foodItem) {
    return PopupMenuButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Icon(Icons.more_vert),
      ),
      itemBuilder: (context) {
        return options.map((element) {
          return PopupMenuItem(
            value: element,
            child: Text(element),
          );
        }).toList();
      },
      onSelected: (value) {
        if (value == 'Remove')
          _removeFood(foodItem);
        else
          _updateFood(foodItem);
      },
    );
  }

  void _removeFood(FoodItem foodItem) {
    Database.deleteImage(foodItem.image);
    Database.removeFood(foodItem);
  }

  _updateFood(FoodItem foodItem) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddFoodItem(foodItem: foodItem)));
  }
}
