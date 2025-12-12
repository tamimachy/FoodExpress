import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/food_controller.dart';
import '../../controllers/order_controller.dart';

class CartPage extends StatelessWidget {
  final foodC = Get.find<FoodController>();
  final orderC = Get.find<OrderController>();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              'Your Cart (${foodC.cartQuantities.length})',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (foodC.cartQuantities.isEmpty) {
          return Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          );
        }

        final items = foodC.cartQuantities.entries.toList();
        final subtotal =
            items.fold<double>(0, (sum, e) => sum + e.key.price * e.value);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final f = items[i].key;
                  final qty = items[i].value;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(f.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800)),
                      subtitle: Text('৳${f.price.toStringAsFixed(2)}'),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                  color: Colors.redAccent),
                              onPressed: () {
                                foodC.decreaseQuantity(f);
                              },
                            ),
                            Text('$qty',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline,
                                  color: Colors.teal),
                              onPressed: () {
                                foodC.increaseQuantity(f);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -3))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('৳${subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800)),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      onPressed: () {
                        final user = auth.currentUser.value;
                        if (user == null) {
                          Get.snackbar(
                            'Error',
                            'Login first',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        final order = orderC.createOrder(
                          userId: user.id,
                          items: foodC.cartList,
                          deliveryCharge: 0,
                        );

                        foodC.clearCart();

                        Get.snackbar(
                          'Order Placed',
                          'Order ID: ${order.id}',
                          backgroundColor: Colors.teal,
                          colorText: Colors.white,
                        );

                        Get.back();
                      },
                      child: Text('Place Order',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
