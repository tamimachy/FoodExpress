import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../admin/admin_home.dart';
import '../delivery/delivery_home.dart';
import '../user/user_home.dart';

class LoginPage extends StatelessWidget {
  final String role;
  LoginPage({required this.role});

  final emailC = TextEditingController();
  final passC = TextEditingController();
  final auth = Get.find<AuthController>();

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
          '${role.toUpperCase()} LOGIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                Icons.lock_outline,
                size: 40,
                color: Colors.teal.shade800,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Login as ${role.toUpperCase()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: Icon(Icons.login, color: Colors.white),
                label: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final ok = auth.login(
                    emailC.text.trim(),
                    passC.text.trim(),
                    role,
                  );

                  if (ok) {
                    if (role == 'admin') {
                      Get.off(() => AdminHome());
                    } else if (role == 'delivery') {
                      Get.off(() => DeliveryHome());
                    } else {
                      Get.off(() => UserHome());
                    }
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Invalid credentials or wrong role',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
