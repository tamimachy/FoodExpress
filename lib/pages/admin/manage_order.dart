import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/auth_controller.dart';

class ManageOrdersPage extends StatefulWidget {
  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage>
    with SingleTickerProviderStateMixin {
  final orderC = Get.find<OrderController>();
  final auth = Get.find<AuthController>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text(
          'Manage Orders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Assigned'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Obx(() => _buildOrderList(
              orderC.activeOrders.where((o) => o.status == 'placed').toList(),
              isActive: true)),
          Obx(() => _buildOrderList(
              orderC.activeOrders.where((o) => o.status == 'assigned').toList(),
              isAssigned: true)),
          Obx(() => _buildOrderList(orderC.completedOrders, isCompleted: true)),
        ],
      ),
    );
  }

  Widget _buildOrderList(List orders,
      {bool isActive = false,
      bool isAssigned = false,
      bool isCompleted = false}) {
    final deliveryMen =
        auth.usersBox.values.where((u) => u.role == 'delivery').toList();

    if (orders.isEmpty) {
      return Center(
        child: Text('No orders found', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final o = orders[i];

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${o.id}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('User: ${o.userId}'),
                Text('Total: ৳${o.total.toStringAsFixed(2)}'),
                Text('Status: ${o.status}'),
                SizedBox(height: 6),
                if (isActive)
                  DropdownButton<String>(
                    hint: Text('Assign Delivery Man'),
                    value: o.deliveryManId,
                    isExpanded: true,
                    items: deliveryMen.map<DropdownMenuItem<String>>((d) {
                      return DropdownMenuItem(
                        value: d.id,
                        child: Text(d.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        orderC.assignDeliveryMan(o.id, val);
                        Get.snackbar('Success', 'Delivery Man assigned',
                            backgroundColor: Colors.teal,
                            colorText: Colors.white);
                      }
                    },
                  ),
                if (isActive || isAssigned)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        orderC.cancelOrder(o.id);
                        Get.snackbar('Success', 'Order Cancelled',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                      },
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                if (isAssigned)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        orderC.markDelivered(o.id);
                        Get.snackbar('Success', 'Order marked as delivered',
                            backgroundColor: Colors.green,
                            colorText: Colors.white);
                      },
                      child: Text('Mark Delivered'),
                    ),
                  ),
                if (isCompleted)
                  Text('Delivered',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
              ],
            ),
          ),
        );
      },
    );
  }
}
