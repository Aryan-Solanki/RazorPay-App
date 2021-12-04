import 'package:flutter/material.dart';
import 'package:orev/components/rounded_icon_btn.dart';
import 'package:orev/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ColorDots extends StatelessWidget {
  const ColorDots({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    int selectedColor = 3;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
      child: Row(
        children: [
          ...List.generate(
            product.varients.length,
            (index) => ColorDot(
              color: Colors.lightGreen,
              isSelected: index == selectedColor,
            ),
          ),
          Spacer(),
          RoundedIconBtn(
            icon: Icon(
              Icons.remove,
              color: Colors.black,
            ),
            press: () {},
          ),
          SizedBox(width: getProportionateScreenHeight(20)),
          RoundedIconBtn(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            showShadow: true,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key key,
    @required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenHeight(8)),
      height: getProportionateScreenHeight(40),
      width: getProportionateScreenHeight(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? kPrimaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
