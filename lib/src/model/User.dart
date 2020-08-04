class User {
  String name;
  String email;
  String userGrade;
  String password;
  String result;
  String errorMessage;
  String errorCode;

  User(
      {this.name,
      this.email,
      this.userGrade,
      this.password,
      this.result,
      this.errorMessage,
      this.errorCode});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      userGrade: json['userGrade'],
      password: json['password'],
      result: json['result'],
      errorMessage: json['errorMessage'],
      errorCode: json['errorCode'],
    );
  }
}
