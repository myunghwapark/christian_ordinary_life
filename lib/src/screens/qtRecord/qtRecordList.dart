import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/component/searchBox.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordDetail.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class QTRecord extends StatefulWidget {
  static const routeName = '/qtRecord';

  @override
  QTRecordState createState() => QTRecordState();
}

class QTRecordState extends State<QTRecord> {
  var qtList = [];
  QT qt = new QT();
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

  Future<void> getQtRecordList() async {
    _startPageNum = _pageNum * _rowCount;

    if (!initLoad && _startPageNum >= _totalCnt) {
      _refreshController.loadNoData();
      return null;
    } else {
      _refreshController.resetNoData();
    }

    String _searchStartDate = '';
    String _searchEndDate = '';

    if (SearchBox.search.searchByDate) {
      _searchStartDate = SearchBox.search.searchStartDate;
      _searchEndDate = SearchBox.search.searchEndDate;
    }
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    if (!initLoad) hideKeyboard(context);

    try {
      await API.transaction(context, API.qtRecordList, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'searchKeyword': keyWord,
        'searchStartDate': _searchStartDate,
        'searchEndDate': _searchEndDate,
        'startPageNum': _startPageNum,
        'rowCount': _rowCount
      }).then((response) {
        qt = QT.fromJson(json.decode(response));
        _totalCnt = qt.totalCnt;

        setState(() {
          _isLoading = false;
          List<QT> tempList;
          tempList = qt.qtList.map((model) => QT.fromJson(model)).toList();
          for (int i = 0; i < tempList.length; i++) {
            qtList.add(tempList[i]);
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

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => QtRecordWrite()))
        .then((value) {
      setState(() {
        _refresh();
      });
    });
  }

  Widget actionIcon() {
    return TextButton(
      child: Text(
        Translations.of(context).trans('write'),
        style: TextStyle(color: AppColors.darkGray),
      ),
      onPressed: _goQtRecordWrite,
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

    qtList = [];
    getQtRecordList();
  }

  void _load() {
    _scrollUp = false;
    getQtRecordList();
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
          builder: (c, m) {
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

    final _qtTotalCount = Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(Translations.of(context)
              .trans('total_count', param1: _totalCnt.toString()))
        ]));

    final _qtList = ListView.separated(
        itemCount: qtList?.length,
        separatorBuilder: (context, index) {
          if (index == 0) return SizedBox.shrink();
          return const Divider();
        },
        itemBuilder: (context, index) {
          QT curQt = qtList[index];
          return /* Dismissible(
            key: UniqueKey(),
            child:  */
              GestureDetector(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          (curQt.bible != null && curQt.bible != '')
                              ? '[${curQt.bible}] ${curQt.title}'
                              : curQt.title,
                          style:
                              TextStyle(color: AppColors.black, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                    Container(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          getDate(DateTime.parse(curQt.qtDate)),
                          style: TextStyle(color: AppColors.greenPointMild),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                    Text(
                      curQt.content,
                      style: TextStyle(color: AppColors.darkGray),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  ],
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QtRecordDetail(
                        qt: curQt, loginUser: UserInfo.loginUser)),
              ).then((value) {
                setState(() {
                  _refresh();
                });
              });
            },
          );
        });

    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_qt_record'),
            actionWidget: actionIcon()),
        drawer: AppDrawer(),
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: Column(children: <Widget>[
              SearchBox(
                  pointColor: AppColors.marine,
                  searchFieldNode: _searchFieldNode,
                  keywordController: keywordController,
                  onSubmitted: _onSubmitted,
                  thankCategoryVisible: false,
                  topPadding: MediaQuery.of(context).padding.top),
              _qtTotalCount,
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
                    : _qtList,
              ))
            ])));
  }

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
    SearchBox.search.searchByDate = false;
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
