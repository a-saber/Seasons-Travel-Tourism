class boardingModel {
  String image;
  String title;
  String? subTitle;
  String buttonText;

  boardingModel({
    required this.image,
    required this.title,
    required this.buttonText,
    this.subTitle,
  });
}
