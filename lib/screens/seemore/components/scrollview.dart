import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:orev/components/fullwidth_product_cart.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/screens/home/components/section_title.dart';
import 'package:orev/services/product_services.dart';

import '../../../size_config.dart';

class AllItems extends StatefulWidget {
  final String categoryId;
  final String title;
  final Function() notifyParent;
  final ScrollController scrollController;
  AllItems(
      {this.categoryId,
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
  List<dynamic> keys = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _products = [];
  bool _loadingProducts = true;
  int _perpage = 5;
  DocumentSnapshot _lastDocument;
  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;
  ProductServices _services = ProductServices();

  _getProducts() async {
    Query q = _firestore
        .collection("products")
        .where("categories", arrayContains: widget.categoryId)
        .orderBy("title")
        .limit(_perpage);
    setState(() {
      _loadingProducts = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _products = querySnapshot.docs;
    for (var product in _products) {
      ProductList.add(_services.getProductSeeMore(product));
    }
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
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

    Query q = _firestore
        .collection("products")
        .where("categories", arrayContains: widget.categoryId)
        .orderBy("title")
        .startAfterDocument(_lastDocument)
        .limit(_perpage);
    QuerySnapshot querySnapshot = await q.get();

    if (querySnapshot.docs.length < _perpage) {
      _moreProductsAvailable = false;
    }

    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _products.addAll(querySnapshot.docs);
    for (var product in querySnapshot.docs) {
      ProductList.add(_services.getProductSeeMore(product));
    }
    setState(() {});
    _gettingMoreProducts = false;
  }

  Future<void> getAllProducts() async {
    ProductServices _services = ProductServices();

    var _documentRef = await _services.products;
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((value) {
          List val = value["categories"];
          if (val.contains(widget.categoryId)) {
            keys.add(value["productId"].trim());
          }
        });
      }
    });

    for (var k in keys) {
      ProductList.add(await _services.getProduct(k));
    }

    setState(() {});
    // list.add(SizedBox(width: getProportionateScreenHeight(20)));
  }

  @override
  void initState() {
    // getAllProducts();
    super.initState();
    _getProducts();
    // widget.scrollController.addListener(() {
    //   double maxScroll = widget.scrollController.position.maxScrollExtent;
    //   double currentScroll = widget.scrollController.position.pixels;
    //   double delta = getProportionateScreenHeight(25);
    //
    //   if (maxScroll - currentScroll < delta) {
    //     getMoreProducts();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        widget.notifyParent();
      });
    }

    // widget.scrollController.addListener(() {
    //   double maxScroll =  widget.scrollController.position.maxScrollExtent;
    //   double currentScroll =  widget.scrollController.position.pixels;
    //   double delta = getProportionateScreenHeight(25);
    //
    //
    //   if (maxScroll - currentScroll < delta) {
    //     _getMoreProducts();
    //   }
    // });

    return Column(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
        child: SectionTitle(
          title: widget.title,
          categoryId: widget.categoryId,
          press: () {},
          seemore: false,
        ),
      ),
      SizedBox(height: getProportionateScreenHeight(20)),
      _loadingProducts == true
          ? CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
            )
          : ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: kPrimaryColor2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _products.length == 0
                      ? Center(
                          child: Text(
                            "No products to display",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(15)),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _products.length,
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
// Column(
// children: [
// Padding(
// padding:
// EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
// child: SectionTitle(
// title: widget.title,
// categoryId: widget.categoryId,
// press: () {},
// seemore: false,
// ),
// ),
// SizedBox(height: getProportionateScreenHeight(20)),
// SingleChildScrollView(
// scrollDirection: Axis.vertical,
// child: Column(
// children: [
// ...List.generate(
// ProductList.length,
// (index) {
// return FullWidthProductCard(
// product: ProductList[index],
// notifyParent: refresh,
// );
//
// return SizedBox
//     .shrink(); // here by default width and height is 0
// },
// ),
// GestureDetector(
// onTap: () {},
// child: Container(
// margin: EdgeInsets.symmetric(
// horizontal: getProportionateScreenHeight(20),
// vertical: getProportionateScreenHeight(15)),
// child: Image.network(
// "https://cdn.shopify.com/s/files/1/0173/7644/4470/files/ITC_Header_Banner_Mobile_480x480.jpg?v=1608556751",
// fit: BoxFit.cover,
// alignment: Alignment.center,
// ),
// ),
// ),
// ],
// ),
// )
// ],
// );
