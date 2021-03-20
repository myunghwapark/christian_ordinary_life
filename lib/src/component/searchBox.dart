import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/thankDiaryInfo.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:christian_ordinary_life/src/model/Search.dart';
import 'package:christian_ordinary_life/src/model/ThankCategory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBox extends StatefulWidget {
  static Search search = new Search();

  final Color pointColor;
  final FocusNode searchFieldNode;
  final TextEditingController keywordController;
  final GestureTapCallback onSubmitted;
  final bool thankCategoryVisible;
  final GlobalKey scaffoldKey;
  final double topPadding;

  SearchBox(
      {this.pointColor,
      this.onSubmitted,
      this.searchFieldNode,
      this.keywordController,
      this.thankCategoryVisible,
      this.scaffoldKey,
      this.topPadding});
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  ComponentStyle componentStyle = new ComponentStyle();
  List<ThankCategory> thankCategoryList = [];
  DateTime searchStartDay;
  DateTime searchEndDay;
  String searchStartDayForm = '';
  String searchEndDayForm = '';
  bool _searchSettingVisible = false;
  bool _searchDateVisible = false;
  bool _dateSearch = true;
  final _formKey = GlobalKey<FormState>();
  ThankCategory _selectedCategory = ThankCategory();
  AppButtons appButtons = new AppButtons();

  void _setDefaultDate() {
    setState(() {
      searchStartDay = DateTime.now().add(new Duration(days: -30));
      searchEndDay = DateTime.now();
      searchStartDayForm = getCalDateFormat(searchStartDay);
      searchEndDayForm = getCalDateFormat(searchEndDay);
      SearchBox.search.searchByCategory = false;
      SearchBox.search.searchByDate = false;
    });
  }

  void _setDate(String target, DateTime selectedDate) {
    setState(() {
      if (target == 'start') {
        searchStartDay = selectedDate;
        searchStartDayForm = getCalDateFormat(searchStartDay);
      } else {
        searchEndDay = selectedDate;
        searchEndDayForm = getCalDateFormat(searchEndDay);
      }
    });
  }

  bool _checkDate() {
    if (_selectedCategory == null ||
        _selectedCategory.categoryNo == null ||
        _selectedCategory.categoryNo == '0') {
      SearchBox.search.searchByCategory = false;
    } else {
      SearchBox.search.searchByCategory = true;
      SearchBox.search.categoryNo = _selectedCategory.categoryNo;
    }

    if (_dateSearch) {
      SearchBox.search.searchByDate = false;
    } else {
      SearchBox.search.searchByDate = true;
      SearchBox.search.searchStartDate = searchStartDay.toString();
      SearchBox.search.searchEndDate = searchEndDay.toString();
    }

    final differenceInDays = searchStartDay.difference(searchEndDay).inDays;
    if (!_dateSearch && differenceInDays > 0) {
      showToast(context, Translations.of(context).trans('query_date_wrong'));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final _searchBox = Expanded(
      child: Container(
          height: 57,
          padding: EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
          child: TextField(
            controller: widget.keywordController,
            focusNode: widget.searchFieldNode,
            onSubmitted: (value) {
              if (_checkDate()) widget.onSubmitted();
            },
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.pointColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              contentPadding: EdgeInsets.all(8),
              labelText: Translations.of(context).trans('search'),
              hintText: Translations.of(context).trans('search'),
              prefixIcon: Icon(
                Icons.search,
                color: widget.searchFieldNode.hasFocus
                    ? Colors.blue
                    : widget.pointColor,
              ),
              suffixIcon: IconButton(
                onPressed: () => widget.keywordController.clear(),
                icon: Icon(Icons.clear),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          )),
    );

    final _dropDownButton = Container(
      child: GestureDetector(
          onTap: () {
            setState(() {
              _searchSettingVisible = !_searchSettingVisible;
            });
          },
          child: Icon(
            _searchSettingVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: widget.pointColor,
          )),
    );

    final _calendarIcon = Icon(
      FontAwesomeIcons.calendarAlt,
      color: Colors.white,
    );

    final _dateLabel = Text(
      Translations.of(context).trans('all_periods'),
      style: TextStyle(color: Colors.white),
    );

    final _dateSwitchButton = Switch(
      value: _dateSearch,
      onChanged: (value) {
        setState(() {
          _dateSearch = value;
          _searchDateVisible = !value;
        });
      },
      activeTrackColor: Colors.white,
      activeColor: widget.pointColor,
    );

    final _searchStartDate = GestureDetector(
      child: Container(
          decoration: componentStyle.radius5(),
          padding: EdgeInsets.all(7),
          child: Text(
            searchStartDayForm,
          )),
      onTap: () {
        showCalendar(context, searchStartDay, widget.topPadding).then((result) {
          if (result != null) _setDate('start', result);
        });
      },
    );

    final _dash = Container(
      padding: EdgeInsets.all(10),
      child: Text(
        '-',
        style: TextStyle(color: Colors.white),
      ),
    );

    final _searchEndDate = GestureDetector(
      child: Container(
          decoration: componentStyle.radius5(),
          padding: EdgeInsets.all(7),
          child: Text(
            searchEndDayForm,
          )),
      onTap: () {
        showCalendar(context, searchEndDay, widget.topPadding).then((result) {
          if (result != null) _setDate('end', result);
        });
      },
    );

    final _categoryIcon = Icon(
      Icons.category,
      color: Colors.white,
    );

    final _categoryLabel =
        Text(Translations.of(context).trans('audit_classification'),
            style: TextStyle(
              color: Colors.white,
            ));

    Widget _thankDropdownButton() {
      return Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: Colors.white, style: BorderStyle.solid, width: 0.80),
              color: Colors.white),
          child: DropdownButton(
            hint: (_selectedCategory == null ||
                    _selectedCategory.categoryNo == null ||
                    _selectedCategory.categoryNo == '0')
                ? Text(Translations.of(context).trans('all_category'))
                : Row(children: [
                    FadeInImage.assetNetwork(
                      image: API.systemImageURL +
                          _selectedCategory.categoryImageUrl,
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                      placeholder: wrongImage(),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _selectedCategory.categoryTitle,
                      style: TextStyle(color: AppColors.darkGray),
                    )
                  ]),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: AppColors.darkGray),
            underline: SizedBox.shrink(),
            items: ThankDiaryInfo.thankCategoryDropbox.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val.categoryNo,
                  child: Row(
                    children: [
                      val.categoryImageUrl != null
                          ? FadeInImage.assetNetwork(
                              image: API.systemImageURL + val.categoryImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                              placeholder: wrongImage(),
                            )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      Text(val.categoryTitle)
                    ],
                  ),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _selectedCategory =
                      ThankDiaryInfo.thankCategoryDropbox[int.parse(val)];
                },
              );
            },
          ));
    }

    return Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_searchBox, _dropDownButton],
            ),
            Visibility(
                visible: _searchSettingVisible,
                child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _calendarIcon,
                              SizedBox(
                                width: 7,
                              ),
                              _dateLabel,
                              _dateSwitchButton,
                            ],
                          ),
                        ),
                        Visibility(
                            visible: _searchDateVisible,
                            child: Container(
                                margin: EdgeInsets.only(left: 3),
                                child: Row(
                                  children: [
                                    _searchStartDate,
                                    _dash,
                                    _searchEndDate,
                                  ],
                                ))),
                        Visibility(
                          visible: widget.thankCategoryVisible,
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  _categoryIcon,
                                  SizedBox(
                                    width: 7,
                                  ),
                                  _categoryLabel,
                                ],
                              )),
                        ),
                        Visibility(
                          visible: widget.thankCategoryVisible,
                          child: _thankDropdownButton(),
                        ),
                        appButtons.filledWhiteCustomButton(
                            Translations.of(context)
                                .trans('search_with_criteria'), () {
                          hideKeyboard(context);
                          if (_checkDate()) widget.onSubmitted();
                        }, widget.pointColor)
                      ],
                    )))
          ],
        ));
  }

  @override
  void initState() {
    _setDefaultDate();

    super.initState();
  }
}
