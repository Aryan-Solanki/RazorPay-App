import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../size_config.dart';
import 'components/SignUpScreenDesktop.dart';
import 'components/SignUpScreenMobile.dart';
import 'components/SignUpScreenTablet.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
      ),
      body: ScreenTypeLayout(
        mobile: SignUpScreenMobile(),
        tablet: SignUpScreenTablet(),
        desktop: SignUpScreenDesktop(),
      ),
    );
  }
}
