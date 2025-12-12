import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/food_controller.dart';
import '../controllers/order_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<FoodController>(FoodController(), permanent: true);
    Get.put<OrderController>(OrderController(), permanent: true);
  }
}
