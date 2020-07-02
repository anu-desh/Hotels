import 'package:flutter/cupertino.dart';
import 'package:hotels/models/order.dart';

class OrderListNotifier with ChangeNotifier {
  final List<Order> orderList = [];

  void addOrder(Order order) {
    var existing = orderList.firstWhere(
        (element) => element.foodItem.name == order.foodItem.name,
        orElse: () => null);
    if (existing != null) {
      existing.quantity += order.quantity;
      if (existing.message == "") existing.message = order.message;
    } else
      orderList.add(order);
    notifyListeners();
  }

  void removeOrder(Order order) {
    orderList
        .removeWhere((element) => element.foodItem.name == order.foodItem.name);
    notifyListeners();
  }
}
