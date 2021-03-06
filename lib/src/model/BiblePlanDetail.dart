class BiblePlanDetail {
  String biblePlanDetailSeqNo;
  String biblePlainId;
  String days;
  String chapter;
  String result;
  String errorMessage;
  String errorCode;
  List biblePlanDetail;
  List chapterList;

  BiblePlanDetail(
      {this.biblePlanDetailSeqNo,
      this.biblePlainId,
      this.days,
      this.chapter,
      this.result,
      this.errorMessage,
      this.errorCode,
      this.biblePlanDetail,
      this.chapterList});

  BiblePlanDetail.fromJson(Map json)
      : biblePlanDetailSeqNo = json['biblePlanDetailSeqNo'],
        biblePlainId = json['biblePlainId'],
        days = json['days'],
        chapter = json['chapter'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'],
        biblePlanDetail = json['biblePlanDetail'],
        chapterList = json['chapterList'];
}
