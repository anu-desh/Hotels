import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/food_item.dart';
import 'package:hotels/models/order.dart';
import 'package:hotels/models/orders_list.dart';
import 'package:hotels/screens/supplier/select_items.dart';
import 'package:hotels/screens/supplier/templates.dart';
import 'package:hotels/services/database.dart';
import 'package:provider/provider.dart';

class OrderDialog extends StatefulWidget {
  final FoodItem foodItem;

  const OrderDialog({
    Key key,
    this.foodItem,
  }) : super(key: key);
  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  int quantity = 0;
  bool showField = false;
  TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final OrderListNotifier orderListNotifier =
        Provider.of<OrderListNotifier>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    quantity--;
                  });
                }),
            SizedBox(
              height: 150,
              width: 150,
              child: Templates.foodCard(widget.foodItem, context),
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                })
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            quantity.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 30,
          child: Divider(
            thickness: 2,
            color: Colors.black54,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.speaker_notes,
              color: showField ? Colors.deepPurple : null,
            ),
            onPressed: () {
              setState(() {
                showField = !showField;
              });
            },
          ),
        ),
        showField
            ? TextField(
                controller: msgController,
                decoration: InputDecoration(hintText: "Special instructions!!"),
                textCapitalization: TextCapitalization.sentences,
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
            color: Colors.deepPurple[400],
            shape: StadiumBorder(),
            child: Text("Done"),
            onPressed: () {
              if (quantity > 0) {
                orderListNotifier.addOrder(
                    Order(widget.foodItem, quantity, msgController.text));
                Navigator.of(context).pop();
              }
            },
          ),
        )
      ],
    );
  }
}
