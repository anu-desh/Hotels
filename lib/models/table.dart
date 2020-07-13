import 'package:flutter/cupertino.dart';

import 'order.dart';

class TableModel with ChangeNotifier {
  final String tableNo;
//  final String orders;
  List<Order> orders;
  final String status;

  TableModel(this.tableNo, this.status);
}
