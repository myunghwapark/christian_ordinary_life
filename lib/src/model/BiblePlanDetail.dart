class BiblePlanDetail {
  int biblePlanDetailId;
  int biblePlainId;
  String bibleTitle;
  int chapterStart;
  int chapterEnd;
  int readProgress;
  String readYn;
  String readDate;

  BiblePlanDetail(
      {this.biblePlainId,
      this.bibleTitle,
      this.chapterStart,
      this.chapterEnd,
      this.readProgress,
      this.readYn,
      this.readDate});
}
