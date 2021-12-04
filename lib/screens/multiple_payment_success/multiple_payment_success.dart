import 'package:flutter/material.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:orev/screens/multiple_payment_success/components/MultiplePaymentSuccessMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/MultiplePaymentSuccessDesktop.dart';
import 'components/MultiplePaymentSuccessTablet.dart';
import 'components/body.dart';

class MultiplePaymentSuccess extends StatefulWidget {
  static String routeName = "/multiple_paymment_success";
  final bool transaction_success;
  final List<Order> order;
  final bool cod;
  final double orderTotal;
  MultiplePaymentSuccess(
      {@required this.transaction_success,
      @required this.order,
      @required this.orderTotal,
      @required this.cod});
  @override
  _MultiplePaymentSuccessState createState() => _MultiplePaymentSuccessState();
}

class _MultiplePaymentSuccessState extends State<MultiplePaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.transaction_success
                ? "Payment Success"
                : "Payment Failure"),
          ),
          body: ScreenTypeLayout(
            mobile: MultiplePaymentSuccessMobile(
                transaction: widget.transaction_success,
                order: widget.order,
                cod: widget.cod,
                orderTotal: widget.orderTotal),
            tablet: MultiplePaymentSuccessTablet(
                transaction: widget.transaction_success,
                order: widget.order,
                cod: widget.cod,
                orderTotal: widget.orderTotal),
            desktop: MultiplePaymentSuccessDesktop(
                transaction: widget.transaction_success,
                order: widget.order,
                cod: widget.cod,
                orderTotal: widget.orderTotal),
          ),
        ),
      ),
    );
  }
}
