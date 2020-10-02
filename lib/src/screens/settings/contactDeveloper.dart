import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
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

  final _recipientController = TextEditingController(
    text: 'christianlifemanager@gmail.com',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  Future<void> send() async {
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

  Widget _actionIcon() {
    return IconButton(
      onPressed: send,
      icon: Icon(Icons.send),
    );
  }

  @override
  Widget build(BuildContext context) {
    _subjectController.text = Translations.of(context).trans('contact_title');

    _bodyController.text = '';

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarComponent(
          context, Translations.of(context).trans('contact_developer'),
          actionWidget: _actionIcon()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _recipientController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Recipient',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subject',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: 15,
                  decoration: InputDecoration(
                      labelText: Translations.of(context).trans('contant_hint'),
                      border: OutlineInputBorder()),
                ),
              ),
              CheckboxListTile(
                title: Text('HTML'),
                onChanged: (bool value) {
                  setState(() {
                    isHTML = value;
                  });
                },
                value: isHTML,
              ),
              ...attachments.map(
                (item) => Text(
                  item,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera),
        label: Text('Add Image'),
        onPressed: _openImagePicker,
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      setState(() {
        attachments.add(pickedFile.path);
      });
    } catch (e) {
      setState(() {
        showToast(_scaffoldKey, e.toString());
      });
    }
  }

  void _openImagePicker() async {
    _onImageButtonPressed(ImageSource.gallery, context: context);
    /* File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachments.add(pick.path);
    }); */
  }
}
