import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orev/size_config.dart';

import '../../../constants.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20), vertical: getProportionateScreenHeight(10)),
      child: FlatButton(
        padding: EdgeInsets.all(getProportionateScreenHeight(20)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            icon==""?Icon(Icons.account_balance_outlined,color: kPrimaryColor,size: getProportionateScreenHeight(20)):SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: getProportionateScreenHeight(18),
            ),
            SizedBox(width: getProportionateScreenHeight(20)),
            Expanded(child: Text(text,style: TextStyle(fontSize: getProportionateScreenHeight(13)),)),
            Icon(Icons.arrow_forward_ios,size: 
              getProportionateScreenHeight(18),),
          ],
        ),
      ),
    );
  }
}
