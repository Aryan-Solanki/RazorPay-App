import 'package:flutter/material.dart';
import 'package:orev/screens/seemore/seemore.dart';

import '../../../size_config.dart';

class SectionTitle extends StatefulWidget {
  const SectionTitle({
    Key key,
    @required this.title,
    @required this.press,
    @required this.categoryId,
    @required this.seemore = true,
  }) : super(key: key);

  final String title;
  final String categoryId;
  final GestureTapCallback press;
  final bool seemore;

  @override
  _SectionTitleState createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: getProportionateScreenHeight(18),
            color: Colors.black,
          ),
        ),
        widget.seemore == true
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeeMore(
                              categoryId: widget.categoryId,
                              title: widget.title)));
                  // Navigator.pushNamed(context, SeeMore.routeName);
                },
                child: Text(
                  "See More",
                  style: TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: getProportionateScreenHeight(12)),
                ),
              )
            : Text(""),
      ],
    );
  }
}

// class SectionTitle extends StatelessWidget {
//   const SectionTitle({
//     Key key,
//     @required this.title,
//     @required this.press,
//     @required this.categoryId,
//     @required this.seemore = true,
//   }) : super(key: key);
//
//   final String title;
//   final String categoryId;
//   final GestureTapCallback press;
//   final bool seemore;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: getProportionateScreenHeight(18),
//             color: Colors.black,
//           ),
//         ),
//         seemore == true
//             ? GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SeeMore(
//                                 categoryId: categoryId,
//                               )));
//                   // Navigator.pushNamed(context, SeeMore.routeName);
//                 },
//                 child: Text(
//                   "See More",
//                   style: TextStyle(color: Color(0xFFBBBBBB)),
//                 ),
//               )
//             : Text(""),
//       ],
//     );
//   }
// }
