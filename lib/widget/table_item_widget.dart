import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/model/table_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
class TableItemWidget extends StatelessWidget {
  const TableItemWidget(
      {super.key, required this.model, required this.onTap, this.orderModel});

  final TableModel model;
  final VoidCallback onTap;
  final OrderModel? orderModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: orderModel?.status?.color.withOpacity(.15) ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: orderModel != null ? [] : [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_restaurant_sharp,
              color: Colors.brown,
              size: 55,
            ),
            Text(
              model.number.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              orderModel?.status?.label ?? 'Empty',
              style: TextStyle(
                color: orderModel?.status?.color ?? Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
