class TransactionResult {
  String jwt;
  String result;
  String errorMessage;
  String errorCode;

  TransactionResult(this.jwt, this.result, this.errorCode, this.errorMessage);

  TransactionResult.fromJson(Map json)
      : jwt = json['jwt'],
        result = json['result'],
        errorMessage = json['errorMessage'],
        errorCode = json['errorCode'];
}
