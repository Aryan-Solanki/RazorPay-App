import 'package:flutter/material.dart';
import 'package:orev/components/product_card.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/services/product_services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class FourGrid extends StatefulWidget {
  final List keys;
  final String card_title;
  final String categoryId;
  const FourGrid({Key key, this.keys, this.card_title, this.categoryId})
      : super(key: key);
  @override
  _FourGridState createState() => _FourGridState(keys: keys);
}

class _FourGridState extends State<FourGrid> {
  final List keys;
  _FourGridState({this.keys});

  List<Product> ProductList = [];

  Future<void> getAllCategories() async {
    ProductServices _services = ProductServices();

    for (var k in keys) {
      Product product = await _services.getProduct(k);
      ProductList.add(product);
    }
    setState(() {});
    // list.add(SizedBox(width: getProportionateScreenHeight(20)));
  }

  @override
  void initState() {
    getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
          child: SectionTitle(
            title: widget.card_title,
            press: () {},
            seemore: true,
            categoryId: widget.categoryId,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        ResponsiveBuilder(
          builder: (context, sizingInformation) {
            // Check the sizing information here and return your UI
            if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: ProductCard(product: ProductList[0])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15),),
                  Row(
                    children: [
                      Expanded(child: ProductCard(product: ProductList[2])),
                      Expanded(child: ProductCard(product: ProductList[3])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                    ],
                  )
                ],
              );
            }

            if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: ProductCard(product: ProductList[0])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15),),
                  Row(
                    children: [
                      Expanded(child: ProductCard(product: ProductList[2])),
                      Expanded(child: ProductCard(product: ProductList[3])),
                      Expanded(child: ProductCard(product: ProductList[1])),
                    ],
                  )
                ],
              );
            }

            if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: ProductCard(product: ProductList[0])),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15),),
                  Row(
                    children: [
                      Expanded(child: ProductCard(product: ProductList[2])),
                    ],
                  )
                ],
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: ProductCard(product: ProductList[0])),
                    Expanded(child: ProductCard(product: ProductList[1])),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(15),),
                Row(
                  children: [
                    Expanded(child: ProductCard(product: ProductList[2])),
                    Expanded(child: ProductCard(product: ProductList[3])),
                  ],
                )
              ],
            );
          },
        ),

      ],
    );
  }
}
