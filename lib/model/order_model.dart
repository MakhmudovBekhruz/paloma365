import 'package:flutter/material.dart';
import 'package:paloma365/model/product_model.dart';
import 'package:paloma365/model/section_model.dart';
import 'package:paloma365/model/table_model.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */
enum OrderStatus {
  NEW(label: "New", color: Colors.indigo),
  TO_BE_DELIVER(label: "To be deliver", color: Colors.purpleAccent),
  DELIVERED(label: "Delivered", color: Colors.blue),
  CANCELLED(label: "Cancelled", color: Colors.red),
  COMPLETED(label: "Completed", color: Colors.green);

  final String label;
  final Color color;

  const OrderStatus({required this.label, required this.color});
}

class OrderModel {
  final int? id;
  final int? tableId;
  final int? sectionId;
  final int? orderNumber;
  final List<OrderItemModel>? items;
  final DateTime? createdAt;
  final OrderStatus? status;
  SectionModel? section;
  TableModel? table;

  OrderModel({
    this.id,
    this.tableId,
    this.sectionId,
    this.orderNumber,
    this.items,
    this.createdAt,
    this.status,
  });
}

class OrderItemModel {
  ProductModel? product;
  final int? productId;
  final int? quantity;
  final String? comment;

  OrderItemModel({
    this.product,
    this.quantity,
    this.comment,
    this.productId,
  });
}
