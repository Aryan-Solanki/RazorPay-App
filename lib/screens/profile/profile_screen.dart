import 'package:flutter/material.dart';
import 'package:orev/components/coustom_bottom_nav_bar.dart';
import 'package:orev/enums.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/ProfileScreenDesktop.dart';
import 'components/ProfileScreenMobile.dart';
import 'components/ProfileScreenTablet.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: ProfileScreenMobile(),
          tablet: ProfileScreenTablet(),
          desktop: ProfileScreenDesktop(),
        ),
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.profile),
      ),
    );
  }
}
