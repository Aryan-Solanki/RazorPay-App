import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/sign_in/sign_in_screen.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_simple_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

bool seemore = false;

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key,
    @required this.product,
    @required this.currentVarient,
    this.quantity = 1,
  }) : super(key: key);

  final Product product;
  final int currentVarient;
  final int quantity;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState(
      product: this.product,
      currentVarient: currentVarient,
      quantity: quantity);
}

class _ProductDescriptionState extends State<ProductDescription> {
  final int currentVarient;
  final int quantity;
  _ProductDescriptionState({
    @required this.product,
    @required this.currentVarient,
    this.quantity = 1,
  });
  final Product product;
  bool sale = true;
  bool favor = false;
  String brandname = "";
  String soldby = "";

  List<dynamic> keys = [];

  String user_key;
  String authkey = '';

  Future<void> getAllProducts() async {
    ProductServices _services = ProductServices();
    var favref = await _services.favourites.doc(user_key).get();
    keys = favref["favourites"];

    if (keys.contains(widget.product.id)) {
      favor = true;
    }
    setState(() {});
    // list.add(SizedBox(width: getProportionateScreenHeight(20)));
  }

  Future<void> removeFavourite() async {
    ProductServices _services = ProductServices();
    print(user_key);
    var favref = await _services.favourites.doc(user_key).get();
    keys = favref["favourites"];
    keys.remove(widget.product.id);
    await _services.favourites.doc(user_key).update({'favourites': keys});
    setState(() {});
    // list.add(SizedBox(width: getProportionateScreenHeight(20)));
  }

  Future<void> getSellerName() async {
    ProductServices _services = new ProductServices();
    soldby = await _services.getSellerInfo(widget.product.sellerId);
    setState(() {});
  }

  Future<void> addFavourite() async {
    ProductServices _services = ProductServices();
    print(user_key);
    var favref = await _services.favourites.doc(user_key).get();
    keys = favref["favourites"];
    keys.add(widget.product.id);
    await _services.favourites.doc(user_key).update({'favourites': keys});
    setState(() {});
    // list.add(SizedBox(width: getProportionateScreenHeight(20)));
  }

  @override
  void initState() {
    authkey = UserSimplePreferences.getAuthKey() ?? '';
    if (authkey != "") {
      user_key = AuthProvider().user.uid;
      getAllProducts();
    }
    getSellerName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
          child: Text(product.title,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(20),
                color: Colors.black,
                height: 1.5,
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20),
              vertical: getProportionateScreenHeight(7)),
          child: Text(
            product.brandname,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(11),
              // fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20),
              vertical: getProportionateScreenHeight(0)),
          child: Text(
            "Sold by $soldby",
            style: TextStyle(fontSize: getProportionateScreenHeight(15)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(20)),
                child: Row(
                  children: [
                    Text(
                      "\₹${product.varients[currentVarient].price * quantity}",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(23),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenHeight(20),
                    ),
                    sale == true
                        ? Text(
                            "\₹${product.varients[currentVarient].comparedPrice * quantity}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: getProportionateScreenHeight(13),
                              // fontWeight: FontWeight.w600,
                              color: Color(0xFF6B6B6B),
                            ),
                          )
                        : Text(""),
                    SizedBox(
                      width: getProportionateScreenHeight(5),
                    ),
                    sale == true
                        ? Text(
                            "Sale",
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(14),
                              color: Colors.black,
                              // fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(""),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (authkey == '') {
                      Navigator.pushNamed(context, SignInScreen.routeName);
                    } else {
                      if (favor == true) {
                        favor = false;
                        removeFavourite();
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("Removed from Favourites"),
                          backgroundColor: kPrimaryColor2,
                        ));
                      } else {
                        favor = true;
                        addFavourite();
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("Added to Favourites"),
                          backgroundColor: kPrimaryColor2,
                        ));
                      }
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenHeight(15)),
                  width: getProportionateScreenHeight(64),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Heart Icon_2.svg",
                    color:
                        favor == true ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
                    height: getProportionateScreenHeight(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenHeight(20),
            right: getProportionateScreenHeight(64),
          ),
          child: seemore == true
              ? Text(
                  product.detail,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    height: 1.5,
                  ),
                )
              : Text(
                  product.detail,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20),
              vertical: 10,
            ),
            child: seemore == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        seemore = false;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "See Less Detail",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(14),
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        seemore = true;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "See More Detail",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(14),
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ))
      ],
    );
  }
}
