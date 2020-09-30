class Search {
  String searchKeyword;
  String searchStartDate;
  String searchEndDate;
  bool searchByDate;
  bool searchByCategory;
  String categoryNo;

  Search(
      {this.searchKeyword,
      this.searchStartDate,
      this.searchEndDate,
      this.searchByDate,
      this.searchByCategory,
      this.categoryNo});
}
