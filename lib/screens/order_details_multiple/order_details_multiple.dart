import 'package:flutter/material.dart';
import 'package:orev/components/coustom_bottom_nav_bar.dart';
import 'package:orev/enums.dart';
import 'package:orev/models/Cart.dart';
import 'package:orev/models/Product.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/OrderDetailsMultipleDesktop.dart';
import 'components/OrderDetailsMultipleMobile.dart';
import 'components/OrderDetailsMultipleTablet.dart';
import 'components/body.dart';

class OrderDetailsMultiple extends StatefulWidget {
  const OrderDetailsMultiple({
    Key key,
    @required this.CartList,
    @required this.selectedaddress,
    @required this.totalCost,
    @required this.deliveryCost,
    @required this.newwalletbalance,
    @required this.oldwalletbalance,
    @required this.codSellerCost,
    @required this.onlinePayment,
    @required this.orevWalletMoneyUsed,
    @required this.usedOrevWallet,
  }) : super(key: key);

  final List<Cart> CartList;
  final double totalCost;
  final double deliveryCost;
  final double newwalletbalance;
  final double oldwalletbalance;
  final Map codSellerCost;
  final double orevWalletMoneyUsed;
  final bool onlinePayment;
  final bool usedOrevWallet;
  final Map<String, dynamic> selectedaddress;

  static String routeName = "/order_details_multiple";
  @override
  _OrderDetailsMultipleState createState() => _OrderDetailsMultipleState();
}

class _OrderDetailsMultipleState extends State<OrderDetailsMultiple> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: OrderDetailsMultipleMobile(
            key: UniqueKey(),
            CartList: widget.CartList,
            codSellerCharge: widget.codSellerCost,
            usedOrevWallet: widget.usedOrevWallet,
            selectedaddress: widget.selectedaddress,
            totalCost: widget.totalCost,
            deliveryCost: widget.deliveryCost,
            newwalletbalance: widget.newwalletbalance,
            oldwalletbalance: widget.oldwalletbalance,
            onlinePayment: widget.onlinePayment,
            orevWalletMoneyUsed: widget.orevWalletMoneyUsed,
          ),
          tablet: OrderDetailsMultipleTablet(
            key: UniqueKey(),
            CartList: widget.CartList,
            codSellerCharge: widget.codSellerCost,
            usedOrevWallet: widget.usedOrevWallet,
            selectedaddress: widget.selectedaddress,
            totalCost: widget.totalCost,
            deliveryCost: widget.deliveryCost,
            newwalletbalance: widget.newwalletbalance,
            oldwalletbalance: widget.oldwalletbalance,
            onlinePayment: widget.onlinePayment,
            orevWalletMoneyUsed: widget.orevWalletMoneyUsed,
          ),
          desktop: OrderDetailsMultipleDesktop(
            key: UniqueKey(),
            CartList: widget.CartList,
            codSellerCharge: widget.codSellerCost,
            usedOrevWallet: widget.usedOrevWallet,
            selectedaddress: widget.selectedaddress,
            totalCost: widget.totalCost,
            deliveryCost: widget.deliveryCost,
            newwalletbalance: widget.newwalletbalance,
            oldwalletbalance: widget.oldwalletbalance,
            onlinePayment: widget.onlinePayment,
            orevWalletMoneyUsed: widget.orevWalletMoneyUsed,
          ),
        ),
      ),
    );
  }
}
