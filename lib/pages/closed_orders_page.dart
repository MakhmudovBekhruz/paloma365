import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/pages/order_details_page.dart';

import '../data/order_repository.dart';
import '../data/product_repository.dart';
import '../data/section_repository.dart';
import '../data/table_repository.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import '../model/section_model.dart';
import '../model/table_model.dart';
import '../widget/order_list_widget.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class ClosedOrdersPage extends StatefulWidget {
  const ClosedOrdersPage({super.key});

  @override
  State<ClosedOrdersPage> createState() => _ClosedOrdersPageState();
}

class _ClosedOrdersPageState extends State<ClosedOrdersPage> {
  bool loading = true;
  List<OrderModel> completedOrders = [];
  List<OrderModel> cancelledOrders = [];
  Map<int, SectionModel> sections = {};
  Map<int, TableModel> tables = {};
  Map<int, ProductModel> products = {};

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
    completedOrders =
        await OrderRepository.instance.getOrdersByStatus(OrderStatus.COMPLETED);
    cancelledOrders =
        await OrderRepository.instance.getOrdersByStatus(OrderStatus.CANCELLED);
    for (final order in [
      ...completedOrders,
      ...cancelledOrders,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order History",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: loading
          ? const Center(child: CupertinoActivityIndicator())
          : DefaultTabController(
              length: 2,
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
                        text: "Completed (${completedOrders.length})",
                      ),
                      Tab(
                        text: "Cancelled (${cancelledOrders.length})",
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
                                  model: completedOrders[index],
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    await showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => OrderDetailsPage(
                                        model: completedOrders[index],
                                      ),
                                    );
                                  },
                                ),
                                childCount: completedOrders.length,
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
                                  model: cancelledOrders[index],
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    await showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => OrderDetailsPage(
                                        model: cancelledOrders[index],
                                      ),
                                    );
                                  },
                                ),
                                childCount: cancelledOrders.length,
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
