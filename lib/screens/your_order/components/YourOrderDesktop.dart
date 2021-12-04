import 'package:flutter/material.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Cart.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/your_order/components/your_order_cart.dart';

import '../../../size_config.dart';

class YourOrderDesktop extends StatefulWidget {
  final List<dynamic> keys;
  final Function() notifyParent;
  const YourOrderDesktop({
    Key key,
    this.keys,
    @required this.notifyParent,
  }) : super(key: key);
  @override
  _YourOrderDesktopState createState() => _YourOrderDesktopState(keys: keys);
}

class _YourOrderDesktopState extends State<YourOrderDesktop> {
  List<Order> keys;
  _YourOrderDesktopState({@required this.keys});

  String user_key;

  @override
  void initState() {
    user_key = AuthProvider().user.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        widget.notifyParent();
      });
    }

    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        HomeHeader(),
        SizedBox(height: getProportionateScreenHeight(10)),
        keys.length != 0
            ? Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(20)),
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: kPrimaryColor2,
                      child: ListView.builder(
                        itemCount: keys.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: YouOrderCard(
                              order: keys[index],
                              notifyParent: refresh,
                              key: UniqueKey(),
                              orders: keys),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Expanded(
                child: Center(
                child: Text(
                  "No products ordered yet",
                  style: TextStyle(fontSize: getProportionateScreenHeight(15)),
                ),
              )),
      ],
    );
  }
}
