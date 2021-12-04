import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:orev/screens/details/details_screen.dart';
import 'package:orev/screens/offer_and_category_screen/components/body.dart';
import 'package:orev/size_config.dart';

import '../../../constants.dart';
import 'OfferzoneCategoryMobile.dart';

class OfferzoneCard extends StatefulWidget {
  final OfferZone offer;
  OfferzoneCard({this.offer});

  @override
  _OfferzoneCardState createState() => _OfferzoneCardState();
}

class _OfferzoneCardState extends State<OfferzoneCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenHeight(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: kSecondaryColor.withOpacity(0.1),
        ),
        width: getProportionateScreenHeight(160),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              DetailsScreen.routeName,
              arguments: ProductDetailsArguments(product: widget.offer.product),
            );
          },
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            imageUrl: widget.offer.image,
            // widget.product.varients[defaultVarient].images[0],
            placeholder: (context, url) => new LoadingSkeleton(
              width: getProportionateScreenHeight(700),
              height: getProportionateScreenHeight(700),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
