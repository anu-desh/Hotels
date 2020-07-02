import 'package:hotels/models/food_item.dart';

class Order {
  final FoodItem foodItem;
  int quantity;
  String message;

  Order(this.foodItem, this.quantity, this.message);
}
