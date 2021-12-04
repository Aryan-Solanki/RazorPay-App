import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/HelpFormDesktop.dart';
import 'components/HelpFormMobile.dart';
import 'components/HelpFormTablet.dart';
import 'components/body.dart';

class HelpForm extends StatelessWidget {
  static String routeName = "/help_form";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout(
        mobile: HelpFormMobile(),
        tablet: HelpFormTablet(),
        desktop: HelpFormDesktop(),
      ),
    );
  }
}
