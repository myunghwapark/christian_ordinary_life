import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'package:christian_ordinary_life/src/model/TodayBible.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingBible.dart';
import 'src/common/commonSettings.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Christian Ordinary Life',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[400], width: 2),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          errorColor: Colors.orange[600]),
      home: Main(title: ''),
      initialRoute: '/',
      routes: {
        QTRecord.routeName: (context) => QTRecord(),
        ThankDiary.routeName: (context) => ThankDiary(),
        GoalSettingBible.routeName: (context) => GoalSettingBible(),
      },
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case GoalSetting.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return GoalSetting();
              });
            }
            break;
          case QTRecord.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return QTRecord();
              });
            }
            break;
          case ThankDiary.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return ThankDiary();
              });
            }
            break;
          case ReadingBible.routeName:
            {
              final TodayBible args = routeSettings.arguments;
              return MaterialPageRoute(builder: (context) {
                return ReadingBible(args);
              });
            }
            break;
          case ProcessCalendar.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return ProcessCalendar();
              });
            }
            break;
          case Settings.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return Settings();
              });
            }
            break;
          case Settings.routeName:
            {
              return MaterialPageRoute(builder: (context) {
                return Settings();
              });
            }
            break;
          default:
            {
              return MaterialPageRoute(builder: (context) {
                return Main();
              });
            }
            break;
        }
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

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    CommonSettings.flutterLocalNotificationsPlugin
        .initialize(initializationSettings);

    super.initState();
  }

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
