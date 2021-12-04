import 'package:flutter/material.dart';
import 'package:orev/components/coustom_bottom_nav_bar.dart';
import 'package:orev/models/Cart.dart';
import 'package:orev/screens/liked_item/components/LikeScreenDesktop.dart';
import 'package:orev/screens/liked_item/components/LikeScreenMobile.dart';
import 'package:orev/screens/liked_item/components/scrollview.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../enums.dart';
import 'components/LikeScreenTablet.dart';
import 'components/body.dart';

class LikedScreen extends StatefulWidget {
  static String routeName = "/liked_screen";
  @override
  _LikedScreenState createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: LikeScreenMobile(),
          tablet: LikeScreenTablet(),
          desktop: LikeScreenDesktop(),
        ),
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.favourite),
      ),
    );
  }
}
