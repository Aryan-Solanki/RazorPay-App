import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/constants.dart';
import 'package:orev/screens/your_order/your_order.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/details/details_screen.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';

import '../../../size_config.dart';

class PaymentSuccessTablet extends StatefulWidget {
  final bool transaction;
  final Order order;
  final bool cod;
  PaymentSuccessTablet(
      {@required this.transaction, @required this.order, @required this.cod});
  @override
  _PaymentSuccessTabletState createState() => _PaymentSuccessTabletState();
}

class _PaymentSuccessTabletState extends State<PaymentSuccessTablet> {
  String username = "";
  String userphone = "";
  String sellername = "";

  Future<void> getUserInfo() async {
    UserServices _services = new UserServices();
    var user = await _services.getUserById(widget.order.userId);
    username = user["name"];
    userphone = user["number"];
    setState(() {});
  }

  Future<void> getSellerInfo() async {
    ProductServices _services = new ProductServices();
    sellername = await _services.getSellerInfo(widget.order.product.sellerId);
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    getSellerInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool transaction=false;
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: kPrimaryColor2,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              "Transaction Failed ",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                      widget.transaction == true
                          ? Icon(
                              Icons.check_circle,
                              color: kPrimaryColor,
                              size: getProportionateScreenHeight(50),
                            )
                          : Icon(
                              Icons.error,
                              color: Colors.red,
                              size: getProportionateScreenHeight(50),
                            )
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                widget.transaction == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi $username,",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: getProportionateScreenHeight(18),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize:
                                            getProportionateScreenHeight(15)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "Thank you for placing order with us.Your order ",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(15),
                                          )),
                                      TextSpan(
                                          text:
                                              '"${widget.order.product.title}"',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              ProductServices _services =
                                                  new ProductServices();
                                              Product product =
                                                  await _services.getProduct(
                                                      widget.order.product.id);
                                              Navigator.pushNamed(
                                                context,
                                                DetailsScreen.routeName,
                                                arguments:
                                                    ProductDetailsArguments(
                                                        product: product),
                                              );
                                            }),
                                      TextSpan(
                                          text:
                                              "\n is being processed by our delivery team, and you will soon receive a confirmation from our side.",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(15),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          Text(
                            "Transition Details ",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          Container(
                            width: double.maxFinite,
                            padding:
                                EdgeInsets.all(getProportionateScreenHeight(15)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date: ${widget.order.timestamp} IST",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenHeight(14),
                                      color: Colors.black),
                                ),
                                Text(
                                  "Seller: $sellername",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenHeight(14),
                                      color: Colors.black),
                                ),
                                Text(
                                  "Order Id: ${widget.order.orderId}",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenHeight(14),
                                      color: Colors.black),
                                ),
                                Text(
                                  "Status: Successful",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenHeight(14),
                                      color: Colors.black),
                                ),
                                Text(
                                  widget.cod
                                      ? "Payment Method: Cash On Delivery"
                                      : "Payment Method: Online",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenHeight(14),
                                      color: Colors.black),
                                ),
                                Text(
                                  "Transition amount: ₹${widget.order.totalCost}",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenHeight(14),
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          Text(
                            "Billing Address",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(20),
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          Container(
                            width: double.maxFinite,
                            padding:
                                EdgeInsets.all(getProportionateScreenHeight(15)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${widget.order.selectedAddress["adline1"]}",
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        color: Colors.black)),
                                Text(
                                    "${widget.order.selectedAddress["adline2"]}",
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        color: Colors.black)),
                                Text(
                                    "${widget.order.selectedAddress["city"]}-${widget.order.selectedAddress["pincode"].toString()}",
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        color: Colors.black)),
                                Text("Phone number: ${userphone}",
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                        ],
                      )
                    : Column(
                        children: [
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
                              "The transaction was not processed due to the following error.\n ${widget.order.responseMsg}.\nIf your money was debited you will get a refund within 24hrs.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenHeight(18)),
                            ),
                          ),
                          Text(
                            "${widget.order.timestamp}",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(14)),
                          ),
                          Text("Transaction ID: Not Generated",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(14))),
                        ],
                      ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                DefaultButton(
                  color: kPrimaryColor2,
                  text: "Manage Orders",
                  press: () {
                    Navigator.pushNamed(context, YourOrder.routeName);
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
