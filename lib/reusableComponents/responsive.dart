import 'package:final_year_project/reusableComponents/sizing.dart';
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  Responsive(this.mobile, this.tablet, this.desktop);

  @override
  Widget build(BuildContext context) {
    if (Sizing.screenWidth >= 1200) {
      return desktop;
    } else if (Sizing.screenWidth >= 800) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
