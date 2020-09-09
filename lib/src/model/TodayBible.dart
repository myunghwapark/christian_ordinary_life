class TodayBible {
  String biblePlainId;
  String days;
  String chapter;
  String bibleProgress;
  String lastDay;
  String result;
  String errorMessage;
  String errorCode;

  TodayBible({
    this.biblePlainId,
    this.days,
    this.chapter,
    this.bibleProgress,
    this.lastDay,
    this.result,
    this.errorMessage,
    this.errorCode,
  });

  TodayBible.fromJson(Map json)
      : biblePlainId = json['biblePlainId'],
        days = json['days'],
        chapter = json['chapter'],
        bibleProgress = json['bibleProgress'],
        lastDay = json['lastDay'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'];
}
