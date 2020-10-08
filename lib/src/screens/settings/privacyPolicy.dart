import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivcyPolicyState createState() => PrivcyPolicyState();
}

class PrivcyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarComponent(
            context, Translations.of(context).trans('privacy_policy')),
        body: Container());
  }
}
