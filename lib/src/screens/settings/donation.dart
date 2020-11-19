import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class Donation extends StatefulWidget {
  @override
  DonationState createState() => DonationState();
}

class DonationState extends State<Donation> {
  AdmobBannerSize bannerSize;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9598646327425938/3640376898';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9598646327425938/6983713779';
      //return 'ca-app-pub-3940256099942544/6300978111'; //test
    }
    return null;
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _title = Container(
        padding: EdgeInsets.all(20),
        color: AppColors.greenPoint.withOpacity(0.1),
        width: MediaQuery.of(context).copyWith().size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.of(context).trans('donation_title'),
              style: TextStyle(
                color: AppColors.yellowishGreenDarker,
                fontSize: 20,
                fontFamily: '12LotteMartHappy',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              Translations.of(context).trans('donation_subtitle'),
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 16,
              ),
            )
          ],
        ));
/* 
    final _donation1 = Container(
      padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Translations.of(context).trans('donation_way', param1: '1'),
                style: TextStyle(
                  color: AppColors.greenPoint,
                  fontSize: 17,
                  fontFamily: '12LotteMartHappy',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: AppColors.greenPoint.withOpacity(0.3),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Translations.of(context).trans('donation_account_title'),
            style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            CommonSettings.donationAccount,
            style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
 */
    final _donation2 = Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Translations.of(context).trans('donation_way', param1: ''),
                style: TextStyle(
                  color: AppColors.greenPoint,
                  fontSize: 17,
                  fontFamily: '12LotteMartHappy',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: AppColors.greenPoint.withOpacity(0.3),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Translations.of(context).trans('donation_way_2_content'),
            style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );

    final _adBanner = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AdmobBanner(
          adUnitId: getBannerAdUnitId(),
          adSize: bannerSize,
          listener: (AdmobAdEvent event, Map<String, dynamic> args) {
            //handleEvent(event, args, 'Banner');
          },
          onBannerCreated: (AdmobBannerController controller) {
            // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
            // Normally you don't need to worry about disposing this yourself, it's handled.
            // If you need direct access to dispose, this is your guy!
            // controller.dispose();
          },
        )
      ],
    );

    return Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.white,
      appBar:
          appBarComponent(context, Translations.of(context).trans('donation')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_title, _donation2, _adBanner],
      ),
    );
  }

  @override
  void initState() {
    bannerSize = AdmobBannerSize.BANNER;
    super.initState();
  }

  @override
  void dispose() {
    //_bannerAd?.dispose();
    super.dispose();
  }
}
