import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  PrivcyPolicyState createState() => PrivcyPolicyState();
}

class PrivcyPolicyState extends State<PrivacyPolicy> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarComponent(
            context, Translations.of(context).trans('privacy_policy')),
        body: SafeArea(
            bottom: true,
            child: LoadingOverlay(
                isLoading: _isLoading,
                opacity: 0.5,
                progressIndicator: CircularProgressIndicator(),
                color: Colors.black,
                child: WebView(
                  initialUrl: API.privacyPolicy +
                      '?language=' +
                      CommonSettings.language,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  gestureNavigationEnabled: true,
                  onPageFinished: (finish) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ))));
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
}
