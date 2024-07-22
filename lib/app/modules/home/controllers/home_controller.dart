import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_webview/app/data/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final InAppReview inAppReview = InAppReview.instance;

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
          backgroundColor: Colors.black,
          colorText: Colors.white,
          borderRadius: 4,
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.amber,
          ),
        );
        return false;
      }
      return true;
    }
  }

  void onActionItemHomeTap() {
    webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri.uri(
          Uri.parse(Constants.baseUrl),
        ),
      ),
    );
    webViewController?.clearHistory();
  }

  Future<void> onActionItemShareTapped() async {
    final url = await webViewController?.getUrl();
    if (url != null) {
      await Share.share(url.toString());
    }
  }

  Future<void> openAppStore() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.openStoreListing(
        appStoreId: Constants.iosAppstoreId,
      );
    } else {
      final url = Uri.parse(Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=${Constants.androidPackageName}'
          : 'https://apps.apple.com/app/id${Constants.iosAppstoreId}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    }
  }

  void onActionItemRefreshTapped() {
    webViewController?.reload();
  }

  void onExitApp() {
    Get.dialog(
      AlertDialog(
        content: const Text('Are you sure want to exit app ?'),
        title: const Text('Confirm Exit'),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Ok'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInCubic,
    );
  }
}
