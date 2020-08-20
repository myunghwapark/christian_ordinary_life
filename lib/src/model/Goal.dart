class Goal {
  String goalSeqNo;
  String userSeqNo;
  bool readingBible;
  bool thankDiary;
  bool qtRecord;
  String qtTime;
  bool qtAlarm;
  bool praying;
  bool prayingAlarm;
  String prayingTime;
  String prayingDuration;
  String goalSetDate;
  String result;
  String errorMessage;
  String errorCode;
  List goalInfo;

  String biblePlanId;
  String planPeriod;
  String customBible;

  Goal(
      {this.goalSeqNo,
      this.userSeqNo,
      this.readingBible,
      this.thankDiary,
      this.qtRecord,
      this.qtTime,
      this.qtAlarm,
      this.praying,
      this.prayingAlarm,
      this.prayingTime,
      this.prayingDuration,
      this.goalSetDate,
      this.result,
      this.errorMessage,
      this.errorCode,
      this.goalInfo,
      this.biblePlanId,
      this.planPeriod,
      this.customBible});

  Goal.fromJson(Map json)
      : goalSeqNo = json['goalSeqNo'],
        readingBible = (json['readingBible'] == 'true'),
        thankDiary = (json['thankDiary'] == 'true'),
        qtRecord = (json['qtRecord'] == 'true'),
        qtTime = json['qtTime'],
        qtAlarm = (json['qtAlarm'] == 'true'),
        praying = (json['praying'] == 'true'),
        prayingAlarm = (json['prayingAlarm'] == 'true'),
        prayingTime = json['prayingTime'],
        prayingDuration = json['prayingDuration'],
        goalSetDate = json['goalSetDate'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'],
        goalInfo = json['goalInfo'],
        biblePlanId = json['biblePlanId'],
        planPeriod = json['planPeriod'],
        customBible = json['customBible'];
}
