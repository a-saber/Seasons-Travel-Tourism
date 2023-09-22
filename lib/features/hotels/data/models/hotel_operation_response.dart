class HotelOperationResponse {
  bool? success;
  String? message;
  String? code;

  HotelOperationResponse({this.success, this.message});

  HotelOperationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}
