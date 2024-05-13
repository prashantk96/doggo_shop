import 'package:get/get.dart';

class AnimationControllerX extends GetxController {
  RxBool isAnimating = false.obs;

  void startAnimation() {
    isAnimating.value = true;
  }

  void stopAnimation() {
    isAnimating.value = false;
  }
}
