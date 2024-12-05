import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/data/order_repository.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/widget/order_item_widget.dart';

/**
 * Created by Bekhruz Makhmudov on 06/12/24.
 * Project paloma365
 */
class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.model});

  final OrderModel model;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${widget.model.orderNumber}"),
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
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            margin: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                for (final orderItem in widget.model.items ?? []) ...{
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: OrderItemWidget(
                      model: orderItem,
                      canComment: widget.model.status == OrderStatus.NEW,
                    ),
                  )
                }
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(right: 20, left: 20, top: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 1,
          )
        ]),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total: ${widget.model.items!.fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue +
                              element.quantity! * element.product!.price,
                        ).toInt()}\$",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Total with service (10%): ${(widget.model.items!.fold(
                      0.0,
                          (previousValue, element) =>
                      previousValue +
                          element.quantity! * element.product!.price,
                    ).toInt() * 1.1).toStringAsFixed(1)}\$",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (widget.model.status == OrderStatus.DELIVERED) ... {
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo)),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        OrderRepository.instance.updateOrderStatus(
                            widget.model.id!, OrderStatus.COMPLETED);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Complete the order",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}
