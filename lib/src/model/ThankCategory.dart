class ThankCategory {
  String categoryNo;
  String categoryTitle;
  String categoryImageUrl;
  List thankCategoryList;
  String result;
  String errorMessage;
  String errorCode;

  ThankCategory(
      {this.categoryNo,
      this.categoryTitle,
      this.categoryImageUrl,
      this.thankCategoryList,
      this.result,
      this.errorCode,
      this.errorMessage});

  ThankCategory.fromJson(Map json)
      : categoryNo = json['categoryNo'],
        categoryTitle = json['categoryTitle'],
        categoryImageUrl = json['categoryImageUrl'],
        thankCategoryList = json['thankCategoryList'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'];
}
