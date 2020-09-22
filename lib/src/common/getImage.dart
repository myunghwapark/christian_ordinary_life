import 'dart:io';

import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImage {
  Future<void> showImage(BuildContext context, PickedFile _imageFile,
      GestureTapCallback callbackEdit, GestureTapCallback callbackDelete,
      {String savedImageURL}) async {
    String result = '';
    if (savedImageURL != null) {
      result = await showImageDialog(context, Image.network(savedImageURL));
    } else {
      result =
          await showImageDialog(context, Image.file(File(_imageFile.path)));
    }
    if (result == 'edit') {
      callbackEdit();
    } else if (result == 'delete') {
      callbackDelete();
    }
  }

  Widget previewImage(
      BuildContext context,
      IconButton _imageIcon,
      Widget _savedImage,
      PickedFile _imageFile,
      dynamic _pickImageError,
      String _retrieveDataError,
      {GestureTapCallback callbackEdit,
      GestureTapCallback callbackDelete}) {
    final Text retrieveError = getRetrieveErrorWidget(_retrieveDataError);
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile.path);
      } else {
        return GestureDetector(
          child: ClipRRect(
              child: Image.file(
                File(_imageFile.path),
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(8.0)),
          onTap: () {
            showImage(context, _imageFile, callbackEdit, callbackDelete);
          },
        );
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else if (_savedImage != null) {
      return _savedImage;
    } else {
      return _imageIcon;
    }
  }

  Text getRetrieveErrorWidget(String _retrieveDataError) {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
