import 'package:paloma365/model/order_model.dart';
import 'package:paloma365/model/order_model.dart';
import 'package:sqflite/sqflite.dart';

/**
 * Created by Bekhruz Makhmudov on 05/12/24.
 * Project paloma365
 */

//order table
const String _orderTable = 'orders';
const String _orderTableId = 'id';
const String _orderTableNumber = 'number';
const String _orderTableCreatedAtYear = 'created_at_year';
const String _orderTableCreatedAtMonth = 'created_at_month';
const String _orderTableCreatedAtDay = 'created_at_day';
const String _orderTableCreatedAtHour = 'created_at_hour';
const String _orderTableCreatedAtMinute = 'created_at_minute';
const String _orderTableStatus = 'status';
const String _orderTableTableId = 'table_id';
const String _orderTableSectionId = 'section_id';

//order line items table
const String _orderLineItemsTable = 'order_line_items';
const String _orderLineItemsTableOrderId = 'order_id';
const String _orderLineItemsTableProductId = 'product_id';
const String _orderLineItemsTableQuantity = 'quantity';
const String _orderLineItemsTableComment = 'comment';

class OrderRepository {
  late Database db;

  //singleton
  OrderRepository._();

  static final OrderRepository _instance = OrderRepository._();

  static OrderRepository get instance => _instance;

  Future<void> init() async {
    db = await openDatabase(
      'paloma365.db',
      version: 1,
      onCreate: (db, version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE $_orderTable ('
          '$_orderTableId INTEGER PRIMARY KEY AUTOINCREMENT,'
          '$_orderTableCreatedAtYear INTEGER,'
          '$_orderTableCreatedAtMonth INTEGER,'
          '$_orderTableCreatedAtDay INTEGER,'
          '$_orderTableCreatedAtHour INTEGER,'
          '$_orderTableCreatedAtMinute INTEGER,'
          '$_orderTableNumber INTEGER,'
          '$_orderTableStatus TEXT,'
          '$_orderTableSectionId INTEGER,'
          '$_orderTableTableId INTEGER'
          ')',
        );

        await db.execute(
          'CREATE TABLE $_orderLineItemsTable ('
          '$_orderLineItemsTableOrderId INTEGER,'
          '$_orderLineItemsTableProductId INTEGER,'
          '$_orderLineItemsTableQuantity INTEGER,'
          '$_orderLineItemsTableComment TEXT'
          ')',
        );
      },
    );
  }

  Future<void> close() async {
    await db.close();
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    final id = await db.insert(_orderTable, order.toMap());
    for (final OrderItemModel item in order.items ?? []) {
      await db.insert(_orderLineItemsTable, item.toMap(id));
    }
    final lineItems = await db.query(_orderLineItemsTable,
        where: '$_orderLineItemsTableOrderId = ?', whereArgs: [id]);
    final orderList = await db
        .query(_orderTable, where: '$_orderTableId = ?', whereArgs: [id]);

    return OrderModel().fromMap(orderList.first,
        lineItems.map((e) => OrderItemModel().fromMap(e)).toList());
  }

  Future<OrderModel> updateOrder(OrderModel order) async {
    await db.update(_orderTable, order.toMap(),
        where: '$_orderTableId = ?', whereArgs: [order.id]);
    await db.delete(_orderLineItemsTable,
        where: '$_orderLineItemsTableOrderId = ?', whereArgs: [order.id]);
    for (final OrderItemModel item in order.items ?? []) {
      await db.insert(_orderLineItemsTable, item.toMap(order.id!));
    }
    final lineItems = await db.query(_orderLineItemsTable,
        where: '$_orderLineItemsTableOrderId = ?', whereArgs: [order.id]);
    final orderList = await db
        .query(_orderTable, where: '$_orderTableId = ?', whereArgs: [order.id]);

    return OrderModel().fromMap(orderList.first,
        lineItems.map((e) => OrderItemModel().fromMap(e)).toList());
  }

  Future<List<OrderModel>> getOrders() async {
    final orderList = await db.query(_orderTable);
    final orders = <OrderModel>[];
    for (final order in orderList) {
      final lineItems = await db.query(_orderLineItemsTable,
          where: '$_orderLineItemsTableOrderId = ?',
          whereArgs: [order[_orderTableId]]);
      orders.add(OrderModel().fromMap(
          order, lineItems.map((e) => OrderItemModel().fromMap(e)).toList()));
    }
    return orders;
  }

  //get orders by status order by new to old
  Future<List<OrderModel>> getOrdersByStatus(OrderStatus status) async {
    final orderList = await db.query(_orderTable,
        where: '$_orderTableStatus = ?',
        whereArgs: [status.name],
        orderBy:
            '$_orderTableCreatedAtYear DESC, $_orderTableCreatedAtMonth DESC, $_orderTableCreatedAtDay DESC, $_orderTableCreatedAtHour DESC, $_orderTableCreatedAtMinute DESC');
    final orders = <OrderModel>[];
    for (final order in orderList) {
      final lineItems = await db.query(_orderLineItemsTable,
          where: '$_orderLineItemsTableOrderId = ?',
          whereArgs: [order[_orderTableId]]);
      orders.add(OrderModel().fromMap(
          order, lineItems.map((e) => OrderItemModel().fromMap(e)).toList()));
    }
    return orders;
  }

  //get order by tableId
  Future<OrderModel?> getOrderByTableId(int tableId) async {
    final orderList = await db.query(_orderTable,
        where: '$_orderTableTableId = ?', whereArgs: [tableId]);
    if (orderList.isNotEmpty) {
      final lineItems = await db.query(_orderLineItemsTable,
          where: '$_orderLineItemsTableOrderId = ?',
          whereArgs: [orderList.first[_orderTableId]]);
      return OrderModel().fromMap(orderList.first,
          lineItems.map((e) => OrderItemModel().fromMap(e)).toList());
    }
    return null;
  }

  //get today orders count
  Future<int> getTodayOrdersCount() async {
    final today = DateTime.now();
    final orderList = await db.query(_orderTable,
        where:
            '$_orderTableCreatedAtYear = ? AND $_orderTableCreatedAtMonth = ? AND $_orderTableCreatedAtDay = ?',
        whereArgs: [today.year, today.month, today.day]);
    return orderList.length;
  }

  //get order for section and order statuses
  Future<List<OrderModel>> getOrdersBySection(
      int sectionId, List<OrderStatus> statuses) async {
    final orderList = await db.query(_orderTable,
        where:
            '$_orderTableSectionId = ? AND $_orderTableStatus IN (${statuses.map((e) => '?').join(',')})',
        whereArgs: [sectionId, ...statuses.map((e) => e.name)]);
    final orders = <OrderModel>[];
    for (final order in orderList) {
      final lineItems = await db.query(_orderLineItemsTable,
          where: '$_orderLineItemsTableOrderId = ?',
          whereArgs: [order[_orderTableId]]);
      orders.add(OrderModel().fromMap(
          order, lineItems.map((e) => OrderItemModel().fromMap(e)).toList()));
    }
    return orders;
  }

  //update order status
  Future<void> updateOrderStatus(int orderId, OrderStatus status) async {
    await db.update(_orderTable, {_orderTableStatus: status.name},
        where: '$_orderTableId = ?', whereArgs: [orderId]);
  }
}

extension OrderModelExtension on OrderModel {
  Map<String, dynamic> toMap() {
    return {
      _orderTableId: id,
      _orderTableCreatedAtYear: createdAt!.year,
      _orderTableCreatedAtMonth: createdAt!.month,
      _orderTableCreatedAtDay: createdAt!.day,
      _orderTableCreatedAtHour: createdAt!.hour,
      _orderTableCreatedAtMinute: createdAt!.minute,
      _orderTableNumber: orderNumber,
      _orderTableStatus: status!.name,
      _orderTableTableId: tableId,
      _orderTableSectionId: sectionId,
    };
  }

  OrderModel fromMap(Map<String, dynamic> map, List<OrderItemModel> items) {
    return OrderModel(
      id: map[_orderTableId],
      createdAt: DateTime(
        map[_orderTableCreatedAtYear],
        map[_orderTableCreatedAtMonth],
        map[_orderTableCreatedAtDay],
        map[_orderTableCreatedAtHour],
        map[_orderTableCreatedAtMinute],
      ),
      orderNumber: map[_orderTableNumber],
      status: OrderStatus.values
          .firstWhere((element) => element.name == map[_orderTableStatus]),
      tableId: map[_orderTableTableId],
      items: items,
    );
  }
}

extension OrderLineItemsModelExtension on OrderItemModel {
  Map<String, dynamic> toMap(int orderId) {
    return {
      _orderLineItemsTableOrderId: orderId,
      _orderLineItemsTableProductId: product!.id,
      _orderLineItemsTableQuantity: quantity,
      _orderLineItemsTableComment: comment,
    };
  }

  OrderItemModel fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map[_orderLineItemsTableProductId],
      quantity: map[_orderLineItemsTableQuantity],
      comment: map[_orderLineItemsTableComment],
      product: null,
    );
  }
}
