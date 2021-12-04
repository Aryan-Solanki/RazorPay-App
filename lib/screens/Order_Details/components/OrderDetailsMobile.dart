import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/models/OrderProduct.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/Order_Details/components/price_cart.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/payment_success/payment_success.dart';
import 'package:orev/screens/your_order/your_order.dart';
import 'package:orev/services/order_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:paytm/paytm.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'order_info.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderDetailsMobile extends StatefulWidget {
  const OrderDetailsMobile({
    Key key,
    @required this.product,
    @required this.currentVarient,
    @required this.quantity,
    @required this.selectedaddress,
    @required this.totalCost,
    @required this.deliveryCost,
    @required this.newwalletbalance,
    @required this.oldwalletbalance,
    @required this.codSellerCharge,
    @required this.orevWalletMoneyUsed,
    @required this.usedOrevWallet,
  }) : super(key: key);

  final Product product;
  final int currentVarient;
  final int quantity;
  final double totalCost;
  final double deliveryCost;
  final double newwalletbalance;
  final double oldwalletbalance;
  final bool usedOrevWallet;
  final double codSellerCharge;
  final double orevWalletMoneyUsed;
  final Map<String, dynamic> selectedaddress;

  @override
  _OrderDetailsMobileState createState() => _OrderDetailsMobileState();
}

class _OrderDetailsMobileState extends State<OrderDetailsMobile> {
  Razorpay _razorpay;
  String payment_response;
  @override




  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_dMT9wqbYaXcVGJ',
      'amount': 2000,
      'name': 'Razor Pay',
      'description': 'Organic Food',
      'prefill': {'contact': '7983927625', 'email': 'solankiaryan5@hotmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      // debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("success");
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("fail");
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }








  String mid = "LsrZNj54827134067770";
  String PAYTM_MERCHANT_KEY = "eMQRe_MdiSf0cuih";
  String website = "DEFAULT";
  bool testing = false;
  bool loading = false;

  String transactionId = "";


  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        HomeHeader(),
        SizedBox(height: getProportionateScreenHeight(10)),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: kPrimaryColor2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(20)),
                  child: Column(
                    children: [
                      TotalPrice(
                          key: UniqueKey(),
                          onlinePayment: true,
                          walletAmountUsed: widget.orevWalletMoneyUsed,
                          codSellerCost: widget.codSellerCharge,
                          transactionId: transactionId,
                          product: widget.product,
                          currentVarient: widget.currentVarient,
                          quantity: widget.quantity,
                          totalCost: widget.totalCost,
                          deliveryCost: widget.deliveryCost),
                      SizedBox(
                        height: getProportionateScreenHeight(25),
                      ),
                      OrderInfo(
                        key: UniqueKey(),
                        product: widget.product,
                        currentVarient: widget.currentVarient,
                        quantity: widget.quantity,
                        selectedaddress: widget.selectedaddress,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "By placing your order, you agree to Orev's privacy notice and conditions of use.",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(12)),
                          )),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "If you choose to pay using an electronic payment method (credit card or debit card), you will be directed to your bank's website to complete your payment. Your contract to purchase an item will not be complete until we receive your electronic payment and dispatch your item. If you choose to pay using Pay on Delivery (POD), you can pay using cash/card/net banking when you receive your item.",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(12)),
                          )),
                      SizedBox(
                        height: getProportionateScreenHeight(80),
                      ),
                      RoundedLoadingButton(
                        successColor: kPrimaryColor,
                        duration: Duration(milliseconds: 1300),
                        width: getProportionateScreenHeight(500),
                        height: getProportionateScreenHeight(56),
                        color: kPrimaryColor2,
                        child: Text("  Place Order  ",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(18),
                                color: Colors.white)),
                        controller: _btnController,
                        onPressed: openCheckout,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
