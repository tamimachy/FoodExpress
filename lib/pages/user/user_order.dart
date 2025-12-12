import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/auth_controller.dart';

class UserOrdersPage extends StatelessWidget {
  final orderC = Get.find<OrderController>();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        final userId = auth.currentUser.value?.id;
        if (userId == null) {
          return Center(child: Text('Login first'));
        }

        final userOrders =
            orderC.activeOrders.where((o) => o.userId == userId).toList();

        if (userOrders.isEmpty) {
          return Center(child: Text('No active orders'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: userOrders.length,
          itemBuilder: (_, i) {
            final o = userOrders[i];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${o.id}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Total: ৳${o.total.toStringAsFixed(2)}'),
                    Text('Status: ${o.status}'),
                    if (o.status == 'placed' || o.status == 'assigned')
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                          onPressed: () {
                            orderC.cancelOrder(o.id);
                            Get.snackbar(
                              'Success',
                              'Order cancelled',
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          },
                          child: Text(
                            'Cancel Order',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
