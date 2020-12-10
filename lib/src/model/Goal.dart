class Goal {
  String goalSeqNo;
  String userSeqNo;
  String userBiblePlanSeqNo;
  bool readingBible;
  bool thankDiary;
  bool qtRecord;
  String qtTime;
  bool qtAlarm;
  bool praying;
  bool prayingAlarm;
  String prayingTime;
  String prayingDuration;
  bool readingBibleAlarm;
  String readingBibleTime;
  bool thankDiaryAlarm;
  String thankDiaryTime;
  String goalSetDate;
  String biblePlanStartDate;
  String result;
  String errorMessage;
  String errorCode;
  List goalInfo;
  bool goalSet;

  String biblePlanId;
  String planPeriod;
  String customBible;

  bool oldBiblePlan;
  String oldBiblePlanId;
  String oldPlanPeriod;
  String oldCustomBible;
  bool keepBiblePlan;

  Goal(
      {this.goalSeqNo,
      this.userSeqNo,
      this.userBiblePlanSeqNo,
      this.readingBible,
      this.thankDiary,
      this.qtRecord,
      this.qtTime,
      this.qtAlarm,
      this.praying,
      this.prayingAlarm,
      this.prayingTime,
      this.prayingDuration,
      this.readingBibleAlarm,
      this.readingBibleTime,
      this.thankDiaryAlarm,
      this.thankDiaryTime,
      this.goalSetDate,
      this.biblePlanStartDate,
      this.result,
      this.errorMessage,
      this.errorCode,
      this.goalInfo,
      this.biblePlanId,
      this.planPeriod,
      this.customBible,
      this.oldBiblePlan,
      this.oldBiblePlanId,
      this.oldPlanPeriod,
      this.oldCustomBible,
      this.goalSet,
      this.keepBiblePlan});

  Goal.fromJson(Map json)
      : goalSeqNo = json['goalSeqNo'],
        userBiblePlanSeqNo = json['userBiblePlanSeqNo'],
        readingBible = (json['readingBible'] == 'true'),
        thankDiary = (json['thankDiary'] == 'true'),
        qtRecord = (json['qtRecord'] == 'true'),
        qtTime = json['qtTime'],
        qtAlarm = (json['qtAlarm'] == 'true'),
        praying = (json['praying'] == 'true'),
        prayingAlarm = (json['prayingAlarm'] == 'true'),
        prayingTime = json['prayingTime'],
        prayingDuration = json['prayingDuration'],
        readingBibleAlarm = (json['readingBibleAlarm'] == 'true'),
        readingBibleTime = json['readingBibleTime'],
        thankDiaryAlarm = (json['thankDiaryAlarm'] == 'true'),
        thankDiaryTime = json['thankDiaryTime'],
        goalSetDate = json['goalSetDate'],
        biblePlanStartDate = json['biblePlanStartDate'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'],
        goalInfo = json['goalInfo'],
        biblePlanId = json['biblePlanId'],
        planPeriod = json['planPeriod'],
        customBible = json['customBible'];
}
