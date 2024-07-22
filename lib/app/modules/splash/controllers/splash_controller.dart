import 'package:universal_webview/app/data/constants.dart';
import 'package:universal_webview/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Future<void> navigateToHome() async {
    await Future.delayed(
            const Duration(seconds: Constants.splashDurationSeconds))
        .then((value) {
      Get.offAndToNamed(Routes.HOME);
    });
  }
}
