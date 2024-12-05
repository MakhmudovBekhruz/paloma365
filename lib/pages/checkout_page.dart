import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/data/order_repository.dart';
import 'package:paloma365/data/product_repository.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/model/product_model.dart';
import 'package:paloma365/model/table_model.dart';
import 'package:paloma365/widget/order_item_widget.dart';
import 'package:paloma365/widget/product_item_widget.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.model});

  final TableModel model;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool loading = true;
  Map<ProductType, List<ProductModel>> products = {};
  List<ProductType> expandedSections = [ProductType.FOOD];
  Map<int, OrderItemModel> orderItems = {};
  OrderModel? order;

  Future<void> saveOrder() async {
    final count = await OrderRepository.instance.getTodayOrdersCount();
    final newOrder = OrderModel(
      tableId: widget.model.id,
      items: orderItems.values.toList(),
      createdAt: order?.createdAt ?? DateTime.now(),
      orderNumber: order?.orderNumber ?? (count + 1),
      status: OrderStatus.NEW,
      sectionId: widget.model.sectionId,
      id: order?.id,
    );
    final orderModel = order == null
        ? await OrderRepository.instance.createOrder(newOrder)
        : await OrderRepository.instance.updateOrder(newOrder);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Order #${orderModel.orderNumber} ${order == null ? 'created' : 'updated'} for ${widget.model.number}# table'),
        ),
      );
    }
  }

  Future<void> fetchOrder() async {
    order = await OrderRepository.instance.getOrderByTableId(widget.model.id);
    if (order != null && order!.status == OrderStatus.NEW) {
      for (final OrderItemModel item in order!.items ?? []) {
        orderItems[item.productId!] = item;
        item.product = products.values.expand((element) => element).firstWhere(
              (element) => element.id == item.productId,
            );
      }
    }
  }

  Future<void> fetchProducts() async {
    setState(() {
      loading = true;
    });
    List<ProductModel> allProducts =
        await ProductRepository.instance.fetchProducts();
    for (final product in allProducts) {
      if (!products.containsKey(product.type)) {
        products[product.type] = [];
      }
      products[product.type]!.add(product);
    }
    await fetchOrder();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order for table ${widget.model.number}"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: loading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        for (final orderItem in orderItems.values) ...{
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            child: OrderItemWidget(
                              model: orderItem,
                              canComment: true,
                              orderItemCallback: (model) {
                                HapticFeedback.mediumImpact();
                                setState(() {
                                  if (model == null) {
                                    orderItems.remove(orderItem.product!.id);
                                  } else {
                                    orderItems[orderItem.product!.id] = model;
                                  }
                                });
                              },
                            ),
                          )
                        }
                      ],
                    ),
                  ),
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        if (isExpanded) {
                          expandedSections.add(ProductType.values[panelIndex]);
                        } else {
                          expandedSections
                              .remove(ProductType.values[panelIndex]);
                        }
                      });
                    },
                    children: [
                      for (final type in ProductType.values) ...{
                        ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: expandedSections.contains(type),
                          headerBuilder: (context, isExpanded) => Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Icon(
                                  type.icon,
                                  size: 27,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  type.label,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          body: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                for (final product in products[type]!) ...{
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    child: ProductItemWidget(
                                      model: product,
                                      orderItem: orderItems[product.id],
                                      orderItemCallback: (model) {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          if (model == null) {
                                            orderItems.remove(product.id);
                                          } else {
                                            orderItems[product.id] = model;
                                          }
                                        });
                                      },
                                    ),
                                  )
                                }
                              ],
                            ),
                          ),
                        )
                      }
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: AnimatedContainer(
        padding: EdgeInsets.only(right: 20, left: 20, top: 10),
        duration: Duration(milliseconds: 300),
        height: orderItems.isEmpty ? 0 : 90,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 1,
          )
        ]),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total: ${orderItems.values.fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue +
                          element.quantity! * element.product!.price,
                    ).toInt()}\$",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo)),
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  await saveOrder();
                  Navigator.of(context).pop();
                },
                child: Text(
                  order?.status == OrderStatus.NEW
                      ? "Update Order"
                      : "Create Order",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
