import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/model/Bible.dart';
import 'package:christian_ordinary_life/src/model/BiblePlanDetail.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReadingBible extends StatefulWidget {
  static const routeName = '/readingBible';

  @override
  ReadingBibleState createState() => ReadingBibleState();
}

class ReadingBibleState extends State<ReadingBible> {
  ScrollController _scrollController = new ScrollController();
  BiblePlanDetail biblePlanDetail = new BiblePlanDetail();
  List<Bible> todaysBible = new List<Bible>();

  Widget _displayChapters(Bible bible) {
    return InkWell(
        child: Container(
      child: Text(bible.chapters.toString() +
          Translations.of(context).trans('chapter')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final _days = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              border: Border.all(color: AppColors.orange)),
          child: Text(
            Translations.of(context).trans('day_order', param1: '1'),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );

    final _chapterTitle = Container(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          Translations.of(context).trans('prov'),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ));

    final _todaysChapters = GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      children: todaysBible.map((Bible bible) {
        return Center(
          child: _displayChapters(bible),
        );
      }).toList(),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        body: new NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: new Text(
                  Translations.of(context).trans('menu_reading_bible'),
                  style: TextStyle(
                      color: AppColors.darkGray, fontWeight: FontWeight.bold),
                ),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Colors.white,
                iconTheme: new IconThemeData(
                  color: AppColors.lightGray,
                ),
              ),
            ];
          },
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(color: AppColors.orange)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_days, _chapterTitle, _todaysChapters],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50.0,
          width: 50.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(FontAwesomeIcons.arrowDown),
              backgroundColor: Colors.orange[300],
            ),
          ),
        ));
  }

  @override
  void initState() {
    biblePlanDetail.chapter =
        '[{"book": "lev", "volume": "4-7"}, {"book": "heb", "volume": "3"}]';
    biblePlanDetail.days = '2';
    //Bible bible = new Bible();
    print('UserInfo.loginUser seqNo: ${UserInfo.loginUser.seqNo}');

    super.initState();
  }
}
