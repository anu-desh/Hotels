import 'package:hotels/models/food_item.dart';

class Order {
  final FoodItem foodItem;
  final int quantity;
  final String message;

  Order(this.foodItem, this.quantity, this.message);
}
