import 'package:flutter/material.dart';
import 'package:orev/models/Cart.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenHeight(10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(cart.product.varients[0].images[0]),
            ),
          ),
        ),
        SizedBox(width: 20),
        Text(
          cart.product.title,
          style: TextStyle(color: Colors.black, fontSize: 16),
          maxLines: 2,
        ),
      ],
    );
  }
}
