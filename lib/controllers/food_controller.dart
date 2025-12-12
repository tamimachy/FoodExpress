import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/food.dart';

class FoodController extends GetxController {
  var foods = <Food>[].obs;
  var cartQuantities = <Food, int>{}.obs;
  late Box<Food> foodsBox;

  @override
  void onInit() {
    super.onInit();
    foodsBox = Hive.box<Food>('foods');

    if (foodsBox.isEmpty) {
      _addDefaultFoods();
    }
    foods.addAll(foodsBox.values);
  }

  void _addDefaultFoods() {
    final defaultFoods = [
      Food(
        id: Uuid().v4(),
        name: 'Pepperoni Pizza',
        description: 'Delicious pepperoni pizza with cheese',
        price: 12.99,
        imageUrl: 'https://i.imgur.com/5bX2B8y.jpg',
      ),
      Food(
        id: Uuid().v4(),
        name: 'Veggie Burger',
        description: 'Healthy veggie burger with fresh ingredients',
        price: 9.99,
        imageUrl: 'https://i.imgur.com/ClxE7bD.jpg',
      ),
      Food(
        id: Uuid().v4(),
        name: 'Chicken Sandwich',
        description: 'Grilled chicken sandwich with special sauce',
        price: 8.99,
        imageUrl: 'https://i.imgur.com/qkdpN.jpg',
      ),
    ];

    for (var f in defaultFoods) {
      foodsBox.put(f.id, f);
    }
  }

  void addFood(String name, String desc, double price, [String imageUrl = '']) {
    final id = Uuid().v4();
    final f = Food(
        id: id,
        name: name,
        description: desc,
        price: price,
        imageUrl: imageUrl);
    foodsBox.put(id, f);
    foods.add(f);
  }

  void updateFood(String id, String name, String desc, double price,
      [String imageUrl = '']) {
    final f = foodsBox.get(id);
    if (f != null) {
      f.name = name;
      f.description = desc;
      f.price = price;
      f.imageUrl = imageUrl;
      f.save();
      final index = foods.indexWhere((e) => e.id == id);
      if (index != -1) foods[index] = f;
      foods.refresh();
    }
  }

  void deleteFood(String id) {
    foodsBox.delete(id);
    foods.removeWhere((f) => f.id == id);
    cartQuantities.removeWhere((key, value) => key.id == id);
  }

  List<Food> get cartList {
    final list = <Food>[];
    cartQuantities.forEach((food, qty) {
      for (int i = 0; i < qty; i++) {
        list.add(food);
      }
    });
    return list;
  }

  void increaseQuantity(Food f) {
    if (cartQuantities.containsKey(f)) {
      cartQuantities[f] = cartQuantities[f]! + 1;
    } else {
      cartQuantities[f] = 1;
    }
  }

  void decreaseQuantity(Food f) {
    if (cartQuantities.containsKey(f) && cartQuantities[f]! > 0) {
      cartQuantities[f] = cartQuantities[f]! - 1;
      if (cartQuantities[f] == 0) cartQuantities.remove(f);
    }
  }

  void clearCart() {
    cartQuantities.clear();
  }

  double get subtotal =>
      cartQuantities.entries.fold(0, (sum, e) => sum + e.key.price * e.value);
}
