import 'package:flutter/material.dart';
import 'package:orev/components/product_card.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/services/product_services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class HorizontalSlider extends StatefulWidget {
  final List keys;
  final String card_title;
  final String categoryId;
  const HorizontalSlider({Key key, this.keys, this.card_title, this.categoryId})
      : super(key: key);
  @override
  _HorizontalSliderState createState() => _HorizontalSliderState(keys: keys);
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  final List keys;
  _HorizontalSliderState({this.keys});

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
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      ProductList.length,
                          (index) {
                        return ProductCard(product: ProductList[index],width: 200,);
                        // return SizedBox
                        //     .shrink(); // here by default width and height is 0
                      },
                    ),
                    SizedBox(width: getProportionateScreenHeight(20)),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    ProductList.length,
                        (index) {
                      return ProductCard(product: ProductList[index],);
                      // return SizedBox
                      //     .shrink(); // here by default width and height is 0
                    },
                  ),
                  SizedBox(width: getProportionateScreenHeight(20)),
                ],
              ),
            );
          },
        ),

      ],
    );
  }
}
