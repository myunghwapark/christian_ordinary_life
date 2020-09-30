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
  String searchStartDate;
  String searchEndDate;
  bool searchByDate;
  int totalCnt;
  List qtList;
  List detail;

  QT(
      {this.seqNo,
      this.title,
      this.qtDate,
      this.bible,
      this.content,
      this.searchKeyword,
      this.searchStartDate,
      this.searchEndDate,
      this.searchByDate,
      this.result,
      this.errorCode,
      this.errorMessage,
      this.totalCnt,
      this.detail});

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
        totalCnt = json['totalCnt'],
        detail = json['detail'];
}
