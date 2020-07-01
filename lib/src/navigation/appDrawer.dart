import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/util.dart';

class AppDrawer extends StatelessWidget {


  Widget _createDrawerItem({IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: colorFromHex("#0a8d71"),
        ),
        Padding(
          padding: EdgeInsets.only(top: 3, left: 16.0),
          child: Text(text,
            style: TextStyle(
              color: colorFromHex("#001914"),
              fontSize: 18
            ),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          padding: EdgeInsets.only(left:20, right:20),
          decoration: 
            BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/drawer_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Text('크리스천의 평범한 삶'),
                    padding: EdgeInsets.only(top:60, left:20),
                  ),
                  
                  Divider(
                    color: Colors.white,
                    
                  ),
                  _createDrawerItem(
                    icon: Icons.location_searching,
                    text: '목표설정',
                    onTap: () => {
                      //Navigator.pop(context)
                      Navigator.pushReplacementNamed(context, '/goalSetting')
                    }
                  ),
                  _createDrawerItem(
                    icon: FontAwesomeIcons.bible,
                    text: '성경통독',
                    onTap: () => {
                      Navigator.pushReplacementNamed(context, '/readingBible')
                    }
                  ),
                  _createDrawerItem(
                    icon: FontAwesomeIcons.pen,
                    text: '묵상기록',
                    onTap: () => {
                      Navigator.pushReplacementNamed(context, '/qtRecord')
                    }
                  ),
                  _createDrawerItem(
                    icon: FontAwesomeIcons.heart,
                    text: '감사일기',
                    onTap: () => {
                      Navigator.pushReplacementNamed(context, '/thankDiary')
                    }
                  ),
                  _createDrawerItem(
                    icon: Icons.calendar_today,
                    text: '달력보기',
                    onTap: () => {
                      Navigator.pushReplacementNamed(context, '/calendar')
                    }
                  ),
                  _createDrawerItem(
                    icon: Icons.settings,
                    text: '환경설정',
                    onTap: () => {
                      Navigator.pushReplacementNamed(context, '/settings')
                    }
                  ),
                ],
              ),
            ),
        ),
    );
  }

}
