import 'dart:convert';

import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
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
        print('response: $response');
        if (result.result == 'success') {
          List<Goal> goalInfo =
              result.goalInfo.map((model) => Goal.fromJson(model)).toList();
          goal = goalInfo[0];
          /* // 한번에 파싱하기 위해 어쩔 수 없이 Goal에 담아서 분배
          bibleUserPlan.biblePlanId = goal.biblePlanId;
          bibleUserPlan.customBible = goal.customBible;
          bibleUserPlan.planPeriod = goal.planPeriod;
 */
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
        result = GoalProgress.fromJson(json.decode(response));
        print('response: $response');
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

  Future<String> setGoalProgress(
      BuildContext context, GoalProgress goalProgress) async {
    if (!userInfo.loginCheck()) return null;
    GoalProgress result = new GoalProgress();

    try {
      await API.transaction(context, API.setGoalProgress, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'goalDate': getToday(),
        'readingBible': goalProgress.readingBible,
        'praying': goalProgress.praying,
        'qtRecord': goalProgress.qtRecord,
        'thankDiary': goalProgress.thankDiary
      }).then((response) {
        result = GoalProgress.fromJson(json.decode(response));
        print('response: $response');
        if (result.result != 'success') {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
    return result.result;
  }
}
