class Book {
  String book;
  String chapter;
  String verse;
  String content;
  List list;

  Book({this.book, this.chapter, this.verse, this.content});

  Book.fromJson(Map json)
      : book = json['book'],
        chapter = json['chapter'],
        verse = json['verse'],
        content = json['content'],
        list = json['list'];
}
