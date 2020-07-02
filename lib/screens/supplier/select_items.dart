import 'package:badges/badges.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/food_item.dart';
import 'package:hotels/models/order.dart';
import 'package:hotels/models/table.dart';
import 'package:hotels/screens/supplier/order_dialog.dart';
import 'package:hotels/screens/supplier/templates.dart';
import 'package:provider/provider.dart';
import 'package:hotels/models/orders_list.dart';

import 'bill_page.dart';

class SelectItems extends StatefulWidget {
  final TableModel table;

  const SelectItems({Key key, this.table}) : super(key: key);

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
        .child(widget.table.tableNo)
        .child("Orders");

    final width = MediaQuery.of(context).size.width;

    final OrderListNotifier orderListNotifier =
        Provider.of<OrderListNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.table.tableNo} Items"),
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
          Consumer<OrderListNotifier>(
            builder: (_, obj, __) {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Selected Items",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: (width / 3) + 10,
                      ),
                      child: (obj.orderList.length == 0)
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text("selected items appear here..."),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: obj.orderList.length,
                              itemBuilder: (context, index) {
                                return Badge(
                                  position:
                                      BadgePosition.topRight(top: 0, right: 0),
                                  padding: EdgeInsets.all(0),
                                  badgeColor: Colors.black,
                                  badgeContent: GestureDetector(
                                    onTap: () {
                                      orderListNotifier
                                          .removeOrder(obj.orderList[index]);
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Badge(
                                    badgeColor: Colors.black87,
                                    position: BadgePosition.bottomRight(
                                        bottom: 10, right: 10),
                                    badgeContent: Text(
                                      obj.orderList[index].quantity.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    child: SizedBox(
                                      height: width / 3,
                                      width: width / 3,
                                      child: Templates.foodCard(
                                          obj.orderList[index].foodItem,
                                          context),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(
            thickness: 2,
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
                return Column(
                  children: <Widget>[
                    Text(
                      "Menu Items",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemCount: foodItems.length + 1,
                        itemBuilder: (context, index) {
                          if (foodItems.length == index)
                            return nextButton();
                          else
                            return foodCard(foodItems[index]);
                        }),
                  ],
                );
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
        content: OrderDialog(foodItem: foodItem),
      ),
    );
  }

  Widget nextButton() {
    return Center(
      child: CircleAvatar(
        radius: 30,
        child: IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BillPage(table: widget.table),
            ));
          },
        ),
      ),
    );
  }
}
