import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/widget/product_item_widget.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget(
      {super.key, required this.model, this.orderItemCallback, required this.canComment});

  final OrderItemModel model;
  final bool canComment;
  final ProductItemCallback? orderItemCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.withOpacity(.07),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                model.product!.image,
                width: 60,
                height: 60,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      model.product!.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "  ${model.product!.price * model.quantity!}\$   ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (orderItemCallback != null) ...{
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (model.quantity! > 1) {
                            orderItemCallback!(
                              OrderItemModel(
                                comment: model.comment,
                                product: model.product,
                                quantity: model.quantity! - 1,
                              ),
                            );
                          } else if (model.quantity == 1) {
                            orderItemCallback!(
                              null,
                            );
                          }
                        },
                        icon: Icon(Icons.remove_circle_outline)),
                    Text(
                      "${model.quantity}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        orderItemCallback!(
                          OrderItemModel(
                            comment: model.comment,
                            product: model.product,
                            quantity: model.quantity! + 1,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                      ),
                    ),
                  ],
                )
              } else ...{
                Text(
                  "${model.quantity} pts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              }
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  model.comment ?? "No comment",
                  style: TextStyle(
                    fontSize: 14,
                    color: model.comment == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              if (canComment)... {
                IconButton(
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text("Comment for ${model.product!.name}"),
                        content: CupertinoTextField(
                          controller: TextEditingController(text: model.comment),
                          minLines: 4,
                          maxLines: 7,
                          onChanged: (value) {
                            orderItemCallback!(
                              OrderItemModel(
                                comment: value,
                                product: model.product,
                                quantity: model.quantity,
                              ),
                            );
                          },
                          onSubmitted: (value) {
                            orderItemCallback!(
                              OrderItemModel(
                                comment: value,
                                product: model.product,
                                quantity: model.quantity,
                              ),
                            );
                          },
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                              orderItemCallback!(
                                OrderItemModel(
                                  comment: model.comment,
                                  product: model.product,
                                  quantity: model.quantity,
                                ),
                              );
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text("Done"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.edit_note_rounded),
                ),
              }
            ],
          ),
        ],
      ),
    );
  }
}
