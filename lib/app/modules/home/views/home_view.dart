import 'package:universal_webview/app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await controller.onWillPop();
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.appThemeColor,
          title: const Text(
            Constants.appName,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: controller.onActionItemHomeTap,
              icon: const Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: controller.onActionItemShareTapped,
              icon: const Icon(Icons.share, color: Colors.white),
            ),
            PopupMenuButton<int>(
              iconColor: Colors.white,
              onSelected: (item) {},
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  onTap: controller.openAppStore,
                  child: const Row(
                    children: [
                      Icon(Icons.star_purple500),
                      SizedBox(width: 10),
                      Text('Rate App'),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  onTap: controller.onActionItemRefreshTapped,
                  child: const Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 10),
                      Text('Refresh'),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  onTap: controller.onExitApp,
                  child: const Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 10),
                      Text('Exit App'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: controller.webViewKey,
                    initialUrlRequest:
                        URLRequest(url: WebUri(Constants.baseUrl)),
                    initialSettings: controller.settings,
                    pullToRefreshController: controller.pullToRefreshController,
                    onWebViewCreated: (wkController) {
                      controller.webViewController = wkController;
                    },
                    onLoadStart: (controller, url) {},
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    onLoadStop: (wkController, url) async {
                      wkController.canGoBack().then((value) {
                        controller.updateCanGoBack(value);
                      });
                      if (url != null) {
                        controller.updateCurrentUrl(url.toString());
                      }
                      controller.pullToRefreshController?.endRefreshing();
                    },
                    onReceivedError: (wkController, request, error) {
                      controller.pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (wkController, progress) {
                      if (progress == 100) {
                        controller.pullToRefreshController?.endRefreshing();
                      }

                      controller.progress.value = progress / 100;
                    },
                    onUpdateVisitedHistory:
                        (wkController, url, androidIsReload) {
                      // setState(() {
                      //   this.url = url.toString();
                      //   urlController.text = this.url;
                      // });
                    },
                    onConsoleMessage: (wkController, consoleMessage) {
                      // if (kDebugMode) {
                      //   print(consoleMessage);
                      // }
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

                      // Handle WhatsApp links
                      if (uri.scheme == Constants.whatsappUrlScheme ||
                          uri
                              .toString()
                              .startsWith(Constants.whatsappUrlWame) ||
                          uri.toString().startsWith(Constants.whatsappUrlApi)) {
                        if (await launchExternalUrl(uri, 'WhatsApp')) {
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.CANCEL;
                      }

                      // Handle Telegram links
                      else if (uri.scheme == Constants.telegramUrlScheme ||
                          uri.toString().startsWith(Constants.telegramTMe)) {
                        if (await launchExternalUrl(uri, 'Telegram')) {
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.CANCEL;
                      }

                      // Handle Facebook links
                      else if (uri.toString().contains(Constants.facebookUrl) ||
                          uri.toString().contains(Constants.facebookUrlfbCom) ||
                          uri.scheme == 'fb') {
                        if (await launchExternalUrl(uri, 'Facebook')) {
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.CANCEL;
                      }

                      // Handle other external links
                      else if (!Constants.otherUrlMatchers
                          .contains(uri.scheme)) {
                        if (await launchExternalUrl(uri, 'The app')) {
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.CANCEL;
                      }

                      // Allow WebView to handle all other URLs
                      return NavigationActionPolicy.ALLOW;
                    },
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.progress.value < 1.0,
                      child: LinearProgressIndicator(
                        value: controller.progress.value.toDouble(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAppNotInstalledSnackbar(String appName) {
    Get.snackbar(
      'App Not Installed',
      '$appName is not installed on your device.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<bool> launchExternalUrl(Uri uri, String appName) async {
    try {
      final bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        showAppNotInstalledSnackbar(appName);
        return false;
      }
      return true;
    } catch (e) {
      showAppNotInstalledSnackbar(appName);
      return false;
    }
  }
}
