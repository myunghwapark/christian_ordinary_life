class User {
  String seqNo;
  String name;
  String email;
  String grade;
  String password;
  String result;
  String errorMessage;
  String errorCode;

  User(
      {this.seqNo,
      this.name,
      this.email,
      this.grade,
      this.password,
      this.result,
      this.errorMessage,
      this.errorCode});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      seqNo: json['seqNo'],
      name: json['name'],
      email: json['email'],
      grade: json['userGrade'],
      password: json['password'],
      result: json['result'],
      errorMessage: json['errorMessage'],
      errorCode: json['errorCode'],
    );
  }
}
