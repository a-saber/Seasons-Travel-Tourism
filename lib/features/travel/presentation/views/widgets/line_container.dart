import 'package:flutter/material.dart';

class LineContainer extends StatelessWidget {
  const LineContainer({Key? key, required this.isTourism}) : super(key: key);
  final bool isTourism;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: .6,
      margin: EdgeInsets.symmetric(
        horizontal: isTourism ? 0.0 : 10.0,
      ),
      color: isTourism ? Colors.grey : Colors.black54,
    );
  }
}
