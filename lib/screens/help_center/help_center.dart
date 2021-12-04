import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/HelpCenterDesktop.dart';
import 'components/HelpCenterMobile.dart';
import 'components/HelpCenterTablet.dart';
import 'components/body.dart';

class HelpCenter extends StatefulWidget {
  static String routeName = "/help_center";

  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: HelpCenterMobile(),
          tablet: HelpCenterTablet(),
          desktop: HelpCenterDesktop(),
        ),
      ),
    );
  }
}
