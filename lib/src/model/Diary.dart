class Diary {
  String seqNo;
  String title;
  String diaryDate;
  String content;
  String result;
  String errorMessage;
  String errorCode;
  String searchKeyword;
  String searchStartDate;
  String searchEndDate;
  bool searchByDate;
  bool searchByCategory;
  String categoryNo;
  String imageURL;
  String image;
  String categoryImageUrl;
  String imageStatus;
  int totalCnt;
  List detail;
  List diaryList;

  Diary(
      {this.seqNo,
      this.title,
      this.diaryDate,
      this.content,
      this.searchKeyword,
      this.searchStartDate,
      this.searchEndDate,
      this.searchByDate,
      this.searchByCategory,
      this.categoryNo,
      this.imageURL,
      this.image,
      this.categoryImageUrl,
      this.imageStatus,
      this.result,
      this.errorCode,
      this.errorMessage,
      this.totalCnt,
      this.detail});

  Diary.fromJson(Map json)
      : title = json['title'],
        seqNo = json['seqNo'],
        diaryDate = json['diaryDate'],
        content = json['content'],
        categoryNo = json['categoryNo'],
        imageURL = json['imageURL'],
        image = json['image'],
        categoryImageUrl = json['categoryImageUrl'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'],
        searchKeyword = json['searchKeyword'],
        diaryList = json['diaryList'],
        totalCnt = json['totalCnt'],
        detail = json['detail'];
}
