class GoalProgress {
  String userSeqNo;
  String readingBible;
  String thankDiary;
  String qtRecord;
  String praying;
  String bibleProgress;
  String bibleDays;
  String goalDate;
  String result;
  String errorCode;
  String errorMessage;
  List goalProgress;

  GoalProgress(
      {this.userSeqNo,
      this.readingBible,
      this.thankDiary,
      this.qtRecord,
      this.praying,
      this.bibleProgress,
      this.bibleDays,
      this.goalDate,
      this.result,
      this.errorCode,
      this.errorMessage,
      this.goalProgress});

  GoalProgress.fromJson(Map json)
      : userSeqNo = json['userSeqNo'],
        readingBible = json['readingBible'],
        thankDiary = json['thankDiary'],
        qtRecord = json['qtRecord'],
        praying = json['praying'],
        bibleProgress = json['bibleProgress'],
        bibleDays = json['bibleDays'],
        goalDate = json['goalDate'],
        result = json['result'],
        errorCode = json['errorCode'],
        errorMessage = json['errorMessage'],
        goalProgress = json['goalProgress'];
}
