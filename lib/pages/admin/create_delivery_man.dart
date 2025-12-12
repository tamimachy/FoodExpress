import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class CreateDeliveryPage extends StatelessWidget {
  final auth = Get.find<AuthController>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  void showError(String msg) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text('Create Delivery Man',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.teal.shade100,
              child: Icon(Icons.person_add_alt_1,
                  size: 45, color: Colors.teal.shade800),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailC,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: Icon(Icons.person_add, color: Colors.white),
                label: Text('Create',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (nameC.text.trim().isEmpty ||
                      emailC.text.trim().isEmpty ||
                      passC.text.trim().isEmpty) {
                    showError('All fields are required');
                    return;
                  }

                  auth.createDeliveryMan(
                      nameC.text.trim(), emailC.text.trim(), passC.text.trim());

                  Get.snackbar(
                    'Success',
                    'Delivery man created successfully',
                    backgroundColor: Colors.teal,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  nameC.clear();
                  emailC.clear();
                  passC.clear();

                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
