import 'package:flutter/material.dart';
import 'package:hotels/models/table.dart';

class BillPage extends StatefulWidget {
  final TableModel table;

  const BillPage({Key key, this.table}) : super(key: key);
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.table.tableNo.toString()} Bill Details"),
      ),
      body: Container(),
    );
  }
}
