import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/data/order_repository.dart';
import 'package:paloma365/data/product_repository.dart';
import 'package:paloma365/data/section_repository.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/model/product_model.dart';
import 'package:paloma365/model/section_model.dart';
import 'package:paloma365/model/table_model.dart';
import 'package:paloma365/pages/checkout_page.dart';
import 'package:paloma365/widget/order_list_widget.dart';

import '../data/table_repository.dart';
import 'order_details_page.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool loading = true;
  List<OrderModel> newOrders = [];
  Map<int, SectionModel> sections = {};
  Map<int, TableModel> tables = {};
  Map<int, ProductModel> products = {};
  List<OrderModel> toBeDeliverOrders = [];
  List<OrderModel> deliveredOrders = [];

  Future<void> fetchBasicData() async {
    setState(() {
      loading = true;
    });
    final sectionList = await SectionRepository.instance.fetchSections();
    setState(() {
      sections = Map.fromEntries(sectionList.map((e) => MapEntry(e.id, e)));
    });
    for (final SectionModel section in sectionList) {
      final tableList =
          await TableRepository.instance.fetchTablesFor(section.id);
      setState(() {
        tables.addAll(Map.fromEntries(tableList.map((e) => MapEntry(e.id, e))));
      });
    }
    final productList = await ProductRepository.instance.fetchProducts();
    for (final ProductModel product in productList) {
      products[product.id] = product;
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> fetchOrders([bool withLoading = false]) async {
    if (withLoading) {
      setState(() {
        loading = true;
      });
    }
    newOrders =
        await OrderRepository.instance.getOrdersByStatus(OrderStatus.NEW);
    toBeDeliverOrders = await OrderRepository.instance
        .getOrdersByStatus(OrderStatus.TO_BE_DELIVER);
    deliveredOrders =
        await OrderRepository.instance.getOrdersByStatus(OrderStatus.DELIVERED);
    for (final order in [
      ...newOrders,
      ...toBeDeliverOrders,
      ...deliveredOrders
    ]) {
      order.table = tables[order.tableId!];
      order.section = sections[order.table!.sectionId];
      for (final item in order.items ?? []) {
        item.product = products[item.productId!];
      }
    }
    setState(() {
      loading = false;
    });
  }

  fetchData() async {
    await fetchBasicData();
    await fetchOrders(true);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  showActionsForOrder(OrderModel model) {
    HapticFeedback.heavyImpact();
    if (model.status == OrderStatus.NEW) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                "Ready for Deliver",
              ),
              onPressed: () async {
                if (mounted) {
                  Navigator.pop(context);
                }
                await OrderRepository.instance
                    .updateOrderStatus(model.id!, OrderStatus.TO_BE_DELIVER);
                fetchOrders();
              },
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                "Cancel the order",
              ),
              onPressed: () async {
                if (mounted) {
                  Navigator.pop(context);
                }
                await OrderRepository.instance
                    .updateOrderStatus(model.id!, OrderStatus.CANCELLED);
                fetchOrders();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("Edit"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CheckoutPage(
                      model: model.table!,
                    ),
                  ),
                ).whenComplete(
                  () {
                    fetchOrders();
                  },
                );
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ),
      );
    } else if (model.status == OrderStatus.TO_BE_DELIVER) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                "Marks as Delivered",
              ),
              onPressed: () async {
                if (mounted) {
                  Navigator.pop(context);
                }
                await OrderRepository.instance
                    .updateOrderStatus(model.id!, OrderStatus.DELIVERED);
                fetchOrders();
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                "Order details",
              ),
              onPressed: () async {
                HapticFeedback.mediumImpact();
                if (mounted) {
                  Navigator.pop(context);
                }
                await showCupertinoModalPopup(
                  context: context,
                  builder: (context) => OrderDetailsPage(
                    model: model,
                  ),
                );
                fetchOrders();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ),
      );
    } else if (model.status == OrderStatus.DELIVERED) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: true,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                "Order details",
              ),
              onPressed: () async {
                HapticFeedback.mediumImpact();
                if (mounted) {
                  Navigator.pop(context);
                }
                await showCupertinoModalPopup(
                  context: context,
                  builder: (context) => OrderDetailsPage(
                    model: model,
                  ),
                );
                fetchOrders();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: loading
          ? const Center(child: CupertinoActivityIndicator())
          : DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.indigoAccent,
                    labelColor: Colors.indigoAccent,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Tab(
                        text: "New (${newOrders.length})",
                      ),
                      Tab(
                        text: "To be deliver (${toBeDeliverOrders.length})",
                      ),
                      Tab(
                        text: "Delivered (${deliveredOrders.length})",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          slivers: [
                            //cupertino refresh
                            CupertinoSliverRefreshControl(
                              onRefresh: () async {
                                await fetchOrders();
                              },
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => OrderListWidget(
                                  model: newOrders[index],
                                  onTap: () {
                                    showActionsForOrder(newOrders[index]);
                                  },
                                ),
                                childCount: newOrders.length,
                              ),
                            ),
                          ],
                        ),
                        CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          slivers: [
                            //cupertino refresh
                            CupertinoSliverRefreshControl(
                              onRefresh: () async {
                                await fetchOrders();
                              },
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => OrderListWidget(
                                  model: toBeDeliverOrders[index],
                                  onTap: () {
                                    showActionsForOrder(
                                        toBeDeliverOrders[index]);
                                  },
                                ),
                                childCount: toBeDeliverOrders.length,
                              ),
                            ),
                          ],
                        ),
                        CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          slivers: [
                            //cupertino refresh
                            CupertinoSliverRefreshControl(
                              onRefresh: () async {
                                await fetchOrders();
                              },
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => OrderListWidget(
                                  model: deliveredOrders[index],
                                  onTap: () {
                                    showActionsForOrder(deliveredOrders[index]);
                                  },
                                ),
                                childCount: deliveredOrders.length,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
