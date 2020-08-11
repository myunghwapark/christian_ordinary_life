class QT {
  String seqNo;
  String title;
  String qtDate;
  String bible;
  String content;
  String result;
  String errorMessage;
  String errorCode;
  String searchKeyword;
  int totalCnt;
  List qtList;

  QT(
      {this.seqNo,
      this.title,
      this.qtDate,
      this.bible,
      this.content,
      this.searchKeyword,
      this.result,
      this.errorCode,
      this.errorMessage,
      this.totalCnt});

  QT.fromJson(Map json)
      : title = json['title'],
        seqNo = json['seqNo'],
        qtDate = json['qtDate'],
        bible = json['bible'],
        content = json['content'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'],
        searchKeyword = json['searchKeyword'],
        qtList = json['qtList'],
        totalCnt = json['totalCnt'];
}
