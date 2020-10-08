import 'package:christian_ordinary_life/src/common/getImage.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class ContactDeveloper extends StatefulWidget {
  ContactDeveloperState createState() => ContactDeveloperState();
}

class ContactDeveloperState extends State<ContactDeveloper> {
  List<String> attachments = [];
  bool isHTML = false;
  final ImagePicker _picker = ImagePicker();
  bool _first = true;
  GetImage getImage = new GetImage();
  dynamic _pickImageError;
  String _retrieveDataError;
  PickedFile _imageFile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _replyEmailController = new TextEditingController();
  final _recipientController = TextEditingController(
    text: 'christianlifemanager@gmail.com',
  );

  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  Future<void> send() async {
    if (_formKey.currentState.validate()) {
      final Email email = Email(
        body: _bodyController.text,
        subject: _subjectController.text,
        recipients: [_recipientController.text],
        attachmentPaths: attachments,
        isHTML: isHTML,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

      if (!mounted) return;

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(platformResponse),
      ));
    }
  }

  Widget _actionIcon() {
    return IconButton(
      onPressed: send,
      icon: Icon(Icons.send),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _subjectController.text = Translations.of(context).trans('contact_title');

      _bodyController.text = '';
      _first = false;
    }

    final _recipient = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        controller: _recipientController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: Translations.of(context).trans('recipient'),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_empty_email');
          }
          return null;
        },
      ),
    );

    final _replyEmail = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _replyEmailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: Translations.of(context).trans('email_for_reply'),
        ),
      ),
    );

    final _subject = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _subjectController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: Translations.of(context).trans('subject'),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_title');
          }
          return null;
        },
      ),
    );

    final _content = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _bodyController,
        maxLines: 15,
        decoration: InputDecoration(
            hintText: Translations.of(context).trans('contact_hint'),
            border: OutlineInputBorder()),
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_content');
          }
          return null;
        },
      ),
    );

    final _htmlCheckbox = CheckboxListTile(
      title: Text('HTML'),
      onChanged: (bool value) {
        setState(() {
          isHTML = value;
        });
      },
      value: isHTML,
    );

    final _attachment = Row(
      children: [
        _imageFile != null ? Icon(Icons.attach_file) : Container(),
        Container(
            width: 50,
            height: 50,
            child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                ? FutureBuilder<void>(
                    future: retrieveLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container();
                        case ConnectionState.waiting:
                          return Container();
                        case ConnectionState.done:
                          return _setImage();

                        default:
                          if (snapshot.hasError) {
                            return Text(
                              'Pick image/video error: ${snapshot.error}}',
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                      }
                    },
                  )
                : _setImage()),
        SizedBox(
          width: 10,
        ),
        _imageFile != null
            ? IconButton(
                icon: Icon(Icons.delete),
                color: Colors.grey,
                onPressed: () => _deleteImage(),
              )
            : Container()
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarComponent(
          context, Translations.of(context).trans('contact_developer'),
          actionWidget: _actionIcon()),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _recipient,
                    _replyEmail,
                    _subject,
                    _content,
                    _htmlCheckbox,
                    ...attachments.map((item) {
                      return _attachment;
                    }),
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera),
        label: Text(Translations.of(context).trans('add_image')),
        onPressed: _openImagePicker,
      ),
    );
  }

  void _deleteImage() {
    setState(() {
      attachments = [];
      _imageFile = null;
    });
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

  Widget _setImage() {
    return getImage.previewThumbnail(context, _imageFile,
        pickImageError: _pickImageError, retrieveDataError: _retrieveDataError);
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      attachments = [];

      if (pickedFile != null) {
        setState(() {
          attachments.add(pickedFile.path);
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      setState(() {
        showToast(_scaffoldKey, e.toString());
        _pickImageError = e;
      });
    }
  }

  void _openImagePicker() async {
    _onImageButtonPressed(ImageSource.gallery, context: context);
  }
}
