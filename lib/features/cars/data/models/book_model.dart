class BookModel {
  String? status;
  String? message;
  String? randomCode;

  BookModel({this.status, this.message, this.randomCode});

  BookModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    randomCode = json['random_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['random_code'] = this.randomCode;
    return data;
  }
}
