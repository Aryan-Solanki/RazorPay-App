import 'package:flutter/material.dart';
import 'package:orev/screens/login_success/components/LoginSuccessDesktop.dart';
import 'package:orev/screens/login_success/components/LoginSuccessMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/LoginSuccessTablet.dart';
import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
      ),
      body: ScreenTypeLayout(
        mobile: LoginSuccessMobile(),
        tablet: LoginSuccessTablet(),
        desktop: LoginSuccessDesktop(),
      ),
    );
  }
}
