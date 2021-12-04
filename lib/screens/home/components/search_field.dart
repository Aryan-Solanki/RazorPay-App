import 'package:flutter/material.dart';
import 'package:orev/components/search_page.dart';
import 'package:orev/screens/address/address.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  final bool simplebutton;
  final Function func;
  const SearchField({
    bool this.simplebutton = true,
    @required this.func,
    Key key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = "";

    return widget.simplebutton == true
        ? Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: getProportionateScreenHeight(15)),
            child: GestureDetector( 
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: getProportionateScreenHeight(13)),
                  height: getProportionateScreenHeight(65),
                  width: SizeConfig.screenWidth * 0.75,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: getProportionateScreenHeight(18),
                        color: kTextColor,
                      ),
                      SizedBox(
                        width: getProportionateScreenHeight(10),
                      ),
                      Text(
                        "Search product",
                        style: TextStyle(fontSize: getProportionateScreenHeight(14)),
                      )
                    ],
                  ),
                ),
              ),
          ),
        )
        : Expanded(
          child: Container(
              width: SizeConfig.screenWidth * 0.75,
              height: getProportionateScreenHeight(65),
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(fontSize: getProportionateScreenHeight(14)),
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    widget.func(value, false);
                    title = value;
                  },
                  onSubmitted: (value) {
                    widget.func(value, true);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(13)),
                      // horizontal: getProportionateScreenHeight(20),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "Search product",
                      hintStyle: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                      ),
                      prefixIcon: Icon(Icons.search,
                          size: getProportionateScreenHeight(18))),
                ),
              ),
            ),
        );
  }
}
