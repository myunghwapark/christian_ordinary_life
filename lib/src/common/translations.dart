import 'dart:async';
import 'dart:convert';

import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Translations {
  Translations(this.locale);

  final Locale locale;

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  Map<String, String> _sentences;
  Map<String, dynamic> _bible;

  Future<bool> load() async {
    CommonSettings commonSettings = new CommonSettings();

    await commonSettings.getLanguage().then((value) {
      if (value != null && value != '') {
        CommonSettings.language = value;
      } else {
        CommonSettings.language = locale.languageCode;
      }
    });
    // App
    String data = await rootBundle
        .loadString('assets/locale/${CommonSettings.language}.json');

    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    // Bible
    String bibleData = await rootBundle
        .loadString('assets/locale/bible_${CommonSettings.language}.json');

    Map<String, dynamic> _bibleResult = json.decode(bibleData);

    this._bible = new Map();
    _bibleResult.forEach((String key, dynamic value) {
      this._bible[key] = value;
    });

    return true;
  }

  String trans(String key, {String param1, String param2, String param3}) {
    var sentence = this._sentences[key];
    if (param1 != null && sentence.indexOf('#1') != -1) {
      sentence = sentence.replaceAll('#1', param1);
    }
    if (param2 != null && sentence.indexOf('#2') != -1) {
      sentence = sentence.replaceAll('#2', param2);
    }
    if (param3 != null && sentence.indexOf('#3') != -1) {
      sentence = sentence.replaceAll('#3', param3);
    }
    return sentence;
  }

  Map bible(String key) {
    return this._bible[key];
  }

  Map bibles() {
    return this._bible;
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) async {
    Translations localizations = new Translations(locale);
    await localizations.load();

    print("Load ${CommonSettings.language}");

    // Time Zone setting
    if (CommonSettings.language == 'ko') {
      Intl.defaultLocale = 'ko_KR';
    } else {
      Intl.defaultLocale = 'en_US';
    }

    return localizations;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
