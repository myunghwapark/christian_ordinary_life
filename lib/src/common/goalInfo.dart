import 'dart:convert';

import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/model/TodayBible.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingBible.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/model/GoalProgress.dart';

class GoalInfo {
  UserInfo userInfo = new UserInfo();
  static Goal goal = new Goal();
  static GoalProgress goalProgress = new GoalProgress();

  Future<Goal> getUserGoal(BuildContext context) async {
    if (!userInfo.loginCheck()) return null;
    Goal result = new Goal();
    try {
      await API.transaction(context, API.getUserGoal,
          param: {'userSeqNo': UserInfo.loginUser.seqNo}).then((response) {
        result = Goal.fromJson(json.decode(response));
        //print('response: $response');
        if (result.result == 'success') {
          List<Goal> goalInfo =
              result.goalInfo.map((model) => Goal.fromJson(model)).toList();
          goal = goalInfo[0];

          if (!goal.readingBible &&
              !goal.praying &&
              !goal.qtRecord &&
              !goal.thankDiary)
            goal.goalSet = false;
          else
            goal.goalSet = true;
        } else if (result.errorCode == '01') {
          goal.goalSet = false;
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
    return goal;
  }

  Future<GoalProgress> getGoalProgress(BuildContext context) async {
    if (!userInfo.loginCheck()) return null;

    GoalProgress result = new GoalProgress();
    try {
      await API.transaction(context, API.getGoalProgress, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'goalDate': getToday()
      }).then((response) {
        // print('response getGoalProgress: $response');
        result = GoalProgress.fromJson(json.decode(response));
        if (result.result == 'success') {
          List<GoalProgress> goalInfo = result.goalProgress
              .map((model) => GoalProgress.fromJson(model))
              .toList();
          goalProgress = goalInfo[0];
        }
        // If there is no goal progress, set default setting.
        else if (result.errorCode == '01') {
          goalProgress = new GoalProgress();

          if (!goal.readingBible) goalProgress.readingBible = '-';
          if (!goal.praying) goalProgress.praying = '-';
          if (!goal.qtRecord) goalProgress.qtRecord = '-';
          if (!goal.thankDiary) goalProgress.thankDiary = '-';
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }

    return goalProgress;
  }

  Future<Goal> setUserGoal(
      BuildContext context, BibleUserPlan bibleUserPlan) async {
    Goal result = new Goal();

    try {
      showLoading(context);
      await API.transaction(context, API.setUserGoal, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'readingBible': GoalInfo.goal.readingBible,
        'thankDiary': GoalInfo.goal.thankDiary,
        'qtRecord': GoalInfo.goal.qtRecord,
        'qtTime': GoalInfo.goal.qtTime,
        'qtAlarm': GoalInfo.goal.qtAlarm,
        'praying': GoalInfo.goal.praying,
        'prayingTime': GoalInfo.goal.prayingTime,
        'prayingAlarm': GoalInfo.goal.prayingAlarm,
        'prayingDuration': GoalInfo.goal.prayingDuration,
        'biblePlanId': bibleUserPlan.biblePlanId,
        'planPeriod': bibleUserPlan.planPeriod,
        'customBible': bibleUserPlan.customBible,
        'planEndDate': bibleUserPlan.planEndDate
      }).then((response) async {
        //print('response: $response');
        result = Goal.fromJson(json.decode(response));
        if (result.result == 'success') {
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
    return result;
  }

  bool checkContent(BuildContext context, BibleUserPlan bibleUserPlan) {
    if (GoalInfo.goal.readingBible &&
        (bibleUserPlan.biblePlanId == null ||
            bibleUserPlan.biblePlanId == '')) {
      showAlertDialog(
          context, Translations.of(context).trans('select_bible_plan'));
      return false;
    } else if (bibleUserPlan.biblePlanId == 'custom' &&
        (bibleUserPlan.customBible == null ||
            bibleUserPlan.customBible == '')) {
      showAlertDialog(
          context, Translations.of(context).trans('select_custom_bible_plan'));
      return false;
    } else if (bibleUserPlan.biblePlanId == 'custom' &&
        (bibleUserPlan.planPeriod == null ||
            bibleUserPlan.planPeriod == '' ||
            bibleUserPlan.planPeriod == '0')) {
      showAlertDialog(
          context, Translations.of(context).trans('select_custom_bible_plan'));
      return false;
    } else {
      return true;
    }
  }

  Future<void> setPrayingProgress(BuildContext context) async {
    if (!userInfo.loginCheck()) return null;
    GoalProgress result = new GoalProgress();
    try {
      await API.transaction(context, API.setPrayingProgress, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'goalDate': getToday(),
        'praying': goalProgress.praying
      }).then((response) {
        result = GoalProgress.fromJson(json.decode(response));
        if (result.result != 'success') {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  Future<TodayBible> getTodaysBible(BuildContext context) async {
    TodayBible todayBible;
    try {
      await API.transaction(context, API.todayBible, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'goalDate': getToday()
      }).then((response) {
        //print('todayBible response: $response');
        todayBible = TodayBible.fromJson(json.decode(response));
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }

    return todayBible;
  }

  void goBiblePlan(BuildContext context) {
    BibleUserPlan bibleUserPlan = new BibleUserPlan();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => GoalSettingBible(
              newBiblePlan: true, bibleUserPlan: bibleUserPlan)),
    );
  }
}
