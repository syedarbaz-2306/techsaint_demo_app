import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String cartBoxName = 'cartBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(cartBoxName);
  }

  static Box getCartBox() => Hive.box(cartBoxName);
}
