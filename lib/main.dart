import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'binding/binding.dart';
import 'models/food.dart';
import 'models/user.dart';
import 'models/order.dart';
import 'pages/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();

  // ✅ Register Hive Adapters (100% Safe)
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(FoodAdapter()); // typeId = 0
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AppUserAdapter()); // typeId = 1
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(OrderAdapter()); // typeId = 2
  }

  // ✅ Open Hive Boxes
  await Hive.openBox<Food>('foods');
  await Hive.openBox<AppUser>('users');
  await Hive.openBox<Order>('orders');

  // ✅ Add Default Food Items if Empty
  final foodsBox = Hive.box<Food>('foods');
  if (foodsBox.isEmpty) {
    foodsBox.addAll([
      Food(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic delight with 100% real mozzarella cheese',
        price: 700.99,
        imageUrl:
            'https://au.ooni.com/cdn/shop/articles/20220211142645-margherita-9920.jpg?v=1737368217&width=1080',
      ),
      Food(
        id: '2',
        name: 'Veggie Burger',
        description: 'Loaded with fresh veggies and sauce',
        price: 200.49,
        imageUrl:
            'https://www.realsimple.com/thmb/z3cQCYXTyDQS9ddsqqlTVE8fnpc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/real-simple-mushroom-black-bean-burgers-recipe-0c365277d4294e6db2daa3353d6ff605.jpg',
      ),
      Food(
        id: '3',
        name: 'Chocolate Cake',
        description: 'Rich and creamy chocolate cake slice',
        price: 1300.99,
        imageUrl:
            'https://www.giverecipe.com/wp-content/uploads/2020/06/Chocolate-Strawberry-Cake.jpg',
      ),
    ]);
  }

  runApp(FoodExpressApp());
}

class FoodExpressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FoodExpress',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      home: LandingPage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.tealAccent,
        ),
      ),
    );
  }
}
