import 'package:flutter/material.dart';
import 'package:orev/components/coustom_bottom_nav_bar.dart';
import 'package:orev/enums.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/SearchPageDesktop.dart';
import 'components/SearchPageMobile.dart';
import 'components/SearchPageTablet.dart';
import 'components/body.dart';

class SearchResultsPage extends StatefulWidget {
  static String routeName = "/SearchResultsPage";
  final List<Product> productList;
  final String title;
  SearchResultsPage({this.productList, this.title});
  @override
  _SearchResultsPageState createState() =>
      _SearchResultsPageState(productList: productList, title: title);
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  static String routeName = "/SearchResultsPage";
  final List<Product> productList;
  final String title;

  _SearchResultsPageState({this.productList, this.title});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return false;
      },
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: SearchPageMobile(productList: productList, title: title),
          tablet: SearchPageTablet(productList: productList, title: title),
          desktop: SearchPageDesktop(productList: productList, title: title),
        ),
      ),
    );
  }
}
