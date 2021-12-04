import 'package:flutter/material.dart';
import 'package:orev/screens/home/components/home_header.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'AllItems.dart';

class CategoryPageTablet extends StatefulWidget {
  final String categoryId;
  final String title;
  CategoryPageTablet({this.categoryId, this.title});
  @override
  _CategoryPageTabletState createState() =>
      _CategoryPageTabletState(categoryId: categoryId);
}

class _CategoryPageTabletState extends State<CategoryPageTablet> {
  final String categoryId;
  _CategoryPageTabletState({this.categoryId});

  ScrollController _scrollController = ScrollController();
  final GlobalKey<AllItemsState> _myWidgetState = GlobalKey<AllItemsState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = getProportionateScreenHeight(25);

      if (maxScroll - currentScroll < delta) {
        _myWidgetState.currentState.getMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        print("Final Set State");
      });
    }

    return SafeArea(
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: kPrimaryColor2,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  HomeHeader(
                    key: UniqueKey(),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  AllItems(
                    categoryId: categoryId,
                    title: widget.title,
                    notifyParent: refresh,
                    key: _myWidgetState,
                    scrollController: _scrollController,
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
