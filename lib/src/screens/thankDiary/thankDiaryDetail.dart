import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryWrite.dart';

class ThankDiaryDetail extends StatefulWidget {
  final Diary diary;
  final User loginUser;
  ThankDiaryDetail({this.diary, this.loginUser});

  @override
  ThankDiaryDetailState createState() => ThankDiaryDetailState();
}

class ThankDiaryDetailState extends State<ThankDiaryDetail> {
  Diary detailDiary = new Diary();
  String _title = '';
  //String _imageURL;
  String _text = '';
  String _subject = '';
  bool _isLoading = false;
  static GlobalKey previewContainer = GlobalKey();

  Future<void> getThankDiary() async {
    try {
      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      await API.transaction(context, API.thanksDiaryDetail, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'thankDiarySeqNo': widget.diary.seqNo,
        'diaryDate': widget.diary.diaryDate,
        'language': CommonSettings.language,
      }).then((response) {
        setState(() {
          _isLoading = false;
        });
        Diary diary = Diary.fromJson(json.decode(response));
        List<Diary> tempList;
        if (diary.detail.length != 0) {
          tempList =
              diary.detail.map((model) => Diary.fromJson(model)).toList();
          setState(() {
            detailDiary = tempList[0];
            _setContents();
          });
        } else {
          showAlertDialog(
                  context, Translations.of(context).trans('no_data_detail'))
              .then((value) => Navigator.pop(context));
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

  void _setContents() {
    if (detailDiary.title != null && detailDiary.title != '') {
      _title = detailDiary.title;
    } else {
      _title = detailDiary.categoryTitle;
    }

    // Set share items
    /*  if (detailDiary.imageURL != null) {
      _imageURL = API.diaryImageURL + detailDiary.imageURL;
    } */

    _subject = '[' +
        getDateOfWeek(DateTime.parse(detailDiary.diaryDate)) +
        '] ' +
        detailDiary.title;

    _text = detailDiary.content;
  }

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ThankDiaryWrite(diary: detailDiary)))
        .then((value) {
      if (value == 'delete') {
        Navigator.pop(context);
      } else {
        setState(() {
          detailDiary = value;
          getThankDiary();
        });
      }
    });
  }

  Widget actionIcon() {
    return TextButton(
      child: Text(
        Translations.of(context).trans('edit'),
        style: TextStyle(color: AppColors.darkGray),
      ),
      onPressed: _goQtRecordWrite,
    );
  }

  Future<Null> _screenShotAndShare() async {
    try {
      RenderRepaintBoundary boundary =
          previewContainer.currentContext.findRenderObject();
      /*  if (boundary.debugNeedsPaint) {
        Timer(Duration(seconds: 1), () => _screenShotAndShare());
        return null;
      } */
      ui.Image image = await boundary.toImage();

      setState(() {
        _isLoading = true;
      });
      final directory = (await getExternalStorageDirectory()).path;
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      List<String> imageLocalPath = ['$directory/screenshot.png'];
      final RenderBox box = context.findRenderObject();

      setState(() {
        _isLoading = false;
      });
      Share.shareFiles(imageLocalPath,
          subject: _subject,
          text: _text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } on PlatformException catch (e) {
      print("Exception while taking screenshot:" + e.toString());
    }
  }

  void _share(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
/* 
    if (detailDiary.imageURL != null && detailDiary.imageURL != '') {
      setState(() {
        _isLoading = true;
      });
      var response = await get(_imageURL);
      final documentDirectory = (await getExternalStorageDirectory()).path;
      File imgFile = new File('$documentDirectory/${detailDiary.imageURL}');
      imgFile.writeAsBytesSync(response.bodyBytes);
      List<String> imageLocalPath = [
        '$documentDirectory/${detailDiary.imageURL}'
      ];
      setState(() {
        _isLoading = false;
      });

      await Share.shareFiles(imageLocalPath,
          text: _text,
          subject: _subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else { */
    await Share.share(_text,
        subject: _subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    //  }
  }

  @override
  Widget build(BuildContext context) {
    final _categoryIcon = detailDiary.categoryImageUrl != null
        ? FadeInImage.assetNetwork(
            image: API.systemImageURL + detailDiary.categoryImageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.fill,
            placeholder: wrongImage())
        : Container();

    final _diaryDate = detailDiary.diaryDate != null
        ? SelectableText(
            getDateOfWeek(DateTime.parse(detailDiary.diaryDate)),
            style: TextStyle(color: AppColors.darkGray),
          )
        : Container();

    final _diaryTitle = SelectableText(
      _title,
      style: TextStyle(color: AppColors.black, fontSize: 18),
    );

    final _image = Visibility(
        visible: detailDiary.imageURL == null || detailDiary.imageURL == ''
            ? false
            : true,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage.assetNetwork(
                fit: BoxFit.fill,
                placeholder: wrongImage(),
                image: API.diaryImageURL +
                    (detailDiary.imageURL == null
                        ? ''
                        : detailDiary.imageURL))));

    final _shareButton = IconButton(
        icon: Icon(
          Icons.ios_share,
          color: AppColors.pastelPink,
        ),
        onPressed: () {
          if (detailDiary.imageURL != null && detailDiary.imageURL != '') {
            if (Platform.isAndroid) {
              _screenShotAndShare();
            } else {
              _share(context);
            }
          } else {
            _share(context);
          }
        });

    final _diaryContent = detailDiary.content != null
        ? Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            constraints: BoxConstraints(minHeight: 100),
            child: SelectableText(detailDiary.content))
        : Container();

    return Scaffold(
        backgroundColor: AppColors.lightPinks,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_thank_diary'),
            actionWidget: actionIcon()),
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: SingleChildScrollView(
                child: RepaintBoundary(
              key: previewContainer,
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: [
                        _categoryIcon,
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _diaryDate,
                                _shareButton,
                              ],
                            ),
                            _diaryTitle,
                          ],
                        ))
                      ],
                    ),
                    Divider(
                      color: AppColors.pastelPink,
                    ),
                    _image,
                    _diaryContent
                  ],
                ),
              ),
            ))));
  }

  @override
  void initState() {
    getThankDiary();
    super.initState();
  }
}
