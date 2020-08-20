class BiblePlan {
  String biblePlanSeqNo;
  String biblePlanId;
  String planPeriod;
  String planVolume;
  String planTitle;
  String planSubTitle;
  List biblePlanList;
  bool isSelected;
  String result;
  String errorMessage;
  String errorCode;

  BiblePlan(
      {this.biblePlanSeqNo,
      this.biblePlanId,
      this.planPeriod,
      this.planVolume,
      this.planTitle,
      this.planSubTitle,
      this.biblePlanList,
      this.isSelected,
      this.result,
      this.errorMessage,
      this.errorCode});

  BiblePlan.fromJson(Map json)
      : biblePlanSeqNo = json['biblePlanSeqNo'],
        biblePlanId = json['biblePlanId'],
        planPeriod = json['planPeriod'],
        planVolume = json['planVolume'],
        planTitle = json['planTitle'],
        planSubTitle = json['planSubTitle'],
        biblePlanList = json['biblePlanList'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'];
}
