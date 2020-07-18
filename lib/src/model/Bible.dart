class Bible {
  String id;
  String title;
  int chapters;
  bool checked;
  int checkOrder;

  Bible(this.id, this.title, this.chapters, this.checked);

  void setChecked(bool value) {
    this.checked = value;
  }

  bool getChecked() {
    return this.checked;
  }

  void setCheckOrder(int value) {
    this.checkOrder = value;
  }

  int getCheckOrder() {
    return this.checkOrder;
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.title}, ${this.chapters} }';
  }
}