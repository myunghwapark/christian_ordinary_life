class BibleUserPlan {
  String biblePlanSeqNo;
  String userBiblePlanSeqNo;
  String biblePlanId;
  String customBible;
  String planStartDate;
  String planEndDate;
  String planPeriod;
  String biblePlanStatus;
  int customTotalChapters;

  BibleUserPlan(
      {this.biblePlanSeqNo,
      this.userBiblePlanSeqNo,
      this.biblePlanId,
      this.customBible,
      this.planStartDate,
      this.planEndDate,
      this.planPeriod,
      this.biblePlanStatus,
      this.customTotalChapters});

  BibleUserPlan.fromJson(Map json)
      : biblePlanSeqNo = json['biblePlanSeqNo'],
        userBiblePlanSeqNo = json['userBiblePlanSeqNo'],
        biblePlanId = json['biblePlanId'],
        customBible = json['customBible'],
        planStartDate = json['planStartDate'],
        planEndDate = json['planEndDate'],
        planPeriod = json['planPeriod'],
        biblePlanStatus = json['biblePlanStatus'];
}
