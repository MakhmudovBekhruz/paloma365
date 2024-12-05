import 'package:flutter/material.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/model/product_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
typedef ProductItemCallback = void Function(OrderItemModel? model);

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget(
      {super.key, required this.model, this.orderItem, this.orderItemCallback});

  final ProductModel model;
  final OrderItemModel? orderItem;
  final ProductItemCallback? orderItemCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 6,),
          Row(
            children: [
              Image.asset(
                model.image,
                width: 100,
                height: 100,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${model.price}\$   ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      model.shortDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Spacer(),
              if (orderItem != null) ...{
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (orderItemCallback != null) {
                            if (orderItem!.quantity! > 1) {
                              orderItemCallback!(
                                OrderItemModel(
                                  comment: orderItem!.comment,
                                  product: model,
                                  quantity: orderItem!.quantity! - 1,
                                ),
                              );
                            } else if (orderItem!.quantity == 1) {
                              orderItemCallback!(
                                null,
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline)),
                    Text(
                      "${orderItem!.quantity}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (orderItemCallback != null) {
                          orderItemCallback!(
                            OrderItemModel(
                              comment: orderItem!.comment,
                              product: model,
                              quantity: orderItem!.quantity! + 1,
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                      ),
                    ),
                  ],
                )
              } else ...{
                TextButton(
                  onPressed: () {
                    if (orderItemCallback != null) {
                      orderItemCallback!(
                        OrderItemModel(product: model, quantity: 1),
                      );
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              }
            ],
          )
        ],
      ),
    );
  }
}
