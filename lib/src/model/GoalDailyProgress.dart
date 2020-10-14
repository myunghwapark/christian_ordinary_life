import 'package:flutter/cupertino.dart';

class GoalDailyProgress {
  String goalDate;
  String title;
  String target;
  String progress;
  IconData targetIcon;
  String biblePlanID;

  GoalDailyProgress(
      {this.goalDate,
      this.title,
      this.target,
      this.progress,
      this.targetIcon,
      this.biblePlanID});
}
