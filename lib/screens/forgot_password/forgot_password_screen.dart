import 'package:flutter/material.dart';
import 'package:orev/screens/forgot_password/components/ForgotPasswordDesktop.dart';
import 'package:orev/screens/forgot_password/components/ForgotPasswordMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../size_config.dart';
import 'components/ForgotPasswordTablet.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: getProportionateScreenHeight(18),
          ),
        ),
      ),
      body: ScreenTypeLayout(
        mobile: ForgotPasswordMobile(),
        tablet: ForgotPasswordTablet(),
        desktop: ForgotPasswordDesktop(),
      ),
    );
  }
}
