import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'package:christian_ordinary_life/src/component/customTextfieldToolBar.dart';
import 'package:christian_ordinary_life/src/common/thankDiaryInfo.dart';
import 'package:christian_ordinary_life/src/common/getImage.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:christian_ordinary_life/src/component/customPicker.dart';
import 'package:christian_ordinary_life/src/model/ThankCategory.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';

class ThankDiaryWrite extends StatefulWidget {
  final Diary diary;
  ThankDiaryWrite({this.diary});

  @override
  ThankDiaryWriteState createState() => ThankDiaryWriteState();
}

class ThankDiaryWriteState extends State<ThankDiaryWrite>
    with SingleTickerProviderStateMixin {
  Diary newDiary = new Diary();
  UserInfo userInfo = new UserInfo();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  FocusNode _focus = new FocusNode();
  AnimationController _controller;
  Animation _animation;
  ThankDiaryInfo thankDiaryInfo = new ThankDiaryInfo();
  ComponentStyle componentStyle = new ComponentStyle();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String diaryDateForm = '';
  DateTime diaryDate = new DateTime.now();
  bool _trashVisibility = false;
  ThankCategory _selectedCategory = new ThankCategory();
  CustomPicker _thankCategoryPicker;
  CustomPicker _imageOptionPicker;
  GetImage getImage = new GetImage();
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  String base64Image;
  String _fileExtension = '';
  final ImagePicker _picker = ImagePicker();
  String _savedImage = '';
  bool _first = true;
  bool _isLoading = false;

  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  Future<void> _writeDiary() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await API.transaction(context, API.thanksDiaryWrite, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'thankDiarySeqNo': newDiary.seqNo,
        'title': newDiary.title,
        'diaryDate': newDiary.diaryDate,
        'content': newDiary.content,
        'thankDiary': 'y',
        'goalDate': newDiary.diaryDate,
        'imageURL': newDiary.imageURL,
        'image': base64Image,
        'fileExtension': _fileExtension,
        'categoryNo': _selectedCategory.categoryNo,
        'imageStatus': newDiary.imageStatus
      }).then((response) {
        setState(() {
          _isLoading = false;
        });
        // Delay to wait for the new image to be reflected
        Future.delayed(const Duration(milliseconds: 1000), () {
          Diary writeResult = Diary.fromJson(json.decode(response));
          if (writeResult.result == 'success') {
            Navigator.pop(context, newDiary);
          } else {
            errorMessage(context, newDiary.errorMessage);
          }
        });
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

  Future<void> _delete() async {
    try {
      final confirmResult = await showConfirmDialog(
          context, Translations.of(context).trans('delete_confirm'));

      if (confirmResult == 'ok') {
        setState(() {
          _isLoading = true;
        });

        await API.transaction(context, API.thanksDiaryDelete, param: {
          'userSeqNo': UserInfo.loginUser.seqNo,
          'thankDiarySeqNo': widget.diary.seqNo,
          'imageURL': widget.diary.imageURL
        }).then((response) {
          setState(() {
            _isLoading = false;
          });
          Diary deleteResult = Diary.fromJson(json.decode(response));
          if (deleteResult.result == 'success') {
            Navigator.pop(context, 'delete');
          } else {
            errorMessage(context, newDiary.errorMessage);
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

  /* get Image code start */

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      if (widget.diary != null &&
          widget.diary.imageURL != null &&
          widget.diary.imageURL != '')
        newDiary.imageStatus = 'replace';
      else
        newDiary.imageStatus = 'new';

      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();

    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _callbackImgDelete() async {
    await showConfirmDialog(
            context, Translations.of(context).trans('image_delete_confirm'))
        .then((value) {
      if (value == 'ok') {
        setState(() {
          if (_savedImage != '') {
            _savedImage = '';
            newDiary.imageStatus = 'delete';
            newDiary.imageURL = null;
          } else {
            _imageFile = null;
          }
        });
      }
    });
  }

  /* get Image code end */

  void _makeThankCategoryOption() {
    List<Widget> pickerList = [];
    for (int i = 0; i < ThankDiaryInfo.thankCategoryList.length; i++) {
      pickerList.add(Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              FadeInImage.assetNetwork(
                image: API.systemImageURL +
                    ThankDiaryInfo.thankCategoryList[i].categoryImageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
                placeholder: wrongImage(),
              ),
              Expanded(
                child: Text(ThankDiaryInfo.thankCategoryList[i].categoryTitle),
              )
            ],
          )));
    }
    CustomPicker customPicker = new CustomPicker(
      pickerList: pickerList,
      selectedItem: int.parse(_selectedCategory.categoryNo) - 1,
    );
    _thankCategoryPicker = customPicker;
  }

  void _makeGetImageOption() {
    List<Widget> pickerList = [];
    pickerList = <Widget>[
      Container(
          padding: EdgeInsets.all(13),
          child: Text(
            Translations.of(context).trans('gallery'),
            style: TextStyle(color: AppColors.darkGray, fontSize: 20),
            textAlign: TextAlign.center,
          )),
      Container(
          padding: EdgeInsets.all(13),
          child: Text(
            Translations.of(context).trans('camera'),
            style: TextStyle(color: AppColors.darkGray, fontSize: 20),
            textAlign: TextAlign.center,
          )),
    ];

    CustomPicker customPicker = new CustomPicker(
      pickerList: pickerList,
    );
    _imageOptionPicker = customPicker;
  }

  Widget actionIcon() {
    return TextButton(
      child: Text(Translations.of(context).trans('save'),
          style: TextStyle(color: AppColors.darkGray)),
      onPressed: () {
        if (_contentController.text.isNotEmpty) {
          newDiary.seqNo = widget.diary != null ? widget.diary.seqNo : null;
          newDiary.title = _titleController.text;
          newDiary.content = _contentController.text;
          newDiary.diaryDate = diaryDate.toString();
          newDiary.categoryImageUrl = _selectedCategory.categoryImageUrl;
          newDiary.categoryNo = _selectedCategory.categoryNo;

          hideKeyboard(context);
          _writeDiary();
        } else {
          hideKeyboard(context);
          showToast(
              context, Translations.of(context).trans('validate_content'));
        }
      },
    );
  }

  void _setDiary() {
    newDiary.imageStatus = 'noChange';
    newDiary.imageURL = widget.diary.imageURL;
    _savedImage = widget.diary.imageURL;
    _titleController.text = widget.diary.title;
    _contentController.text = widget.diary.content;
    _selectedCategory.categoryNo = widget.diary.categoryNo;
    _selectedCategory.categoryImageUrl = widget.diary.categoryImageUrl;
    if (widget.diary.diaryDate != null)
      diaryDate = DateTime.parse(widget.diary.diaryDate);
    else
      diaryDate = DateTime.now();
  }

  void _setDate(DateTime selectedDate) {
    setState(() {
      diaryDate = selectedDate;
      diaryDateForm = getDateOfWeek(diaryDate);
    });
  }

  void _setThankCategory(int selected) {
    setState(() {
      _selectedCategory = ThankDiaryInfo.thankCategoryList[selected];
    });
  }

  void _showCategoryPicker() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 2.5,
              child: _thankCategoryPicker);
        });

    if (result != null) _setThankCategory(result);
  }

  void _showImageOption() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 2.5,
              child: _imageOptionPicker);
        });

    if (result != null) {
      if (result == 0) {
        _onImageButtonPressed(ImageSource.gallery, context: context);
      } else {
        _onImageButtonPressed(ImageSource.camera, context: context);
      }
    }
  }

  Future<bool> _androidBackKeyEvent() async {
    if (_keyboardState) {
      FocusScope.of(context).requestFocus(new FocusNode());
    } else {
      Navigator.pop(context, widget.diary);
    }
    return false;
  }

  @override
  void initState() {
    if (widget.diary != null) {
      _setDiary();
      _trashVisibility = true;
    } else {
      _trashVisibility = false;
      _selectedCategory.categoryNo = '1';
      _selectedCategory.categoryImageUrl = 'thank_ct_ordinary.png';
    }
    diaryDateForm = getDateOfWeek(diaryDate);

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

    userInfo.checkLoginServer(context).then((value) {
      if (value == true) {
        if (ThankDiaryInfo.thankCategoryList == null ||
            ThankDiaryInfo.thankCategoryList.length == 0) {
          thankDiaryInfo
              .getThankCategory(context)
              .then((value) => _makeThankCategoryOption());
        } else {
          _makeThankCategoryOption();
        }
      }
    });

    super.initState();
  }

  Widget _setImageInformation() {
    if (_imageFile != null) {
      base64Image = base64Encode(File(_imageFile.path).readAsBytesSync());
      if (_imageFile.path.indexOf('.') != -1) {
        var tempStr = _imageFile.path.split('.');
        _fileExtension = tempStr[tempStr.length - 1];
      }
    }

    return getImage.previewImage(context, _imageFile,
        imageIcon: _imageIcon(),
        savedImage: _image(),
        pickImageError: _pickImageError,
        retrieveDataError: _retrieveDataError,
        callbackEdit: _showImageOption,
        callbackDelete: _callbackImgDelete);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _controller.dispose();
    _focus.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  Widget _imageIcon() {
    return IconButton(
      icon: Icon(FontAwesomeIcons.image),
      color: AppColors.pastelPink,
      onPressed: _showImageOption,
    );
  }

  Widget _image() {
    if (_savedImage != null && _savedImage != '') {
      return GestureDetector(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.assetNetwork(
                  image: API.diaryImageURL + _savedImage,
                  width: 70,
                  height: 70,
                  fit: BoxFit.fill,
                  placeholder: wrongImage())),
          onTap: () {
            getImage.showImage(
                context, null, _showImageOption, _callbackImgDelete,
                savedImageURL: API.diaryImageURL + _savedImage);
          });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _makeGetImageOption();
      _first = false;
    }

    final _categoryButton = Container(
        width: 50,
        height: 50,
        child: TextButton(
            onPressed: _showCategoryPicker,
            child: FadeInImage.assetNetwork(
              image: API.systemImageURL + _selectedCategory.categoryImageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.fill,
              placeholder: wrongImage(),
            )));

    final _calendarButton = Container(
        padding: EdgeInsets.only(right: 5),
        child: IconButton(
          icon: Icon(Icons.calendar_today),
          color: AppColors.pastelPink,
          onPressed: () {
            showCalendar(context, diaryDate, MediaQuery.of(context).padding.top)
                .then((result) {
              if (result != null) _setDate(result);
            });
          },
        ));

    final _diaryDate = Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        child: Text(
          diaryDateForm,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          showCalendar(context, diaryDate, MediaQuery.of(context).padding.top)
              .then((result) {
            if (result != null) _setDate(result);
          });
        },
      ),
    );

    final _deleteButton = Visibility(
        visible: _trashVisibility,
        child: Container(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
                icon: Icon(FontAwesomeIcons.trash),
                color: AppColors.lightGray,
                onPressed: _delete)));

    final _imageButton = Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        padding: EdgeInsets.only(right: 5),
        margin: EdgeInsets.only(top: 8, left: 4),
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return _imageIcon();
                    case ConnectionState.waiting:
                      return _imageIcon();
                    case ConnectionState.done:
                      return _setImageInformation();

                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return _imageIcon();
                      }
                  }
                },
              )
            : _setImageInformation());

    final _diaryTitle = Expanded(
      child: Container(
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
        ),
      ),
    );

    final _diaryContent = Container(
        padding: EdgeInsets.all(12),
        child: CustomTextField(
          enableInteractiveSelection: true,
          textAlignVertical: TextAlignVertical.top,
          keyboardType: TextInputType.multiline,
          minLines: 10,
          maxLines: 100,
          decoration: componentStyle.whiteGreyInput(
              Translations.of(context).trans('thank_content_hint')),
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
            backgroundColor: AppColors.lightPinks,
            appBar: appBarBack(
                context, Translations.of(context).trans('menu_thank_diary'),
                actionWidget: actionIcon(),
                onBackTap: () => Navigator.pop(context, widget.diary)),
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
                                _categoryButton,
                                _calendarButton,
                                _diaryDate,
                                _deleteButton,
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _imageButton,
                                _diaryTitle,
                              ],
                            ),
                            _diaryContent,
                            Platform.isAndroid
                                ? SizedBox(height: _animation.value)
                                : Container(),
                          ],
                        ))))));
  }
}
