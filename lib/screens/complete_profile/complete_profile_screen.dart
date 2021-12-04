import 'package:flutter/material.dart';
import 'package:orev/screens/complete_profile/components/CompleteProfileDesktop.dart';
import 'package:orev/screens/complete_profile/components/CompleteProfileMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/CompleteProfileTablet.dart';
import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: ScreenTypeLayout(
        mobile: CompleteProfileMobile(),
        tablet: CompleteProfileTablet(),
        desktop: CompleteProfileDesktop(),
      ),
    );
  }
}
