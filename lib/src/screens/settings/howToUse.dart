import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:flutter/material.dart';

class HowToUse extends StatefulWidget {
  @override
  HowToUseState createState() => HowToUseState();
}

class HowToUseState extends State<HowToUse> {
  int _index = 0;
  PageController _pageController = PageController(viewportFraction: 0.9);
  List<Widget> _titleList = new List<Widget>();

  void nextPage() {
    _pageController.animateToPage(_pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Widget _title1() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Translations.of(context).trans('app_title1'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('app_title2'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                    Text(
                      Translations.of(context).trans('app_title3'),
                      style:
                          TextStyle(color: AppColors.blackGreen, fontSize: 20),
                    ),
                    Text(
                      Translations.of(context).trans('app_title4'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                    Text(
                      Translations.of(context).trans('app_title5'),
                      style:
                          TextStyle(color: AppColors.blackGreen, fontSize: 20),
                    ),
                    Text(
                      Translations.of(context).trans('app_title6'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                    Text(
                      Translations.of(context).trans('is'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                  ],
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(Translations.of(context)
                        .trans('how_to_use_1_subtitle')))
              ],
            )));
  }

  Widget _title2() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Translations.of(context).trans('how_to_use_2_title_1'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_2_title_2'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_2_title_3'),
                      style:
                          TextStyle(color: AppColors.blackGreen, fontSize: 20),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_2_title_4'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                  ],
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(Translations.of(context)
                        .trans('how_to_use_2_subtitle')))
              ],
            )));
  }

  Widget _title3() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Translations.of(context).trans('how_to_use_3_title_1'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_3_title_2'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 20),
                    ),
                  ],
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(Translations.of(context)
                        .trans('how_to_use_3_subtitle')))
              ],
            )));
  }

  Widget _title4() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Translations.of(context).trans('how_to_use_4_title_1'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_4_title_2'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 20),
                    ),
                  ],
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(Translations.of(context)
                        .trans('how_to_use_4_subtitle')))
              ],
            )));
  }

  Widget _title5() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Translations.of(context).trans('how_to_use_5_title_1'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_5_title_2'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 20),
                    ),
                  ],
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(Translations.of(context)
                        .trans('how_to_use_5_subtitle')))
              ],
            )));
  }

  Widget _title6() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Translations.of(context).trans('how_to_use_6_title_1'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_6_title_2'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_6_title_3'),
                      style: TextStyle(
                        color: AppColors.blackGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      Translations.of(context).trans('how_to_use_6_title_4'),
                      style:
                          TextStyle(color: AppColors.greenPoint, fontSize: 18),
                    ),
                  ],
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(Translations.of(context)
                        .trans('how_to_use_6_subtitle')))
              ],
            )));
  }

  Widget _phoneImage(int number) {
    return Positioned(
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Spacer(),
                Image.network(
                  API.systemImageURL +
                      (number == 1
                          ? "how_to_use1.jpg"
                          : "how_to_use" +
                              number.toString() +
                              "_" +
                              CommonSettings.language +
                              ".jpg"),
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).copyWith().size.width - 120,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    _titleList = [
      _title1(),
      _title2(),
      _title3(),
      _title4(),
      _title5(),
      _title6()
    ];
    final _cloudBg = Positioned.fill(
      child: Image.network(
        API.systemImageURL + "cloud_bg.jpg",
        fit: BoxFit.fitWidth,
        alignment: Alignment.topLeft,
      ),
    );

    final _closeButton = Positioned(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          child: Text(Translations.of(context).trans('close')),
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: AppColors.darkGray,
        )
      ],
    ));

    final _pageMoveButtons = Positioned(
      child: Center(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _index != 0
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[300],
                  ),
                  onPressed: previousPage)
              : Container(),
          _index != 5
              ? IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.grey[300]),
                  onPressed: nextPage)
              : Container()
        ],
      )),
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
          height:
              MediaQuery.of(context).copyWith().size.height - 20, // card height
          child: PageView.builder(
            itemCount: 6,
            controller: _pageController,
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (context, i) {
              return Transform.scale(
                  scale: i == _index ? 1 : 0.9,
                  child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Stack(
                        children: <Widget>[
                          _cloudBg,
                          _titleList[i],
                          _phoneImage(i + 1),
                          _pageMoveButtons,
                          _closeButton,
                        ],
                      )));
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
