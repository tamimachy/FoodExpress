import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  var currentUser = Rxn<AppUser>();
  late Box<AppUser> usersBox;

  @override
  void onInit() {
    super.onInit();
    usersBox = Hive.box<AppUser>('users');
    _forceCreateDefaultAdmin();
  }

  void _forceCreateDefaultAdmin() {
    final keys = usersBox.keys.toList();

    for (var key in keys) {
      final user = usersBox.get(key);
      if (user?.role == 'admin') {
        usersBox.delete(key);
      }
    }

    final id = const Uuid().v4();
    final admin = AppUser(
      id: id,
      name: 'Main Admin',
      email: 'admin@foodexpress.com',
      password: '123456',
      role: 'admin',
    );

    usersBox.put(id, admin);
  }

  void register(String name, String email, String password) {
    final cleanEmail = email.trim().toLowerCase();

    final exists =
        usersBox.values.any((u) => u.email.toLowerCase() == cleanEmail);

    if (exists) {
      Get.snackbar(
        'Error',
        'Email already registered',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final id = const Uuid().v4();
    final user = AppUser(
      id: id,
      name: name.trim(),
      email: cleanEmail,
      password: password.trim(),
      role: 'user',
    );

    usersBox.put(id, user);

    Get.snackbar(
      'Success',
      'Registration successful. Please login.',
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool login(String email, String password, String role) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();

    try {
      final match = usersBox.values.firstWhere(
        (u) =>
            u.email.toLowerCase() == cleanEmail &&
            u.password == cleanPass &&
            u.role == role,
      );

      currentUser.value = match;
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    currentUser.value = null;
  }

  void createDeliveryMan(String name, String email, String password) {
    final cleanEmail = email.trim().toLowerCase();

    final exists =
        usersBox.values.any((u) => u.email.toLowerCase() == cleanEmail);

    if (exists) {
      Get.snackbar(
        'Error',
        'Email already used',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final id = const Uuid().v4();
    final user = AppUser(
      id: id,
      name: name.trim(),
      email: cleanEmail,
      password: password.trim(),
      role: 'delivery',
    );

    usersBox.put(id, user);

    Get.snackbar(
      'Success',
      'Delivery man created successfully',
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<AppUser> get deliveryMen =>
      usersBox.values.where((u) => u.role == 'delivery').toList();
}
