import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paloma365/data/order_repository.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/model/section_model.dart';
import 'package:paloma365/model/table_model.dart';
import 'package:paloma365/pages/checkout_page.dart';
import 'package:paloma365/widget/table_item_widget.dart';

import '../data/table_repository.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class SectionTablesPage extends StatefulWidget {
  const SectionTablesPage({super.key, required this.section});

  final SectionModel section;

  @override
  State<SectionTablesPage> createState() => _SectionTablesPageState();
}

class _SectionTablesPageState extends State<SectionTablesPage> {
  bool loading = true;
  List<TableModel> tables = [];
  Map<int, OrderModel> tableOrders = {};

  Future<void> fetchOrders() async {
    final orders =
        await OrderRepository.instance.getOrdersBySection(widget.section.id, [
      OrderStatus.NEW,
      OrderStatus.TO_BE_DELIVER,
      OrderStatus.DELIVERED,
    ]);
    for (final order in orders) {
      if (order.tableId != null) {
        tableOrders[order.tableId!] = order;
      }
    }
  }

  Future<void> fetchTables() async {
    setState(() {
      loading = true;
    });
    tables = await TableRepository.instance.fetchTablesFor(widget.section.id);
    await fetchOrders();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    fetchTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          widget.section.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: loading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : GridView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              children: [
                for (TableModel table in tables) ...{
                  TableItemWidget(
                    model: table,
                    orderModel: tableOrders[table.id],
                    onTap: () async {
                      await showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CheckoutPage(model: table),
                      );
                      fetchTables();
                    },
                  ),
                }
              ],
            ),
    );
  }
}
