import 'package:flutter/material.dart';
import 'package:food_express/pages/user/user_order.dart';
import 'package:get/get.dart';
import '../../controllers/food_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';
import 'cart_page.dart';

class UserHome extends StatelessWidget {
  final foodC = Get.find<FoodController>();
  final auth = Get.find<AuthController>();
  final orderC = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'User Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    if (foodC.cartQuantities.isEmpty) {
                      Get.snackbar(
                        'Cart',
                        'Your cart is empty',
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    Get.to(() => CartPage());
                  },
                ),
                if (foodC.cartQuantities.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${foodC.cartQuantities.values.fold<int>(0, (sum, q) => sum + q)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: () {
              Get.to(() => UserOrdersPage());
            },
          ),
        ],
      ),
      body: Obx(
        () {
          final items = foodC.foods;

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final f = items[i];
              final qty = foodC.cartQuantities[f] ?? 0;

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: f.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child:
                                  Image.network(f.imageUrl, fit: BoxFit.cover),
                            )
                          : Container(color: Colors.grey.shade300),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(f.description,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4),
                          Text(
                            '৳${f.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.teal.shade800,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          qty == 0
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal),
                                    child: Text('Add',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      foodC.increaseQuantity(f);
                                      Get.snackbar(
                                        'Cart',
                                        '${f.name} added',
                                        backgroundColor: Colors.teal,
                                        colorText: Colors.white,
                                      );
                                    },
                                  ),
                                )
                              : Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.remove, color: Colors.red),
                                      onPressed: () {
                                        foodC.decreaseQuantity(f);
                                      },
                                    ),
                                    Text(qty.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon:
                                          Icon(Icons.add, color: Colors.green),
                                      onPressed: () {
                                        foodC.increaseQuantity(f);
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
