import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/model/order_model.dart';

/**
 * Created by Bekhruz Makhmudov on 06/12/24.
 * Project paloma365
 */
class OrderListWidget extends StatelessWidget {
  const OrderListWidget({super.key, required this.model, required this.onTap});

  final OrderModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(
              left: 14,
            ),
            child: Text(
              "#${model.orderNumber.toString()}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.indigo,
              ),
            ),
          ),
          title: Text(
            "Table #${model.table?.number} at ${model.section?.name}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${model.createdAt?.hour.toString().padLeft(2, "0")}:${model.createdAt?.minute.toString().padLeft(2, "0")}  ${model.createdAt?.day}/${model.createdAt?.month}/${model.createdAt?.year}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (model.items!
                  .where(
                    (e) => e.comment != null,
              ).isNotEmpty)... {
                Text(
                  model.items!
                      .where(
                        (e) => e.comment != null,
                  )
                      .map(
                        (e) => e.comment!,
                  )
                      .join("\n"),
                  style: const TextStyle(fontSize: 12),
                ),
              }

            ],
          ),
          contentPadding: EdgeInsets.zero,
          trailing: Container(
            width: 70,
            child: Stack(
              children: [
                for (int i = 0; i < model.items!.take(3).length; i++) ...{
                  Positioned(
                    right: (i + 1) * 8.0,
                    bottom: 0,
                    top: 0,
                    child: Image.asset(
                      model.items![i].product!.image,
                      width: 30,
                    ),
                  )
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
