import 'package:flutter/material.dart';
import 'package:orev/components/product_card.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/services/product_services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class ThreeGrid extends StatefulWidget {
  final List keys;
  final String card_title;
  final String categoryId;
  const ThreeGrid({Key key, this.keys, this.card_title, this.categoryId})
      : super(key: key);
  @override
  _ThreeGridState createState() =>
      _ThreeGridState(keys: keys, categoryId: categoryId);
}

class _ThreeGridState extends State<ThreeGrid> {
  final List keys;
  final String categoryId;
  _ThreeGridState({this.keys, this.categoryId});

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
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Check the sizing information here and return your UI
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return Column(
            children: [
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
                child: SectionTitle(
                  title: widget.card_title,
                  press: () {},
                  categoryId: widget.categoryId,
                  seemore: true,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              ProductList.length == 0
                  ? SkeletonListView()
                  : Row(
                children: [
                  Expanded(
                    child: ProductCard(
                        aspectRetio: 0.89, product: ProductList[1]),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ProductCard(product: ProductList[1]),
                        SizedBox(
                          height: getProportionateScreenHeight(7),
                        ),
                        ProductCard(product: ProductList[1])
                      ],
                    ),
                  ),
                  Expanded(
                    child: ProductCard(
                        aspectRetio: 0.89, product: ProductList[1]),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ProductCard(product: ProductList[1]),
                        SizedBox(
                          height: getProportionateScreenHeight(7),
                        ),
                        ProductCard(product: ProductList[1])
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Column(
            children: [
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
                child: SectionTitle(
                  title: widget.card_title,
                  press: () {},
                  categoryId: widget.categoryId,
                  seemore: true,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              ProductList.length == 0
                  ? SkeletonListView()
                  : Row(
                children: [
                  Expanded(
                    child: ProductCard(
                        aspectRetio: 0.89, product: ProductList[1]),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ProductCard(product: ProductList[1]),
                        SizedBox(
                          height: getProportionateScreenHeight(7),
                        ),
                        ProductCard(product: ProductList[1])
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ProductCard(product: ProductList[1]),
                        SizedBox(
                          height: getProportionateScreenHeight(7),
                        ),
                        ProductCard(product: ProductList[1])
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Column(
          children: [
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
              child: SectionTitle(
                title: widget.card_title,
                press: () {},
                categoryId: widget.categoryId,
                seemore: true,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            ProductList.length == 0
                ? SkeletonListView()
                : Row(
              children: [
                Expanded(
                  child: ProductCard(
                      aspectRetio: 0.89, product: ProductList[1]),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ProductCard(product: ProductList[1]),
                      SizedBox(
                        height: getProportionateScreenHeight(7),
                      ),
                      ProductCard(product: ProductList[1])
                    ],
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

