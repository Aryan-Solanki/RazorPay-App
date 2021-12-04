import 'package:flutter/material.dart';
import 'package:orev/components/fullwidth_product_cart.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/home/components/section_title.dart';
import 'package:orev/services/product_services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class AllItems extends StatefulWidget {
  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  List<Product> ProductList = [];
  List<dynamic> keys = [];

  String user_key;

  Future<void> removeFavourite12(productId) async {
    ProductServices _services = ProductServices();
    print(user_key);
    var favref = await _services.favourites.doc(user_key).get();
    keys = favref["favourites"];
    keys.remove(productId);
    await _services.favourites.doc(user_key).update({'favourites': keys});
  }

  Future<List> getVarientNumber(id, productId) async {
    ProductServices _services = ProductServices();
    var product = await _services.getProduct(productId);
    var varlist = product.varients;
    int ind = 0;
    bool foundit = false;
    for (var varient in varlist) {
      if (varient.id == id) {
        foundit = true;
        break;
      }
      ind += 1;
    }
    return [ind, foundit];
  }

  Future<void> getAllProducts() async {
    ProductServices _services = ProductServices();
    print(user_key);
    var favref = await _services.favourites.doc(user_key).get();
    keys = favref["favourites"];

    for (var k in keys) {
      var document = await _services.products.doc(k).get();
      if (!document.exists) {
        removeFavourite12(k);
      } else {
        int index = 0;
        for (var i in document["variant"]) {
          if (i["default"] == true) {
            break;
          }
          index += 1;
        }

        var checklist = await getVarientNumber(
            document["variant"][index]["id"], document["productId"]);
        var xx = checklist[0];
        var y = checklist[1];
        if (!y) {
          removeFavourite12(k);
          continue;
        }
        var listVarientraw = document["variant"];
        print(listVarientraw);
        List<Varient> listVarient = [];
        for (var vari in listVarientraw) {
          print(vari["variantDetails"]["title"]);
          print(vari["variantDetails"]["title"]);
          listVarient.add(new Varient(
              id: vari["id"],
              default_product: vari["default"],
              isOnSale: vari["onSale"]["isOnSale"],
              comparedPrice: vari["onSale"]["comparedPrice"].toDouble(),
              discountPercentage:
                  vari["onSale"]["discountPercentage"].toDouble(),
              price: vari["price"].toDouble(),
              inStock: vari["stock"]["inStock"],
              qty: vari["stock"]["qty"],
              title: vari["variantDetails"]["title"],
              images: vari["variantDetails"]["images"]));
        }

        ProductList.add(new Product(
            id: document["productId"],
            brandname: document["brand"],
            varients: listVarient,
            title: document["title"],
            detail: document["detail"],
            rating: document["rating"],
            isFavourite: false,
            sellerId: document["sellerId"],
            isPopular: true,
            tax: document["tax"].toDouble(),
            youmayalsolike: document["youMayAlsoLike"]));
      }

      print(ProductList.length);
      print(ProductList.length);
      setState(() {});
      // list.add(SizedBox(width: getProportionateScreenHeight(20)));
    }
  }

  @override
  void initState() {
    user_key = AuthProvider().user.uid;
    getAllProducts();
    super.initState();
  }

  Future<void> removeFavourite(productId) async {
    ProductServices _services = ProductServices();
    print(user_key);
    var favref = await _services.favourites.doc(user_key).get();
    keys = favref["favourites"];
    keys.remove(productId);
    await _services.favourites.doc(user_key).update({'favourites': keys});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        HomeHeader(),
        SizedBox(height: getProportionateScreenHeight(10)),
        ProductList.length != 0
            ? Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: kPrimaryColor2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(
                            ProductList.length,
                            (index) {
                              return Dismissible(
                                key: Key(ProductList[index].id.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  setState(() {
                                    removeFavourite(ProductList[index].id);
                                    ProductList.removeAt(index);
                                  });
                                },
                                background: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      SvgPicture.asset(
                                          "assets/icons/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: FullWidthProductCard(
                                  product: ProductList[index],
                                  like: false,
                                ),
                              );

                              return SizedBox
                                  .shrink(); // here by default width and height is 0
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Expanded(
                child: Center(
                  child: Text(
                    "No item available",
                    style: TextStyle(fontSize: getProportionateScreenHeight(15)),
                  ),
                ),
              ),
        SizedBox(height: getProportionateScreenHeight(10)),
      ],
    );
  }
}
