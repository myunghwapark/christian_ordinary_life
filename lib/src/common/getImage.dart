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

  Widget previewImage(BuildContext context, PickedFile _imageFile,
      {IconButton imageIcon,
      Widget savedImage,
      GestureTapCallback callbackEdit,
      GestureTapCallback callbackDelete,
      dynamic pickImageError,
      String retrieveDataError}) {
    final Text retrieveError = getRetrieveErrorWidget(retrieveDataError);
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
    } else if (pickImageError != null) {
      return Text(
        'Pick image error: $pickImageError',
        textAlign: TextAlign.center,
      );
    } else if (savedImage != null) {
      return savedImage;
    } else {
      return imageIcon;
    }
  }

  Widget previewThumbnail(BuildContext context, PickedFile _imageFile,
      {dynamic pickImageError, String retrieveDataError}) {
    final Text retrieveError = getRetrieveErrorWidget(retrieveDataError);
    if (retrieveError != null) {
      return retrieveError;
    }

    Widget thumbnail;

    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile.path);
      } else {
        thumbnail = GestureDetector(
          child: ClipRRect(
              child: Image.file(
                File(_imageFile.path),
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(8.0)),
        );
      }
    } else if (pickImageError != null) {
      return Text(
        'Pick image error: $pickImageError',
        textAlign: TextAlign.center,
      );
    }

    return thumbnail;
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
