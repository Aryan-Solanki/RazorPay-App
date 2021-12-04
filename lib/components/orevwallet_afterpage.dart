import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/wallet/wallet.dart';

import '../constants.dart';
import '../size_config.dart';
import 'default_button.dart';

class AfterOrevWallet extends StatefulWidget {

  final bool transaction;
  const AfterOrevWallet({Key key, @required this.transaction=false})
      : super(key: key);

  @override
  _AfterOrevWalletState createState() => _AfterOrevWalletState();
}

class _AfterOrevWalletState extends State<AfterOrevWallet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(10)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenHeight(10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
              child: Column(
                children: [
                  FittedBox(
                    child: Row(
                      children: [
                        widget.transaction == true
                            ? Text(
                          "Transaction Successful ",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(25),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                            : Text(
                          "Transaction Failed",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(25),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        widget.transaction == true
                            ? Center()
                            : Icon(
                          Icons.error,
                          color: Colors.red,
                          size: getProportionateScreenHeight(50),
                        )
                      ],
                    ),
                  ),
                  widget.transaction == true?Column(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(300),
                        child: Lottie.asset("assets/animation/success.json",
                            repeat: false),
                      ),
                      Text("₹500",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(40)),
                      ),
                      FittedBox(
                        child: Text(
                          "Successfully added to your Orev account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenHeight(15)),
                        ),
                      ),
                    ],
                  ):Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(80)),
                      Container(
                        padding:
                        EdgeInsets.all(getProportionateScreenHeight(15)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          // "The transaction was not processed due to the following error.\n ${widget.order.responseMsg}.\nIf your money was debited you will get a refund within 24hrs.",
                          "The transaction was not processed due to the following error.\nIf your money was debited you will get a refund within 24hrs.",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenHeight(18)),
                        ),
                      ),
                      Text(
                        "12:00:45 PM IST",
                        // "${widget.order.timestamp}",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(14)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(80),
                  ),
                  DefaultButton(
                    color: kPrimaryColor2,
                    text: "Move to Wallet",
                    press: () {
                      Navigator.pushReplacementNamed(context, Wallet.routeName);
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
