import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class AppUser extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String role;

  @HiveField(5)
  double collectedAmount;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.collectedAmount = 0,
  });
}
