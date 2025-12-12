import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/food_controller.dart';
import '../../models/food.dart';

class AdminFoodPage extends StatelessWidget {
  final foodC = Get.find<FoodController>();

  void editFood(BuildContext context, Food f) {
    final nameC = TextEditingController(text: f.name);
    final descC = TextEditingController(text: f.description);
    final priceC = TextEditingController(text: f.price.toString());
    final imageC = TextEditingController(text: f.imageUrl);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit Food',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal)),
              SizedBox(height: 12),
              TextField(
                  controller: nameC,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: descC,
                  decoration: InputDecoration(labelText: 'Description')),
              TextField(
                controller: priceC,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                  controller: imageC,
                  decoration: InputDecoration(labelText: 'Image URL')),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      onPressed: () {
                        final updatedPrice =
                            double.tryParse(priceC.text.trim()) ?? f.price;

                        foodC.updateFood(
                          f.id,
                          nameC.text.trim(),
                          descC.text.trim(),
                          updatedPrice,
                          imageC.text.trim(),
                        );

                        final index =
                            foodC.foods.indexWhere((e) => e.id == f.id);
                        if (index != -1) {
                          foodC.foods[index] = Food(
                            id: f.id,
                            name: nameC.text.trim(),
                            description: descC.text.trim(),
                            price: updatedPrice,
                            imageUrl: imageC.text.trim(),
                          );
                        }

                        Get.back();
                      },
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              )
            ],
          ),
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
        title: Text('Food List', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        final items = foodC.foods;
        if (items.isEmpty) {
          return Center(child: Text('No food found'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final f = items[i];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: f.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(f.imageUrl,
                            width: 50, height: 50, fit: BoxFit.cover),
                      )
                    : Icon(Icons.fastfood, size: 34, color: Colors.teal),
                title:
                    Text(f.name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('৳${f.price.toStringAsFixed(2)}'),
                trailing: Wrap(
                  spacing: 0,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => editFood(context, f),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        foodC.deleteFood(f.id);
                      },
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
