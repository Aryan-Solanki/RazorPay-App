import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/MyAccountDesktop.dart';
import 'components/MyAccountMobile.dart';
import 'components/MyAccountTablet.dart';
import 'components/body.dart';

class MyAccount extends StatefulWidget {
  static String routeName = "/my_account";

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: MyAccountMobile(),
          tablet: MyAccountTablet(),
          desktop: MyAccountDesktop(),
        ),
      ),
    );
  }
}
