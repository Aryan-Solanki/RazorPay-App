import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orev/components/fullwidth_product_cart.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/screens/home/components/section_title.dart';
import 'package:orev/services/product_services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class AllItems extends StatefulWidget {
  final List<Product> productList;
  final String title;
  final Function() notifyParent;
  final ScrollController scrollController;
  AllItems(
      {this.productList,
      this.title,
      @required this.notifyParent,
      @required this.scrollController,
      Key key})
      : super(key: key);

  @override
  AllItemsState createState() => AllItemsState();
}

class AllItemsState extends State<AllItems> {
  List<Product> ProductList = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _products = [];
  bool _loadingProducts = true;
  int _perpage = 5;
  DocumentSnapshot _lastDocument;
  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;
  ProductServices _services = ProductServices();

  int i = 0;

  _getProducts() async {
    setState(() {
      _loadingProducts = true;
    });

    for (i; i < _perpage; i++) {
      ProductList.add(widget.productList[i]);
    }

    setState(() {
      _loadingProducts = false;
    });
  }

  getMoreProducts() async {
    if (_moreProductsAvailable == false) {
      return;
    }

    if (_gettingMoreProducts == true) {
      return;
    }

    _gettingMoreProducts = true;

    int j = i;

    for (i; i < j + _perpage; i++) {
      ProductList.add(widget.productList[i]);
    }

    if (widget.productList.length < _perpage) {
      _moreProductsAvailable = false;
    }
    setState(() {});
    _gettingMoreProducts = false;
  }

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        // print("Set state ho gyaaAAAA");
        widget.notifyParent();
      });
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
        child: Text(
          "Search Results for '${widget.title}'",
          style: TextStyle(
            fontSize: getProportionateScreenHeight(18),
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(height: getProportionateScreenHeight(20)),
      _loadingProducts == true
          ? widget.productList.length == 0
              ? Center(
                  child: Text("No products to display"),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                )
          : ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: kPrimaryColor2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: widget.productList.length == 0
                      ? Center(
                          child: Text("No products to display"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: ProductList.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return FullWidthProductCard(
                              product: ProductList[index],
                              notifyParent: refresh,
                            );
                          }),
                ),
              ),
            ),
    ]);
  }
}
