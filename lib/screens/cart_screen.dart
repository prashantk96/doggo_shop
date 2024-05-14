import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartStorage = GetStorage('cart');
    //cartStorage.getValues() fetches values from cartStorage and then List<Map<String, dynamic>>.from() creates new list and store it in cartItems variable
    RxList<Map<String, dynamic>> cartItems =
        List<Map<String, dynamic>>.from(cartStorage.getValues() ?? []).obs;

    log(cartItems.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        item['imageUrl'],
                      ),
                    ),
                    title: Text('Price: ₹${item['price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Item'),
                            content: const Text(
                                'Are you sure you want to remove this item?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('Remove'),
                                onPressed: () {
                                  cartItems.removeAt(
                                      index); //removing data from current objects index
                                  cartStorage.remove(item[
                                      'imageUrl']); // remove item from cart storage with current items imageUrl passing as key
                                  _calculateTotalPrice(
                                      cartItems); //and again calculating price in available products in cart
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 50),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Items: ${cartItems.length}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Total Price: ₹${_calculateTotalPrice(cartItems)}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

// it returns int which is of reactive type we can access it by variable.value
  RxInt _calculateTotalPrice(RxList<Map<String, dynamic>> cartItems) {
    RxInt totalPrice = 0.obs;
    for (var item in cartItems) {
      totalPrice += item['price'] as int;
    }
    return totalPrice;
  }
}
