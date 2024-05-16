import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  RxInt totalPrice = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  void fetchCartItems() {
    final cartBox = GetStorage('cart');
    cartItems.value =
        List<Map<String, dynamic>>.from(cartBox.getValues() ?? []);
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice.value =
        cartItems.fold(0, (sum, item) => sum + (item['price'] as int));
  }

  Future<void> removeItem(String imageUrl) async {
    final cartBox = GetStorage('cart');
    await cartBox.remove(imageUrl);
    fetchCartItems();
  }
}
