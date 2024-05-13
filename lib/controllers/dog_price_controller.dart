import 'dart:math';

import 'package:get/get.dart';

class DogPriceController extends GetxController {
  RxInt price = 0.obs;

  void generateRandomPrice() {
    final Random random = Random();
    price.value = 20000 + random.nextInt(30001);
  }
}
