import 'dart:async';
import 'dart:io';

import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivcyPolicyState createState() => PrivcyPolicyState();
}

class PrivcyPolicyState extends State<PrivacyPolicy> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarComponent(
            context, Translations.of(context).trans('privacy_policy')),
        body: WebView(
          initialUrl:
              API.privacyPolicy + '?language=' + CommonSettings.language,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          gestureNavigationEnabled: true,
        ));
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
}
