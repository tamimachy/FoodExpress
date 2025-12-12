
import 'package:hive/hive.dart';
import 'food.dart';
part 'order.g.dart';

@HiveType(typeId: 2)
class Order extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String userId;
  @HiveField(2)
  List<Food> items;
  @HiveField(3)
  double total;
  @HiveField(4)
  String status; // placed, assigned, on_delivery, delivered, cancelled
  @HiveField(5)
  String? deliveryManId;
  @HiveField(6)
  double deliveryCharge;

  Order({required this.id, required this.userId, required this.items, required this.total, required this.status, this.deliveryManId, this.deliveryCharge = 0});
}
