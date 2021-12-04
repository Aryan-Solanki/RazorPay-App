import 'package:flutter/material.dart';
import 'package:orev/screens/allCategoriesScreen/components/AllCategoriesScreenDesktop.dart';
import 'package:orev/screens/allCategoriesScreen/components/AllCategoriesScreenMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/AllCategoriesScreenTablet.dart';
import 'components/body.dart';

class AllCategoryScreen extends StatefulWidget {
  static String routeName = "/allCategoryScreen";
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: AllCategoriesScreenMobile(notifyParent: refresh),
          tablet: AllCategoriesScreenTablet(notifyParent: refresh),
          desktop: AllCategoriesScreenDesktop(notifyParent: refresh),
        ),
      ),
    );
  }
}
