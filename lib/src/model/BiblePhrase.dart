class BiblePhrase {
  String seqNo;
  String book;
  String bookTitle;
  String chapter;
  String verses;
  String content;
  List biblePhrase;

  BiblePhrase(
      {this.seqNo,
      this.book,
      this.bookTitle,
      this.chapter,
      this.verses,
      this.content,
      this.biblePhrase});

  BiblePhrase.fromJson(Map json)
      : seqNo = json['seqNo'],
        book = json['book'],
        bookTitle = json['bookTitle'],
        chapter = json['chapter'],
        verses = json['verses'],
        content = json['content'],
        biblePhrase = json['biblePhrase'];
}
