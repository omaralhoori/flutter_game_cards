class RegisterResponse {
  int? code;
  NewLogin? res;
  String? message;

  RegisterResponse({this.code, this.message, this.res});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    res = json['data'] != null ? NewLogin.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (data['data'] != null) {
      data['data'] = this.res;
    }

    return data;
  }
}

class NewLogin {
  String? displayName;
  String? iD;
  String? userActivationKey;
  String? userEmail;
  String? userLogin;
  String? userNiceName;
  String? userRegistered;
  String? userStatus;
  String? userUrl;

  NewLogin({this.displayName, this.iD, this.userActivationKey, this.userEmail, this.userLogin, this.userNiceName, this.userRegistered, this.userStatus, this.userUrl});

  factory NewLogin.fromJson(Map<String, dynamic> json) {
    return NewLogin(
      displayName: json['display_name'],
      iD: json['ID'],
      userActivationKey: json['user_activation_key'],
      userEmail: json['user_email'],
      userLogin: json['user_login'],
      userNiceName: json['user_nicename'],
      userRegistered: json['user_registered'],
      userStatus: json['user_status'],
      userUrl: json['user_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['ID'] = this.iD;
    data['user_activation_key'] = this.userActivationKey;
    data['user_email'] = this.userEmail;
    data['user_login'] = this.userLogin;
    data['user_nicename'] = this.userNiceName;
    data['user_registered'] = this.userRegistered;
    data['user_status'] = this.userStatus;
    data['user_url'] = this.userUrl;
    return data;
  }
}
