import 'package:flutter/material.dart';
import 'package:hotels/models/food_item.dart';

class Templates {
  static Widget foodCard(FoodItem foodItem, BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 18,
                ),
                CircleAvatar(
                  backgroundColor: Colors.black87,
                  radius: (MediaQuery.of(context).size.width / 16) + 2,
                  child: ClipOval(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width / 8,
                      width: MediaQuery.of(context).size.width / 8,
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
                Text(
                  foodItem.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Rs ${foodItem.price}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(foodItem.avail),
              ],
            ),
          ),
        ),
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
}
