import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/food_controller.dart';

class CreateFoodPage extends StatelessWidget {
  final foodC = Get.find<FoodController>();

  final foodNameC = TextEditingController();
  final foodDescC = TextEditingController();
  final foodPriceC = TextEditingController();
  final foodImageC = TextEditingController();

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
        title: Text('Create Food',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: foodNameC,
              decoration: InputDecoration(
                labelText: 'Food Name',
                prefixIcon: Icon(Icons.fastfood, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: foodDescC,
              decoration: InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: foodPriceC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: foodImageC,
              decoration: InputDecoration(
                labelText: 'Image URL',
                prefixIcon: Icon(Icons.image, color: Colors.teal),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add, color: Colors.white),
                label: Text('Add Food',
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
                  if (foodNameC.text.trim().isEmpty ||
                      foodDescC.text.trim().isEmpty ||
                      foodPriceC.text.trim().isEmpty ||
                      foodImageC.text.trim().isEmpty) {
                    Get.snackbar(
                      'Error',
                      'All fields are required',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final price = double.tryParse(foodPriceC.text);
                  if (price == null || price <= 0) {
                    Get.snackbar(
                      'Error',
                      'Enter a valid price',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  foodC.addFood(foodNameC.text.trim(), foodDescC.text.trim(),
                      price, foodImageC.text.trim());

                  Get.snackbar(
                    'Success',
                    'Food added successfully',
                    backgroundColor: Colors.teal,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 3),
                  );

                  foodNameC.clear();
                  foodDescC.clear();
                  foodPriceC.clear();
                  foodImageC.clear();

                  Future.delayed(Duration(milliseconds: 700), () => Get.back());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
