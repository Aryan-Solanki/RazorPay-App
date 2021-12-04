import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/home/components/section_title.dart';
import 'package:orev/screens/home/components/special_offers.dart';
import 'package:orev/screens/seemore/seemore.dart';
import 'package:orev/services/product_services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  final Function() notifyParent;
  Body({this.notifyParent});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Category> CategoryList = [];
  List<dynamic> keys = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _categories = [];
  bool _loadingProducts = true;
  int _perpage = 6;
  DocumentSnapshot _lastDocument;
  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;
  ProductServices _services = ProductServices();

  _getProducts() async {
    Query q = _firestore.collection("category").orderBy("name").limit(_perpage);
    setState(() {
      _loadingProducts = true;
    });
    QuerySnapshot querySnapshot = await q.get();
    _categories = querySnapshot.docs;
    for (var category in _categories) {
      CategoryList.add(new Category(
        image: category["image"],
        categoryId: category["id"],
        noOfBrands: category["num"],
        name: category["name"],
      ));
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
        .collection("category")
        .orderBy("name")
        .startAfter([_lastDocument.data()["name"]]).limit(_perpage);
    QuerySnapshot querySnapshot = await q.get();

    if (querySnapshot.docs.length < _perpage) {
      _moreProductsAvailable = false;
    }

    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _categories.addAll(querySnapshot.docs);
    for (var category in querySnapshot.docs) {
      CategoryList.add(new Category(
        image: category["image"],
        categoryId: category["id"],
        noOfBrands: category["num"],
        name: category["name"],
      ));
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

    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: kPrimaryColor2,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(10)),
              HomeHeader(),
              SizedBox(height: getProportionateScreenHeight(10)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(20)),
                child: SectionTitle(
                  title: "Categories",
                  // categoryId: widget.categoryId,
                  press: () {},
                  seemore: false,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              _loadingProducts == true
                  ? Container(
                      child: Text("Loading..."),
                      // REPLACE THIS WITH LOADING
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(20)),
                      child: _categories.length == 0
                          ? Center(
                              child: Text("No products to display"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: _categories.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return CategoryCard(
                                  image: CategoryList[index].image,
                                  numOfBrands: CategoryList[index].noOfBrands,
                                  category: CategoryList[index].name,
                                  press: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SeeMore(
                                                categoryId: CategoryList[index]
                                                    .categoryId,
                                                title:
                                                    CategoryList[index].name)));
                                  },
                                );
                              }),
                    ),
              SizedBox(height: getProportionateScreenHeight(10)),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  final String image;
  final String name;
  final String categoryId;
  final int noOfBrands;

  Category({this.image, this.categoryId, this.noOfBrands, this.name});
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.category,
    @required this.image,
    @required this.numOfBrands,
    @required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenHeight(400),
          height: getProportionateScreenHeight(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  image,
                  fit: BoxFit.fill,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(15.0),
                    vertical: getProportionateScreenHeight(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "$numOfBrands Products",
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(10),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
