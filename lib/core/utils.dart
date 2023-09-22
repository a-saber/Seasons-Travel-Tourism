import 'package:flutter/material.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  Size get screenSize => MediaQuery.of(context).size;
}
