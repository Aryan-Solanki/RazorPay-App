import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:orev/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key key,
    @required this.product,
    @required this.currentVarient,
  }) : super(key: key);

  final Product product;
  final int currentVarient;

  @override
  _ProductImagesState createState() =>
      _ProductImagesState(currentVarient: currentVarient);
}

class _ProductImagesState extends State<ProductImages> {
  final int currentVarient;

  _ProductImagesState({
    @required this.currentVarient,
  });

  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenHeight(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
                tag: widget.product.id.toString(),
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: widget
                        .product.varients[currentVarient].images[selectedImage],
                    placeholder: (context, url) =>
                        new LoadingSkeleton(
                          width: getProportionateScreenHeight(1000),
                          height: getProportionateScreenHeight(1000),
                        ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                )),
          ),
        ),
        // SizedBox(height: getProportionateScreenHeight(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
                widget.product.varients[currentVarient].images.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenHeight(48),
        width: getProportionateScreenHeight(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(
            widget.product.varients[currentVarient].images[index]),
      ),
    );
  }
}
