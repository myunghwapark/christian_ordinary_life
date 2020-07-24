import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/navigation/appDrawer.dart';
import 'src/common/translations.dart';
import 'src/common/colors.dart';

import 'src/screens/mainScreen.dart';
import 'src/screens/goalSetting/goalSetting.dart';
import 'src/screens/readingBible/readingBible.dart';
import 'src/screens/qtRecord/qtRecordList.dart';
import 'src/screens/thankDiary/thankDiaryList.dart';
import 'src/screens/processCalendar.dart';
import 'src/screens/settings/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christian Ordinary Life',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: ''),
      initialRoute: '/',
      routes: {
        '/goalSetting': (context) => GoalSetting(),
        '/readingBible': (context) => ReadingBible(),
        '/qtRecord': (context) => QTRecord(),
        '/thankDiary': (context) => ThankDiary(),
        '/calendar': (context) => Calendar(),
        '/settings': (context) => Settings(),
      },
      supportedLocales: [const Locale('en', 'US'), const Locale('ko', 'KR')],
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        if (locale == null) {
          debugPrint("*language locale is null!!!");
          return supportedLocales.first;
        }

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            debugPrint("*language ok for launageCode $supportedLocale");
            return supportedLocale;
          }
        }

        debugPrint("*language to fallback ${supportedLocales.first}");
        return supportedLocales.first;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: AppBar(
              title: Text(""),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: new IconThemeData(
                color: AppColors.marine,
                size: 40,
              ),
            ),
          ),
          Positioned(
            child: MainScreen(),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
