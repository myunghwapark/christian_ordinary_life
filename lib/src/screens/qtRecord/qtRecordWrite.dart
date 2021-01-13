import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:christian_ordinary_life/src/component/customTextfieldToolBar.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';

class QtRecordWrite extends StatefulWidget {
  final QT qt;
  const QtRecordWrite({this.qt});

  @override
  QtRecordWriteStatus createState() => QtRecordWriteStatus();
}

class QtRecordWriteStatus extends State<QtRecordWrite>
    with SingleTickerProviderStateMixin {
  QT newQt = new QT();
  UserInfo userInfo = new UserInfo();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  final TextEditingController _bibleController = new TextEditingController();
  FocusNode _focus = new FocusNode();
  AnimationController _controller;
  Animation _animation;
  AppButtons buttons = new AppButtons();

  ComponentStyle componentStyle = new ComponentStyle();

  String qtDateForm = '';
  DateTime qtDate = new DateTime.now();
  bool _trashVisibility = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  void _writeQT() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await API.transaction(context, API.qtRecordWrite, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'qtRecordSeqNo': newQt.seqNo,
        'title': newQt.title,
        'qtDate': newQt.qtDate,
        'bible': newQt.bible,
        'content': newQt.content,
        'qtRecord': 'y',
        'goalDate': newQt.qtDate
      }).then((response) {
        setState(() {
          _isLoading = false;
        });

        QT writeResult = QT.fromJson(json.decode(response));
        if (writeResult.result == 'success') {
          Navigator.pop(context, newQt);
        } else {
          errorMessage(context, newQt.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _delete() async {
    try {
      final confirmResult = await showConfirmDialog(
          context, Translations.of(context).trans('delete_confirm'));

      if (confirmResult == 'ok') {
        setState(() {
          _isLoading = true;
        });
        await API.transaction(context, API.qtRecordDelete, param: {
          'userSeqNo': UserInfo.loginUser.seqNo,
          'qtRecordSeqNo': widget.qt.seqNo
        }).then((response) {
          setState(() {
            _isLoading = false;
          });

          QT deleteResult = QT.fromJson(json.decode(response));
          if (deleteResult.result == 'success') {
            Navigator.pop(context, 'delete');
          } else {
            errorMessage(context, newQt.errorMessage);
          }
        });
      }
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(
        Translations.of(context).trans('save'),
        style: TextStyle(color: AppColors.darkGray),
      ),
      onPressed: () {
        if (_formCheck()) {
          newQt = new QT(
              seqNo: newQt != null ? newQt.seqNo : null,
              title: _titleController.text,
              content: _contentController.text,
              bible: _bibleController.text,
              qtDate: qtDate.toString());

          hideKeyboard(context);
          _writeQT();
        }
      },
      textColor: AppColors.darkGray,
    );
  }

  _setQtRecord() {
    newQt = widget.qt;
    _titleController.text = widget.qt.title;
    _bibleController.text = widget.qt.bible;
    _contentController.text = widget.qt.content;
    qtDate = DateTime.parse(widget.qt.qtDate);
  }

  void _setDate(DateTime selectedDate) {
    setState(() {
      qtDate = selectedDate;
      qtDateForm = getDateOfWeek(qtDate);
    });
  }

  Future<bool> _androidBackKeyEvent() async {
    if (_keyboardState) {
      FocusScope.of(context).requestFocus(new FocusNode());
    } else {
      Navigator.pop(context, widget.qt);
    }
    return false;
  }

  bool _formCheck() {
    if (_titleController.text.isEmpty) {
      hideKeyboard(context);
      showToast(_scaffoldKey, Translations.of(context).trans('validate_title'));
      return false;
    } else if (_contentController.text.isEmpty) {
      hideKeyboard(context);
      showToast(
          _scaffoldKey, Translations.of(context).trans('validate_content'));
      return false;
    } else {
      return true;
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'': ''},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    if (widget.qt != null) {
      _setQtRecord();
      _trashVisibility = true;
    } else {
      _trashVisibility = false;
    }
    qtDateForm = getDateOfWeek(qtDate);

    /* Content scroll event start */
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 50.0, end: 350.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focus.addListener(() {
      if (_focus.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    /* Content scroll event end */

    /* Check keyboard visible for Android back button event */
    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
        });
      },
    );

    userInfo.checkLoginServer(context);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _bibleController.dispose();
    _controller.dispose();
    _focus.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _calendarButton = Container(
        padding: EdgeInsets.only(right: 5),
        child: IconButton(
          icon: Icon(Icons.calendar_today),
          color: AppColors.marine,
          onPressed: () {
            showCalendar(context, qtDate, MediaQuery.of(context).padding.top)
                .then((result) {
              if (result != null) _setDate(result);
            });
          },
        ));

    final _qtDate = Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        child: Text(
          qtDateForm,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          showCalendar(context, qtDate, MediaQuery.of(context).padding.top)
              .then((result) {
            if (result != null) _setDate(result);
          });
        },
      ),
    );

    final _todaysQt = buttons
        .outerlineMintButton(Translations.of(context).trans('todays_qt'), () {
      String url;
      if (CommonSettings.language == 'ko') {
        url = API.qtLinkSwim + getCalDateFormat(qtDate);
      } else {
        url = API.qtLinkWordforToday;
      }
      _launchInBrowser(url);
    });

    final _deleteButton = Visibility(
        visible: _trashVisibility,
        child: Container(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.trash),
              color: AppColors.lightGray,
              onPressed: _delete,
            )));

    final _qtTitle = Container(
      padding: EdgeInsets.all(12),
      height: 90,
      child: CustomTextField(
        enableInteractiveSelection: true,
        textAlignVertical: TextAlignVertical.center,
        decoration: componentStyle
            .whiteGreyInput(Translations.of(context).trans('title_hint')),
        controller: _titleController,
        keyboardType: TextInputType.text,
        maxLength: 80,
        /* validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_title');
          }
          return null;
        }, */
      ),
    );

    final _qtBible = Container(
      padding: EdgeInsets.all(12),
      height: 90,
      child: CustomTextField(
        enableInteractiveSelection: true,
        textAlignVertical: TextAlignVertical.center,
        decoration: componentStyle
            .whiteGreyInput(Translations.of(context).trans('qt_bible_hint')),
        controller: _bibleController,
        keyboardType: TextInputType.text,
        maxLength: 30,
      ),
    );

    final _qtContent = Container(
        padding: EdgeInsets.all(12),
        child: CustomTextField(
          enableInteractiveSelection: true,
          textAlignVertical: TextAlignVertical.top,
          keyboardType: TextInputType.multiline,
          minLines: 10,
          maxLines: 100,
          decoration: componentStyle
              .whiteGreyInput(Translations.of(context).trans('qt_hint')),
          controller: _contentController,
          maxLength: 5000,
          focusNode: _focus,
          /* validator: (value) {
            if (value.isEmpty) {
              return Translations.of(context).trans('validate_content');
            }
            return null;
          }, */
        ));

    return WillPopScope(
        onWillPop: _androidBackKeyEvent,
        child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            //resizeToAvoidBottomPadding: false,
            backgroundColor: AppColors.lightSky,
            appBar: appBarBack(
                context, Translations.of(context).trans('menu_qt_record'),
                actionWidget: actionIcon(),
                onBackTap: () => Navigator.pop(context, widget.qt)),
            body: LoadingOverlay(
                isLoading: _isLoading,
                opacity: 0.5,
                progressIndicator: CircularProgressIndicator(),
                color: Colors.black,
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(10),
                        child: new Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                _calendarButton,
                                _qtDate,
                                _todaysQt,
                                _deleteButton,
                              ],
                            ),
                            _qtTitle,
                            _qtBible,
                            _qtContent,
                            Platform.isAndroid
                                ? SizedBox(height: _animation.value)
                                : Container(),
                          ],
                        ))))));
  }
}
