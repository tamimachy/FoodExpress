import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user.dart';

class DeliveryHome extends StatelessWidget {
  final orderC = Get.find<OrderController>();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final usersBox = Hive.box<AppUser>('users');
    final current = auth.currentUser.value;

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Delivery Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        final assignedOrders = orderC.activeOrders
            .where((o) => o.deliveryManId == current?.id)
            .toList();

        if (assignedOrders.isEmpty) {
          return Center(
            child: Text(
              'No assigned orders yet',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: assignedOrders.length,
          itemBuilder: (_, i) {
            final order = assignedOrders[i];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  'Order ${order.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Status: ${order.status}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Total: ৳${order.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Delivered',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    final amountC = TextEditingController();

                    Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Collected Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800,
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: amountC,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Amount (৳)',
                                  prefixIcon: Icon(Icons.attach_money,
                                      color: Colors.teal),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        final amtText = amountC.text.trim();
                                        if (amtText.isEmpty) {
                                          Get.snackbar(
                                            'Error',
                                            'Please enter the collected amount',
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        final amt = double.tryParse(amtText);
                                        if (amt == null || amt <= 0) {
                                          Get.snackbar(
                                            'Error',
                                            'Please enter a valid amount',
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        final dm =
                                            usersBox.get(order.deliveryManId);
                                        if (dm != null) {
                                          dm.collectedAmount =
                                              (dm.collectedAmount ?? 0) + amt;
                                          dm.save();
                                        }

                                        orderC.markDelivered(order.id);
                                        Get.back();

                                        Get.snackbar(
                                          'Success',
                                          'Order marked as delivered',
                                          backgroundColor: Colors.teal,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side:
                                            BorderSide(color: Colors.redAccent),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
