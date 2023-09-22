class LoginResponse {
  bool? success;
  UserModel? data;

  LoginResponse({this.success, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class RegisterResponse {
  bool? success;
  String? message;
  UserModel? user;

  RegisterResponse({this.success, this.user, this.message});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class UserModel {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? password;
  int? type;
  String? discount;
  String? balance;
  String? img;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? verificationCode;
  String? gender;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.password,
      this.type,
      this.discount,
      this.balance,
      this.img,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.verificationCode,
      this.gender});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    type = json['type'];
    discount = json['discount'];
    balance = json['balance'];
    img = json['img'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    verificationCode = json['verification_code'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['balance'] = this.balance;
    data['img'] = this.img;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['verification_code'] = this.verificationCode;
    data['gender'] = this.gender;
    return data;
  }
}
