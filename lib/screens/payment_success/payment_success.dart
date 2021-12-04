import 'package:flutter/material.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'components/PaymentSuccessDesktop.dart';
import 'components/PaymentSuccessMobile.dart';
import 'components/PaymentSuccessTablet.dart';
import 'components/body.dart';

class PaymentSuccess extends StatefulWidget {
  static String routeName = "/paymment_success";
  final bool transaction_success;
  final Order order;
  final bool cod;
  PaymentSuccess(
      {@required this.transaction_success,
      @required this.order,
      @required this.cod});
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
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
            mobile: PaymentSuccessMobile(
              transaction: widget.transaction_success,
              order: widget.order,
              cod: widget.cod,
            ),
            tablet: PaymentSuccessTablet(
              transaction: widget.transaction_success,
              order: widget.order,
              cod: widget.cod,
            ),
            desktop: PaymentSuccessDesktop(
              transaction: widget.transaction_success,
              order: widget.order,
              cod: widget.cod,
            ),
          ),
        ),
      ),
    );
  }
}
