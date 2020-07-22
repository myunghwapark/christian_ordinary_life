class BiblePlan {
  int biblePlanId;
  String planStartDate;
  String planEndDate;
  int planPeriod;
  String planActualStartDate;
  String planActualEndDate;
  String planType;
  String bibles;
  String planStatus;

  BiblePlan(
      {this.biblePlanId,
      this.planStartDate,
      this.planEndDate,
      this.planPeriod,
      this.planActualStartDate,
      this.planActualEndDate,
      this.planType,
      this.bibles,
      this.planStatus});
}
