import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
    javaScriptEnabled: true,
    useShouldOverrideUrlLoading: true,
    useHybridComposition: true,
    cacheEnabled: true,
    useOnLoadResource: true,
    allowFileAccessFromFileURLs: true,
    allowUniversalAccessFromFileURLs: true,
  );

  PullToRefreshController? pullToRefreshController;
  var url = '';
  var progress = 0.0.obs;
  final urlController = TextEditingController();
  final RxBool canGoBack = false.obs;
  final RxString currentUrl = ''.obs;
  DateTime? lastBackPressTime;

  @override
  void onInit() {
    super.onInit();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  void updateCanGoBack(bool value) {
    canGoBack.value = value;
  }

  void updateCurrentUrl(String url) {
    currentUrl.value = url;
  }

  Future<bool> onWillPop() async {
    if (canGoBack.value) {
      webViewController?.goBack();
      return false;
    } else {
      final now = DateTime.now();
      if (lastBackPressTime == null ||
          now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
        lastBackPressTime = now;
        Get.snackbar(
          'Exit App',
          'Press back again to exit',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }
      return true;
    }
  }
}
