class Chapter {
  int no;
  String book;
  String volume;
  String read;

  Chapter({this.no, this.book, this.volume, this.read});

  Chapter.fromJson(Map json)
      : book = json['book'],
        volume = json['volume'];
}
