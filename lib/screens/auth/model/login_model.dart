class LoginResponse {
  String? token;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? firstName;
  String? lastName;
  String? mobileNo;
  String? website;

  int? userId;
  String? avatar;
  String? profileImage;

  LoginResponse({this.token, this.userEmail, this.userNicename, this.userDisplayName, this.firstName, this.lastName, this.userId, this.avatar, this.profileImage});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = "${json['api_key']}:${json['api_secret']}";//json['token'];
    userEmail = json['email'];
    userNicename = json['fullname'];
    userDisplayName = json['fullname'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNo = json['mobile_no'];
    website = json['website'];
    //userId = json['username'];
    avatar = json['image'];
    profileImage = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_id'] = this.userId;
    data['avatar'] = this.avatar;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
