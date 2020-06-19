class Settings {
  String apiKey;
  bool useLocation;
  String zipCode;
  bool areValid;

  Settings({this.apiKey, this.useLocation, this.zipCode});

  Settings.empty() {
    this.apiKey = '';
    this.useLocation = false;
    this.zipCode = '';
    this.areValid = false;
  }

  Settings.fromJson(Map<String, dynamic> json) {
    apiKey = json['apiKey'];
    useLocation = json['useLocation'];
    zipCode = json['zipCode'];
    areValid = json['areValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiKey'] = this.apiKey;
    data['useLocation'] = this.useLocation;
    data['zipCode'] = this.zipCode;
    data['areValid'] = this.areValid;
    return data;
  }
}
