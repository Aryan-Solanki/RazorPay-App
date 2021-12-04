import 'package:flutter/material.dart';
import 'package:orev/screens/category_page/components/CategoryPageDesktop.dart';
import 'package:orev/screens/category_page/components/CategoryPageMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../size_config.dart';
import 'components/CategoryPageTablet.dart';
import 'components/body.dart';

class CategoryPage extends StatefulWidget {
  static String routeName = "/category_page";
  final String categoryId;
  final String title;
  CategoryPage({this.categoryId, this.title});

  @override
  _CategoryPageState createState() =>
      _CategoryPageState(categoryId: categoryId, title: title);
}

class _CategoryPageState extends State<CategoryPage> {
  static String routeName = "/category_page";
  final String categoryId;
  final String title;
  _CategoryPageState({this.categoryId, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout(
        mobile: CategoryPageMobile(categoryId: categoryId, title: title),
        tablet: CategoryPageTablet(categoryId: categoryId, title: title),
        desktop: CategoryPageDesktop(categoryId: categoryId, title: title),
      ),
    );
  }
}
