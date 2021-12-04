import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/OfferzoneCategoryDesktop.dart';
import 'components/OfferzoneCategoryMobile.dart';
import 'components/OfferzoneCategoryTablet.dart';
import 'components/body.dart';

class OfferzoneCategory extends StatefulWidget {
  static String routeName = "/offerzone_category";
  @override
  _OfferzoneCategoryState createState() => _OfferzoneCategoryState();
}

class _OfferzoneCategoryState extends State<OfferzoneCategory> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: OfferzoneCategoryMobile(notifyParent: refresh),
          tablet: OfferzoneCategoryTablet(notifyParent: refresh),
          desktop: OfferzoneCategoryDesktop(notifyParent: refresh),
        ),
      ),
    );
  }
}
