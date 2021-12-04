import 'package:flutter/material.dart';
import 'package:orev/components/coustom_bottom_nav_bar.dart';
import 'package:orev/enums.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/Order_Details/components/OrderDetailsMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/OrderDetailsDesktop.dart';
import 'components/OrderDetailsTablet.dart';
import 'components/body.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    Key key,
    @required this.product,
    @required this.currentVarient,
    @required this.quantity,
    @required this.selectedaddress,
    @required this.totalCost,
    @required this.deliveryCost,
    @required this.newwalletbalance,
    @required this.oldwalletbalance,
    @required this.usedorevwallet,
    @required this.codSellerCharge,
    @required this.orevWalletMoneyUsed,
  }) : super(key: key);

  final Product product;
  final int currentVarient;
  final int quantity;
  final double totalCost;
  final double deliveryCost;
  final double newwalletbalance;
  final double oldwalletbalance;
  final bool usedorevwallet;
  final double codSellerCharge;
  final double orevWalletMoneyUsed;
  final Map<String, dynamic> selectedaddress;

  static String routeName = "/order_details";
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: OrderDetailsMobile(
              key: UniqueKey(),
              product: widget.product,
              currentVarient: widget.currentVarient,
              quantity: widget.quantity,
              orevWalletMoneyUsed: widget.orevWalletMoneyUsed,
              codSellerCharge: widget.codSellerCharge,
              selectedaddress: widget.selectedaddress,
              totalCost: widget.totalCost,
              deliveryCost: widget.deliveryCost,
              newwalletbalance: widget.newwalletbalance,
              oldwalletbalance: widget.oldwalletbalance,
              usedOrevWallet: widget.usedorevwallet),
          tablet: OrderDetailsTablet(
              key: UniqueKey(),
              product: widget.product,
              currentVarient: widget.currentVarient,
              quantity: widget.quantity,
              orevWalletMoneyUsed: widget.orevWalletMoneyUsed,
              codSellerCharge: widget.codSellerCharge,
              selectedaddress: widget.selectedaddress,
              totalCost: widget.totalCost,
              deliveryCost: widget.deliveryCost,
              newwalletbalance: widget.newwalletbalance,
              oldwalletbalance: widget.oldwalletbalance,
              usedOrevWallet: widget.usedorevwallet),
          desktop: OrderDetailsDesktop(
              key: UniqueKey(),
              product: widget.product,
              currentVarient: widget.currentVarient,
              quantity: widget.quantity,
              orevWalletMoneyUsed: widget.orevWalletMoneyUsed,
              codSellerCharge: widget.codSellerCharge,
              selectedaddress: widget.selectedaddress,
              totalCost: widget.totalCost,
              deliveryCost: widget.deliveryCost,
              newwalletbalance: widget.newwalletbalance,
              oldwalletbalance: widget.oldwalletbalance,
              usedOrevWallet: widget.usedorevwallet),
        ),
      ),
    );
  }
}
