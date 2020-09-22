import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/ThankCategory.dart';

class ThankDiaryInfo {
  static List<ThankCategory> thankCategoryList = new List<ThankCategory>();

  Future<void> getThankCategory(BuildContext context) async {
    try {
      await API.transaction(context, API.getThankCategoryList, param: {
        'language': UserInfo.language,
      }).then((response) {
        ThankCategory result = ThankCategory.fromJson(json.decode(response));
        if (result.result == 'success') {
          List<ThankCategory> tempList;
          tempList = result.thankCategoryList
              .map((model) => ThankCategory.fromJson(model))
              .toList();
          for (int i = 0; i < tempList.length; i++) {
            thankCategoryList.add(tempList[i]);
            final theImage = Image.network(
                API.systemImageURL + thankCategoryList[i].categoryImageUrl,
                fit: BoxFit.cover);
            precacheImage(theImage.image, context);
          }
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    }
  }
}
