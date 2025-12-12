import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_food.dart';
import 'create_delivery_man.dart';
import 'create_food.dart';
import 'manage_order.dart';

class AdminHome extends StatelessWidget {
  Widget gridItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: Colors.teal),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            gridItem(
              'Create Delivery',
              Icons.delivery_dining,
              () => Get.to(() => CreateDeliveryPage()),
            ),
            gridItem(
              'Create Food',
              Icons.fastfood,
              () => Get.to(() => CreateFoodPage()),
            ),
            gridItem(
              'Manage Orders',
              Icons.assignment,
              () => Get.to(() => ManageOrdersPage()),
            ),
            gridItem(
              'Food List',
              Icons.restaurant_menu,
              () => Get.to(() => AdminFoodPage()),
            ),
          ],
        ),
      ),
    );
  }
}
