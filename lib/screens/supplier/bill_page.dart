import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotels/models/orders_list.dart';
import 'package:hotels/models/table.dart';
import 'package:hotels/screens/supplier/select_items.dart';
import 'package:hotels/screens/supplier/supplier_home.dart';
import 'package:hotels/services/database.dart';
import 'package:provider/provider.dart';

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
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Consumer<OrderListNotifier>(
            builder: (_, obj, __) {
              int billTotal = 0;
              double tax = 0;
              int finalBill = 0;
              List<TableRow> rows = [];
              rows.add(
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Food Item",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        "Quantity",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                      child: Text(
                        "Item Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                  ],
                ),
              );
              obj.orderList.forEach((element) {
                int itemTotal =
                    int.parse(element.foodItem.price) * element.quantity;
                billTotal += itemTotal;
                rows.add(
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(element.foodItem.name),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 30,
                            ),
                            Text(element.quantity.toString()),
                          ],
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Text("Rs $itemTotal"),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                    ],
                  ),
                );
              });
              tax = (billTotal * 18) / 100;
              finalBill = (billTotal + tax).toInt();
              rows.add(
                TableRow(
                  children: [
                    TableCell(
                      child: Container(),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Tax( 18% )",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Rs $tax",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
              rows.add(
                TableRow(
                  children: [
                    TableCell(
                      child: Container(),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Bill Total",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Rs $billTotal",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
              rows.add(
                TableRow(
                  children: [
                    TableCell(
                      child: Container(),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Final Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Rs $finalBill",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Table(
                  children: rows,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectItems(
                table: widget.table,
              ),
            ),
          );
        },
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(35), topLeft: Radius.circular(35)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(-3, -3),
              )
            ]),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.clear),
                  Text("Cancel"),
                ],
              ),
              onPressed: () {
                Provider.of<OrderListNotifier>(context, listen: false)
                    .orderList
                    .clear();
                Database.freeTable(widget.table.tableNo);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SupplierHome(),
                  ),
                );
              },
            ),
            FlatButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.check),
                  Text("Finish"),
                ],
              ),
              onPressed: () {
                Database.freeTable(widget.table.tableNo);
              },
            )
          ],
        ),
      ),
    );
  }
}
