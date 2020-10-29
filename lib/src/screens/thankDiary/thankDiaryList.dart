import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/component/searchBox.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryDetail.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryWrite.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/thankDiaryInfo.dart';

class ThankDiary extends StatefulWidget {
  static const routeName = '/thankDiary';

  @override
  ThankDiaryState createState() => ThankDiaryState();
}

class ThankDiaryState extends State<ThankDiary> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ThankDiaryInfo thankDiaryInfo = new ThankDiaryInfo();
  var diaryList = new List<Diary>();
  Diary diary = new Diary();
  TextEditingController keywordController = TextEditingController();
  String keyWord = '';
  FocusNode _searchFieldNode = FocusNode();
  int _startPageNum = 0;
  int _pageNum = 0;
  int _rowCount = 10;
  int _totalCnt = 0;
  bool initLoad = true;
  RefreshController _refreshController;
  bool _scrollUp;
  bool _isLoading = false;

  Future<void> getThankDiaryList() async {
    _startPageNum = _pageNum * _rowCount;

    if (!initLoad && _startPageNum >= _totalCnt) {
      _refreshController.loadNoData();
      return null;
    } else {
      _refreshController.resetNoData();
    }

    String _searchStartDate = '';
    String _searchEndDate = '';
    String _categoryNo = '';
    if (SearchBox.search.searchByCategory) {
      _categoryNo = SearchBox.search.categoryNo;
    }
    if (SearchBox.search.searchByDate) {
      _searchStartDate = SearchBox.search.searchStartDate;
      _searchEndDate = SearchBox.search.searchEndDate;
    }

    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      await API.transaction(context, API.thanksDiaryList, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'searchKeyword': keyWord,
        'searchStartDate': _searchStartDate,
        'searchEndDate': _searchEndDate,
        'categoryNo': _categoryNo,
        'startPageNum': _startPageNum,
        'rowCount': _rowCount
      }).then((response) {
        diary = Diary.fromJson(json.decode(response));
        _totalCnt = diary.totalCnt;

        setState(() {
          _isLoading = false;

          List<Diary> tempList;
          tempList =
              diary.diaryList.map((model) => Diary.fromJson(model)).toList();
          for (int i = 0; i < tempList.length; i++) {
            diaryList.add(tempList[i]);
            if (diaryList[i].imageURL != null && diaryList[i].imageURL != '') {
              final theImage = Image.network(
                  API.diaryImageURL + diaryList[i].imageURL,
                  fit: BoxFit.cover);
              precacheImage(theImage.image, context);
            }
          }
        });
      });
    } on Exception catch (exception) {
      _errorHandle(exception);
    } catch (exception) {
      _errorHandle(exception);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    _pageNum++;
    initLoad = false;
    if (_scrollUp)
      _refreshController.refreshCompleted();
    else
      _refreshController.loadComplete();
  }

  Future<void> _goThankDiaryWrite() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => ThankDiaryWrite()))
        .then((value) {
      setState(() {
        _refresh();
      });
    });
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('write')),
      onPressed: _goThankDiaryWrite,
      textColor: AppColors.darkGray,
    );
  }

  void _errorHandle(Exception exception) {
    if (_scrollUp)
      _refreshController.refreshFailed();
    else
      _refreshController.loadFailed();

    errorMessage(context, exception);
  }

  void _refresh() {
    _scrollUp = true;
    _pageNum = 0;
    initLoad = true;

    diaryList = new List<Diary>();
    getThankDiaryList();
  }

  void _load() {
    _scrollUp = false;
    getThankDiaryList();
  }

  @override
  Widget build(BuildContext context) {
    GestureTapCallback _onSubmitted = () {
      setState(() {
        keyWord = keywordController.text;
        _refresh();
      });
    };

    Widget _header() {
      return CustomHeader(
          height: 60,
          refreshStyle: RefreshStyle.Behind,
          onOffsetChange: (offset) {},
          builder: (context, mode) {
            return Container(
              child: Image.asset(
                "assets/images/loading.gif",
              ),
            );
          });
    }

    Widget _footer() {
      return CustomFooter(
          height: 60,
          builder: (context, mode) {
            Widget child;
            switch (mode) {
              case LoadStatus.failed:
                child = Center(
                    child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          Translations.of(context).trans('load_fail_retry'),
                          style: TextStyle(color: Colors.grey[500]),
                        )));
                break;
              case LoadStatus.noMore:
                child = Center(
                    child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          Translations.of(context).trans('no_more_data'),
                          style: TextStyle(color: Colors.grey[500]),
                        )));
                break;
              default:
                child = Container(
                  child: Image.asset(
                    "assets/images/loading.gif",
                  ),
                );
                break;
            }

            return child;
          });
    }

    final _diaryList = ListView.separated(
        itemCount: diaryList?.length,
        separatorBuilder: (context, index) {
          if (index == 0) return SizedBox.shrink();
          return const Divider();
        },
        itemBuilder: (context, index) {
          Diary curDiary = diaryList[index];
          String imageURL = API.diaryImageURL + curDiary.imageURL;
          return GestureDetector(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    (curDiary.imageURL != null && curDiary.imageURL != '')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: FadeInImage.assetNetwork(
                              image: imageURL,
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                              placeholder: wrongImage(),
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.assetNetwork(
                              image: API.systemImageURL +
                                  curDiary.categoryImageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                              placeholder: wrongImage(),
                            )),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              curDiary.title,
                              style: TextStyle(
                                  color: AppColors.black, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                        Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              getDate(DateTime.parse(curDiary.diaryDate)),
                              style: TextStyle(color: AppColors.pastelPink),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                        Text(
                          curDiary.content,
                          style: TextStyle(color: AppColors.darkGray),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ))
                  ],
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ThankDiaryDetail(
                        diary: curDiary, loginUser: UserInfo.loginUser)),
              ).then((value) {
                setState(() {
                  _refresh();
                });
              });
            },
          );
        });

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.lightPinks,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_thank_diary'),
            actionWidget: actionIcon()),
        drawer: AppDrawer(),
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: Column(children: <Widget>[
              SearchBox(
                pointColor: AppColors.pastelPink,
                searchFieldNode: _searchFieldNode,
                keywordController: keywordController,
                onSubmitted: _onSubmitted,
                thankCategoryVisible: true,
                scaffoldKey: _scaffoldKey,
              ),
              Expanded(
                  child: SmartRefresher(
                header: _header(),
                footer: _footer(),
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: _refresh,
                onLoading: _load,
                child: _totalCnt == 0
                    ? Center(
                        child: Text(Translations.of(context).trans('no_data')),
                      )
                    : _diaryList,
              ))
            ])));
  }

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();

    SearchBox.search.searchByDate = false;
    SearchBox.search.searchByCategory = false;
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    thankDiaryInfo.getThankCategory(context).then((value) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
