import 'package:flutter/material.dart';
import 'package:orev/size_config.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/OPTScreenDesktop.dart';
import 'components/OPTScreenMobile.dart';
import 'components/OPTScreenTablet.dart';
import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: ScreenTypeLayout(
        mobile: OTPScreenMobile(),
        tablet: OTPScreenTablet(),
        desktop: OTPScreenDesktop(),
      ),
    );
  }
}
