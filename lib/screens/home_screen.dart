import 'package:doggo_shop/api/api.dart';
import 'package:doggo_shop/controllers/dog_price_controller.dart';
import 'package:doggo_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:doggo_shop/controllers/animation_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    DogPriceController c = Get.put(
        DogPriceController()); //instance of DogPriceController for random price
    RxString newUrl = ''.obs;
    final AnimationControllerX animationController =
        Get.put(AnimationControllerX());

    //instance of api class
    Api api = Api();

    mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.red, Colors.white, Colors.green],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: const Text(
              'The Doggo Shop',
              style: TextStyle(fontSize: 36.0, fontFamily: 'PoetsenOne'),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed('/cart');
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ))
          ],
        ),
        body: Stack(
          children: [
            Obx(() {
              return Column(
                children: [
                  if (newUrl.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                            height: mq.height * 0.4,
                            width: mq.width,
                            child: Image.network(
                              newUrl.value,
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                }
                              },
                            )),
                        SizedBox(height: mq.height * 0.04),
                        Container(
                          color: Colors.indigo.shade100,
                          height: mq.height * 0.05,
                          width: mq.width,
                          child: Center(
                            child: Text(
                              '₹ ${c.price.value.toString()}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(height: mq.height * 0.04),
                        ElevatedButton(
                            onPressed: () {
                              _saveToCart(newUrl.value, c.price.value)
                                  .then((value) => Get.snackbar(
                                        "Hurray",
                                        'successfully added to cart',
                                        backgroundColor: Colors.indigo.shade200,
                                        snackPosition: SnackPosition.BOTTOM,
                                      ))
                                  .then((_) =>
                                      animationController.startAnimation())
                                  .then((value) => Future.delayed(
                                          const Duration(milliseconds: 500))
                                      .then((value) =>
                                          animationController.stopAnimation()));
                            },
                            child: const Text('Add To Cart'))
                      ],
                    )
                  else
                    const Center(
                        child: Text(
                      'Fetch Image URL',
                      style: TextStyle(color: Colors.red),
                    )),
                ],
              );
            }),
            Obx(() {
              if (animationController.isAnimating.value) {
                return Lottie.asset('assets/animations/celebrate.json',
                    width: mq.width,
                    height: mq.height,
                    fit: BoxFit.fill,
                    repeat: false);
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
        floatingActionButton: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: FloatingActionButton(
                      onPressed: () {
                        Get.toNamed('/history');
                      },
                      child: const Text(
                        'History',
                      )),
                ),
              ),
              const Spacer(),
              Expanded(
                child: FloatingActionButton(
                  onPressed: () {
                    api.fetchRandomDogImage().then((url) {
                      newUrl.value = url;
                    }).then((price) {
                      c.generateRandomPrice();
                    }).then((value) {
                      _saveToHistory(newUrl.value, c.price.value);
                    });
                  },
                  child: const Text('Get new Dog'),
                ),
              ),
            ],
          ),
        ));
  }

  //to store price and image url into getStorage container & name of container is history
  Future<void> _saveToHistory(String imageUrl, int price) async {
    final historyBox = GetStorage('history');
    final historyItem = {'imageUrl': imageUrl, 'price': price};
    await historyBox.write(
        DateTime.now().millisecondsSinceEpoch.toString(), historyItem);
  }

  //to store price and image url into getStorage container & name of container is cart
  Future<void> _saveToCart(String imageUrl, int price) async {
    final cartBox = GetStorage('cart');
    // cartBox.erase();
    final cartItem = {'imageUrl': imageUrl, 'price': price};
    await cartBox.write(imageUrl, cartItem);
  }
}
