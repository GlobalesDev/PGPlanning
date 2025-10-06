class TwoFAuth_validation {
  String code = "";
	String timestamp = "";
	String FAuth_window = "";
	String recallCRC = "";

  TwoFAuth_validation(this.code, this.timestamp, this.FAuth_window, this.recallCRC);

  TwoFAuth_validation.fromBD(Map<String, dynamic> lista) {
    code = lista['code'];
    print(code);
    timestamp = lista['timestamp'];
    print(timestamp);
    FAuth_window = lista['FAuth_window'];
    print(FAuth_window);
    recallCRC = lista['recallCRC'];
    print(recallCRC);
  }

  void setCode(String code) {
    this.code = code;
  }

  String getCode() {
    return code;
  }

  void setTimestamp(String timestamp) {
    this.timestamp = timestamp;
  }

  String getTimestamp() {
    return timestamp;
  }

  void setFAuth_window(String FAuth_window) {
    this.FAuth_window = FAuth_window;
  }

  String getFAuth_window() {
    return FAuth_window;
  }

  void setRecallCRC(String recallCRC) {
    this.recallCRC = recallCRC;
  }

  String getRecallCRC() {
    return recallCRC;
  }
}