class Diary {
  String seqNo;
  String title;
  String diaryDate;
  String content;
  String result;
  String errorMessage;
  String errorCode;
  String searchKeyword;
  int totalCnt;
  List diaryList;

  Diary(
      {this.seqNo,
      this.title,
      this.diaryDate,
      this.content,
      this.searchKeyword,
      this.result,
      this.errorCode,
      this.errorMessage,
      this.totalCnt});

  Diary.fromJson(Map json)
      : title = json['title'],
        seqNo = json['seqNo'],
        diaryDate = json['diaryDate'],
        content = json['content'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'],
        searchKeyword = json['searchKeyword'],
        diaryList = json['diaryList'],
        totalCnt = json['totalCnt'];
}
