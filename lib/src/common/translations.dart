import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Translations {  
  Translations(this.locale);  
  
  final Locale locale;  
  
  static Translations of(BuildContext context) { 
    return Localizations.of<Translations>(context, Translations);  
  }  
  
  Map<String, String> _sentences;  
  Map<String, String> _pharaseSentences;  
  
  Future<bool> load() async {
    String data = await rootBundle.loadString('assets/locale/${this.locale.languageCode}.json');

    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    String phraseData = await rootBundle.loadString('assets/locale/phrase_${this.locale.languageCode}.json');

    Map<String, dynamic> _pharaseResult = json.decode(phraseData);

    this._pharaseSentences = new Map();
    _pharaseResult.forEach((String key, dynamic value) {
      this._pharaseSentences[key] = value.toString();
    });

    return true;
  }


  
  String trans(String key) {  
    return this._sentences[key];  
  }  
  
  String pharaseTrans(String key) {  
    return this._pharaseSentences[key];  
  }  

  String localeLaunguageCode() {
    return this.locale.languageCode;
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
    
    print("Load ${locale.languageCode}");  
    
    return localizations;  
  }  
  
  @override  
  bool shouldReload(TranslationsDelegate old) => false;  
}