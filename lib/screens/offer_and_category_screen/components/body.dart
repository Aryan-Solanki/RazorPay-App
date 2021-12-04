import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/home/components/section_title.dart';
import 'package:orev/services/product_services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'OfferzoneCategoryMobile.dart';
import 'offerzonecard.dart';

class Body extends StatefulWidget {
  final Function() notifyParent;
  Body({this.notifyParent});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<OfferZone> OfferList = [];
  List<dynamic> keys = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _offers = [];
  bool _loadingProducts = true;
  int _perpage = 6;
  DocumentSnapshot _lastDocument;
  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;
  ProductServices _services = ProductServices();

  _getProducts() async {
    Query q =
        _firestore.collection("offerZone").orderBy("order").limit(_perpage);
    setState(() {
      _loadingProducts = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _offers = querySnapshot.docs;
    for (var offer in _offers) {
      OfferList.add(new OfferZone(
          image: offer["image"],
          product: await _services.getProduct(offer["productId"])));
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
        .collection("offerZone")
        .orderBy("order")
        .startAfter([_lastDocument.data()["order"]]).limit(_perpage);
    QuerySnapshot querySnapshot = await q.get();

    if (querySnapshot.docs.length < _perpage) {
      _moreProductsAvailable = false;
    }
    var xx = querySnapshot.docs.length - 1;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _offers.addAll(querySnapshot.docs);
    for (var offer in _offers) {
      OfferList.add(new OfferZone(
          image: offer["image"],
          product: await _services.getProduct(offer["productId"])));
    }
    setState(() {});
    _gettingMoreProducts = false;
  }

  @override
  void initState() {
    _getProducts();
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = getProportionateScreenHeight(25);

      if (maxScroll - currentScroll < delta) {
        getMoreProducts();
      }
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        widget.notifyParent();
      });
    }

    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        HomeHeader(),
        SizedBox(height: getProportionateScreenHeight(10)),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: kPrimaryColor2,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(20)),
                      child: SectionTitle(
                        title: "OfferZone",
                        // categoryId: widget.categoryId,
                        press: () {},
                        seemore: false,
                      ),
                    ),
                    _loadingProducts == true
                        ? CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                kPrimaryColor),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenHeight(10)),
                            child: _offers.length == 0
                                ? Center(
                                    child: Text("No products to display"),
                                  )
                                : GridView.count(
                                    padding: EdgeInsets.all(0),
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    children: [
                                      ...List.generate(
                                        _offers.length,
                                        (index) {
                                          return OfferzoneCard(
                                              offer: OfferList[index]);
                                          // return SizedBox
                                          //     .shrink(); // here by default width and height is 0
                                        },
                                      ),
                                    ],
                                  ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class OfferZone {
//   final String image;
//   final Product product;
//
//   OfferZone({this.image, this.product});
// }
