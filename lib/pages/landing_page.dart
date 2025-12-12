import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'FoodExpress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Spacer(),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                Icons.fastfood,
                size: 45,
                color: Colors.teal.shade800,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to FoodExpress',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Fast • Fresh • Delivered',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Choose role to continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            RoleCard(
              label: 'User - Register / Login',
              icon: Icons.person,
              role: 'user',
              onTap: () {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person_add, color: Colors.teal),
                          title: Text('Register'),
                          onTap: () {
                            Get.back();
                            Get.to(() => RegisterPage());
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.login, color: Colors.teal),
                          title: Text('Login'),
                          onTap: () {
                            Get.back();
                            Get.to(() => LoginPage(role: 'user'));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 14),
            RoleCard(
              label: 'Admin - Login',
              icon: Icons.admin_panel_settings,
              role: 'admin',
              onTap: () {
                Get.to(() => LoginPage(role: 'admin'));
              },
            ),
            SizedBox(height: 14),
            RoleCard(
              label: 'Delivery - Login',
              icon: Icons.delivery_dining,
              role: 'delivery',
              onTap: () {
                Get.to(() => LoginPage(role: 'delivery'));
              },
            ),
            Spacer(),
            Text(
              'Note: Admin must pre-create delivery accounts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String label;
  final String role;
  final IconData icon;
  final VoidCallback onTap;

  RoleCard({
    required this.label,
    required this.role,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                icon,
                color: Colors.teal.shade800,
                size: 26,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
