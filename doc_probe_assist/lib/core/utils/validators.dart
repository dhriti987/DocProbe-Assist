bool validateStringLength(String str, {int min = 1, int max = 20}) {
  return str.length >= min && str.length <= max;
}

bool isEmailValid(String inputemail) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
  RegExp regexp = RegExp(pattern.toString());
  return regexp.hasMatch(inputemail);
}
