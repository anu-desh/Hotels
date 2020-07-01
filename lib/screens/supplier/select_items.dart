import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/food_item.dart';
import 'package:hotels/models/order.dart';
import 'package:hotels/screens/supplier/order_dialog.dart';
import 'package:hotels/screens/supplier/templates.dart';

class SelectItems extends StatefulWidget {
  final String tableNo;

  const SelectItems({Key key, this.tableNo}) : super(key: key);

  @override
  _SelectItemsState createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  var _itemsRef = FirebaseDatabase.instance
      .reference()
      .child("AllHotels")
      .child("+919535744937")
      .child("HotelInfo")
      .child("Items");

  @override
  Widget build(BuildContext context) {
    var _ordersRef = FirebaseDatabase.instance
        .reference()
        .child("AllHotels")
        .child("+919535744937")
        .child("HotelInfo")
        .child("Tables")
        .child(widget.tableNo)
        .child("Orders");

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.tableNo} Items"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
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
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          StreamBuilder(
            stream: _ordersRef.onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                List<Order> orders = [];

                Map values = snap.data.snapshot.value;
                if (values != null) {
                  values.forEach((key, value) {
                    var category = key;
                    Map items = value;
                    items.forEach((key, item) {
                      orders.add(Order(key, item['Quantity'], item['Message']));
                    });
                  });
                }
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Container(
                          height: width / 3,
                          width: width / 3,
                          child: foodCard(orders[index].foodItem));
                    });
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
          StreamBuilder(
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
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      return foodCard(foodItems[index]);
                    });
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ],
      ),
    );
  }

  Widget foodCard(FoodItem foodItem) {
    return GestureDetector(
        onTap: () {
          setState(() {
            showOrderDialog(foodItem);
          });
        },
        child: Templates.foodCard(foodItem, context));
  }

  void showOrderDialog(FoodItem foodItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: OrderDialog(tableNo: widget.tableNo, foodItem: foodItem),
      ),
    );
  }
}
