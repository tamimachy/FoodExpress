import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/food.dart';

class OrderController extends GetxController {
  late Box<Order> ordersBox;
  var activeOrders = <Order>[].obs;
  var completedOrders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    ordersBox = Hive.box<Order>('orders');
    _loadOrders();
  }

  void _loadOrders() {
    final allOrders = ordersBox.values.toList();
    activeOrders.value = allOrders
        .where((o) => o.status == 'placed' || o.status == 'assigned')
        .toList();
    completedOrders.value =
        allOrders.where((o) => o.status == 'delivered').toList();
  }

  Order createOrder({
    required String userId,
    required List<Food> items,
    required double deliveryCharge,
  }) {
    final id = const Uuid().v4();
    final totalPrice =
        items.fold<double>(0, (sum, item) => sum + item.price) + deliveryCharge;

    final order = Order(
      id: id,
      userId: userId,
      items: items,
      total: totalPrice,
      status: 'placed',
      deliveryManId: null,
      deliveryCharge: deliveryCharge,
    );

    ordersBox.put(id, order);
    _loadOrders();
    return order;
  }

  void cancelOrder(String orderId) {
    final order = ordersBox.get(orderId);
    if (order != null) {
      order.status = 'cancelled';
      order.save();
      _loadOrders();
    }
  }

  void assignDeliveryMan(String orderId, String deliveryManId) {
    final order = ordersBox.get(orderId);
    if (order != null) {
      order.deliveryManId = deliveryManId;
      order.status = 'assigned';
      order.save();
      _loadOrders();
    }
  }

  void markDelivered(String orderId) {
    final order = ordersBox.get(orderId);
    if (order != null) {
      order.status = 'delivered';
      order.save();
      _loadOrders();
    }
  }
}
