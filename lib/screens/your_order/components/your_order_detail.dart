import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/components/return_or_cancel.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/screens/details/details_screen.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:orev/services/order_services.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../size_config.dart';

class YourOrderDetail extends StatefulWidget {
  final Order order;
  final List<Order> orders;
  static String routeName = "/your_order_detail";
  YourOrderDetail({@required this.order, @required this.orders});
  @override
  _YourOrderDetailState createState() => _YourOrderDetailState();
}

class _YourOrderDetailState extends State<YourOrderDetail> {
  @override
  static String routeName = "/your_order_detail";

  String username = "";
  String userphone = "";
  String sellername = "";

  String transactionId;
  double codCharges = 0.0;
  double delivery = 0.0;
  double itemsCost = 0.0;
  double orderTotal = 0.0;
  double wallet = 0.0;

  getTransactionDetails() async {
    transactionId = widget.order.transactionId;
    OrderServices _services = new OrderServices();
    var doc = await _services.getTransactions(transactionId);
    codCharges = doc["codCharges"].toDouble();
    delivery = doc["delivery"].toDouble();
    itemsCost = doc["itemsCost"].toDouble();
    orderTotal = doc["orderTotal"].toDouble();
    wallet = doc["wallet"].toDouble();
    setState(() {});
  }

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

  Product product;

  Future<List> getVarientNumber(id, productId) async {
    ProductServices _services = ProductServices();
    var product = await _services.getProduct(productId);
    var varlist = product.varients;
    int ind = 0;
    bool foundit = false;
    for (var varient in varlist) {
      if (varient.id == id) {
        foundit = true;
        break;
      }
      ind += 1;
    }
    return [ind, foundit];
  }

  getProduct() async {
    ProductServices _services = new ProductServices();
    product = await _services.getProduct(widget.order.product.id);
  }

  @override
  void initState() {
    getUserInfo();
    getSellerInfo();
    getTransactionDetails();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String return_cancel_value = widget.order.orderStatus == "Ordered"
        ? ""
        : widget.order.orderStatus == "Canceled"
            ? "Canceled"
            : widget.order.orderStatus == "Returning"
                ? "Returning"
                : widget.order.orderStatus == "Returned"
                    ? "Returned"
                    : ""; // cancel , return ,
    bool invoice = widget.order.invoice != "";
    String invoiceLink = widget.order.invoice;
    final double _orderState = 0;
    final double _packedState = 10;
    final double _shippedState = 20;
    final double _deliveredState = 30;
    final Color _activeColor = kPrimaryColor;
    final Color _inactiveColor = kPrimaryColor;
    bool cancelavailable;

    if (widget.order.orderStatus == "Delivered") {
      cancelavailable = false;
    } else {
      cancelavailable = true;
    }

    double _deliveryStatus = _orderState;

    if (widget.order.orderStatus == "Ordered") {
      _deliveryStatus = _orderState;
    } else if (widget.order.orderStatus == "Packed") {
      _deliveryStatus = _packedState;
    } else if (widget.order.orderStatus == "Shipped") {
      _deliveryStatus = _shippedState;
    } else if (widget.order.orderStatus == "Delivered") {
      _deliveryStatus = _deliveredState;
    } else if (widget.order.orderStatus == "Returning") {
      _deliveryStatus = 0;
    } else if (widget.order.orderStatus == "Returned") {
      _deliveryStatus = 30;
    }

    void launchURL() async => await canLaunch(invoiceLink)
        ? await launch(invoiceLink)
        : throw 'Could not launch $invoiceLink';

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  DetailsScreen.routeName,
                                  arguments:
                                      ProductDetailsArguments(product: product),
                                );
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.order.product.title}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        16)),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(5),
                                          ),
                                          Text(
                                              "${widget.order.product.variant.title}",
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          12))),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(5),
                                          ),
                                          Text("Qty : ${widget.order.qty}",
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          12))),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(5),
                                          ),
                                          Text("Seller : $sellername",
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          12))),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: getProportionateScreenHeight(100),
                                      width: getProportionateScreenHeight(100),
                                      child: Image.network(
                                          "${widget.order.product.variant.images[0]}"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            return_cancel_value == ""
                                ? Center()
                                : Divider(color: Colors.black),
                            return_cancel_value == ""
                                ? Center()
                                : Text(
                                    return_cancel_value == "Returned"
                                        ? "This order has been returned.\nYou will receive a reimbursement in your Orev Wallet within 1-2 days."
                                        : return_cancel_value == "Returning"
                                            ? "Your order is being processed for return.\nAfter you return the goods, you will receive a reimbursement in your Orev Wallet within 1-2 days."
                                            : "This order has been cancelled.\nYou return the goods, you will receive a reimbursement in your Orev Wallet within 1-2 days.",
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                            Divider(color: Colors.black),
                            return_cancel_value == "Canceled"
                                ? Center()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      return_cancel_value == "Canceled"
                                          ? Center()
                                          : Text(
                                              return_cancel_value == "Returned"
                                                  ? "Returning Address"
                                                  : "Shipping Address",
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          25),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Text(""),
                                      Container(
                                        padding: EdgeInsets.all(
                                            getProportionateScreenHeight(15)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors
                                                  .black45, // red as border color
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${widget.order.selectedAddress["name"]}",
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionateScreenHeight(
                                                                20),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            5),
                                                  ),
                                                  Text(
                                                      "${widget.order.selectedAddress["adline1"]}",
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  14))),
                                                  Text(
                                                      "${widget.order.selectedAddress["adline2"]}",
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  14))),
                                                  Text(
                                                      "${widget.order.selectedAddress["city"]}-${widget.order.selectedAddress["pincode"].toString()}",
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  14))),
                                                  Text(
                                                      "Phone number: $userphone",
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  14))),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        200),
                                                child: SfLinearGauge(
                                                  orientation:
                                                      LinearGaugeOrientation
                                                          .vertical,
                                                  minimum: 0,
                                                  maximum:
                                                      return_cancel_value == ""
                                                          ? 30
                                                          : 20,
                                                  labelOffset: 24,
                                                  isAxisInversed: true,
                                                  showTicks: false,
                                                  onGenerateLabels: () {
                                                    return return_cancel_value ==
                                                            ""
                                                        ? <LinearAxisLabel>[
                                                            const LinearAxisLabel(
                                                                text: 'Ordered',
                                                                value: 0),
                                                            const LinearAxisLabel(
                                                                text: 'Packed',
                                                                value: 10),
                                                            const LinearAxisLabel(
                                                                text: 'Shipped',
                                                                value: 20),
                                                            const LinearAxisLabel(
                                                                text:
                                                                    'Delivered',
                                                                value: 30),
                                                          ]
                                                        : <LinearAxisLabel>[
                                                            const LinearAxisLabel(
                                                                text:
                                                                    'Return Accepted',
                                                                value: 0),
                                                            const LinearAxisLabel(
                                                                text:
                                                                    'On the way',
                                                                value: 10),
                                                            const LinearAxisLabel(
                                                                text:
                                                                    'Returned',
                                                                value: 20),
                                                          ];
                                                  },
                                                  axisTrackStyle:
                                                      LinearAxisTrackStyle(
                                                    color: _activeColor,
                                                  ),
                                                  barPointers: <
                                                      LinearBarPointer>[
                                                    LinearBarPointer(
                                                      value: _deliveryStatus,
                                                      color: _activeColor,
                                                      enableAnimation: false,
                                                      position:
                                                          LinearElementPosition
                                                              .cross,
                                                    ),
                                                  ],
                                                  markerPointers: <
                                                      LinearMarkerPointer>[
                                                    LinearWidgetPointer(
                                                      value: _orderState,
                                                      enableAnimation: false,
                                                      position:
                                                          LinearElementPosition
                                                              .cross,
                                                      child: Container(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        height:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                _deliveryStatus >
                                                                        0
                                                                    ? _activeColor
                                                                    : Colors
                                                                        .white,
                                                            border: Border.all(
                                                                width: 4,
                                                                color:
                                                                    _activeColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                      ),
                                                    ),
                                                    LinearWidgetPointer(
                                                      enableAnimation: false,
                                                      value: _packedState,
                                                      position:
                                                          LinearElementPosition
                                                              .cross,
                                                      child: Container(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        height:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                _deliveryStatus >
                                                                        10
                                                                    ? _activeColor
                                                                    : Colors
                                                                        .white,
                                                            border: Border.all(
                                                                width: 4,
                                                                color:
                                                                    _activeColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                      ),
                                                    ),
                                                    LinearWidgetPointer(
                                                      value: _shippedState,
                                                      enableAnimation: false,
                                                      position:
                                                          LinearElementPosition
                                                              .cross,
                                                      child: Container(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        height:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                _deliveryStatus >
                                                                        20
                                                                    ? _activeColor
                                                                    : Colors
                                                                        .white,
                                                            border: Border.all(
                                                                width: 4,
                                                                color:
                                                                    _activeColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                      ),
                                                    ),
                                                    LinearWidgetPointer(
                                                      value: _deliveredState,
                                                      enableAnimation: false,
                                                      position:
                                                          LinearElementPosition
                                                              .cross,
                                                      child: Container(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        height:
                                                            getProportionateScreenHeight(
                                                                14),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                _deliveryStatus >
                                                                        30
                                                                    ? _activeColor
                                                                    : Colors
                                                                        .white,
                                                            border: Border.all(
                                                                width: 4,
                                                                color:
                                                                    _activeColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                      ),
                                                    ),
                                                    LinearShapePointer(
                                                      animationDuration: 2000,
                                                      value: _deliveryStatus,
                                                      enableAnimation: true,
                                                      color: _activeColor,
                                                      width:
                                                          getProportionateScreenHeight(
                                                              14),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              14),
                                                      position:
                                                          LinearElementPosition
                                                              .cross,
                                                      shapeType:
                                                          LinearShapePointerType
                                                              .circle,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      Divider(color: Colors.black),
                                    ],
                                  ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              "Payment Information",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Container(
                                padding: EdgeInsets.all(
                                    getProportionateScreenHeight(15)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Colors.black45, // red as border color
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment Method",
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(18),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      widget.order.cod
                                          ? "Online Payment"
                                          : "Cash On Delivery",
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          color: Colors.black),
                                    ),
                                    Divider(color: Colors.black),
                                    Text(
                                      "Billing Address",
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(18),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(5),
                                    ),
                                    Text(
                                        "${widget.order.selectedAddress["adline1"]}",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(15),
                                            color: Colors.black)),
                                    Text(
                                        "${widget.order.selectedAddress["adline2"]}",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(15),
                                            color: Colors.black)),
                                    Text(
                                        "${widget.order.selectedAddress["city"]}-${widget.order.selectedAddress["pincode"].toString()}",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(15),
                                            color: Colors.black)),
                                    Text("Phone number: $userphone",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(15),
                                            color: Colors.black)),
                                  ],
                                )),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Divider(color: Colors.black),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              "Order Summary",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Container(
                                padding: EdgeInsets.all(
                                    getProportionateScreenHeight(15)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Colors.black45, // red as border color
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Item Cost:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      15)),
                                        ),
                                        Text(
                                            "₹${widget.order.product.variant.price}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        15))),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Postage & Packing:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      15)),
                                        ),
                                        Text("₹0.00",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        15))),
                                      ],
                                    ),
                                    widget.order.usedOrevWallet
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Wallet Amount Used:",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            15)),
                                              ),
                                              Text(
                                                  " - ₹${widget.order.orevWalletAmountUsed}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              15))),
                                            ],
                                          )
                                        : Center(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      20),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("₹${widget.order.totalCost}",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        20),
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            Divider(color: Colors.black),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              "Transaction Summary",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  getProportionateScreenHeight(15)),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors.black45, // red as border color
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: [
                                  DetailRow(
                                      "Items",
                                      "\₹${itemsCost}",
                                      15.0,
                                      FontWeight.normal,
                                      Color(0xff777777),
                                      Color(0xff777777)),
                                  DetailRow(
                                      "Delivery",
                                      "+ \₹${delivery}",
                                      15.0,
                                      FontWeight.normal,
                                      Color(0xff777777),
                                      Color(0xff777777)),
                                  DetailRow(
                                      "Wallet",
                                      "- \₹${wallet}",
                                      15.0,
                                      FontWeight.normal,
                                      Color(0xff777777),
                                      Color(0xff777777)),
                                  widget.order.cod
                                      ? DetailRow(
                                          "COD Charges",
                                          "+ \₹${codCharges}",
                                          15.0,
                                          FontWeight.normal,
                                          Color(0xff777777),
                                          Color(0xff777777))
                                      : Center(),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  DetailRow(
                                      "Order Total:",
                                      "\₹${orderTotal}",
                                      20.0,
                                      FontWeight.w800,
                                      Colors.black,
                                      kPrimaryColor),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            invoice == true
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        // final date = DateTime.now();
                                        // final dueDate =
                                        //     date.add(Duration(days: 7));
                                        // final invoice = Invoice(
                                        //   supplier: Supplier(
                                        //     name: 'Sarah Field',
                                        //     address:
                                        //         'Sarah Street 9, Beijing, China',
                                        //     paymentInfo:
                                        //         'https://paypal.me/sarahfieldzz',
                                        //   ),
                                        //   customer: Customer(
                                        //     name: 'Apple Inc.',
                                        //     address:
                                        //         'Apple Street, Cupertino, CA 95014',
                                        //   ),
                                        //   info: InvoiceInfo(
                                        //     date: date,
                                        //     dueDate: dueDate,
                                        //     description: 'My description...',
                                        //     number:
                                        //         '${DateTime.now().year}-9999',
                                        //   ),
                                        //   items: [
                                        //     InvoiceItem(
                                        //       description: 'Coffee',
                                        //       date: DateTime.now(),
                                        //       quantity: 3,
                                        //       vat: 0.19,
                                        //       unitPrice: 5.99,
                                        //     ),
                                        //     InvoiceItem(
                                        //       description: 'Water',
                                        //       date: DateTime.now(),
                                        //       quantity: 8,
                                        //       vat: 0.19,
                                        //       unitPrice: 0.99,
                                        //     ),
                                        //     InvoiceItem(
                                        //       description: 'Orange',
                                        //       date: DateTime.now(),
                                        //       quantity: 3,
                                        //       vat: 0.19,
                                        //       unitPrice: 2.99,
                                        //     ),
                                        //     InvoiceItem(
                                        //       description: 'Apple',
                                        //       date: DateTime.now(),
                                        //       quantity: 8,
                                        //       vat: 0.19,
                                        //       unitPrice: 3.99,
                                        //     ),
                                        //     InvoiceItem(
                                        //       description: 'Mango',
                                        //       date: DateTime.now(),
                                        //       quantity: 1,
                                        //       vat: 0.19,
                                        //       unitPrice: 1.59,
                                        //     ),
                                        //     InvoiceItem(
                                        //       description: 'Blue Berries',
                                        //       date: DateTime.now(),
                                        //       quantity: 5,
                                        //       vat: 0.19,
                                        //       unitPrice: 0.99,
                                        //     ),
                                        //     InvoiceItem(
                                        //       description: 'Lemon',
                                        //       date: DateTime.now(),
                                        //       quantity: 4,
                                        //       vat: 0.19,
                                        //       unitPrice: 1.29,
                                        //     ),
                                        //   ],
                                        // );
                                        //
                                        // final pdfFile =
                                        //     await PdfInvoiceApi.generate(
                                        //         invoice);

                                        launchURL();

                                        // PdfApi.openFile(invoiceLink);
                                      },
                                      child: Text(
                                        "Download Invoice",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    13)),
                                      ),
                                    ),
                                  )
                                : Center(),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            return_cancel_value == ""
                                ? Column(
                                    children: [
                                      !cancelavailable
                                          ? DefaultButton(
                                              color: kPrimaryColor2,
                                              text: "Return/Replacement",
                                              press: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReturnCancel(
                                                              formname:
                                                                  "Return Form",
                                                              orderId: widget
                                                                  .order
                                                                  .orderId)),
                                                );
                                              },
                                            )
                                          : Center(),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      cancelavailable
                                          ? DefaultButton(
                                              color: Colors.red,
                                              text: "Cancel",
                                              press: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReturnCancel(
                                                            formname:
                                                                "Cancel Form",
                                                            orderId: widget
                                                                .order.orderId,
                                                          )),
                                                );
                                              },
                                            )
                                          : Center(),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                    ],
                                  )
                                : Center(),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row DetailRow(String Left, String Right, double size, FontWeight weight,
      Color colour1, Color colour2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Left,
          style: TextStyle(
              fontSize: getProportionateScreenHeight(size),
              fontWeight: weight,
              color: colour1),
        ),
        Text(
          Right,
          style: TextStyle(
              fontSize: getProportionateScreenHeight(size),
              fontWeight: weight,
              color: colour2),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Order Details",
            style: TextStyle(color: Colors.black),
          ),
          // Text(
          //   "${demoCarts.length} items",
          //   style: Theme.of(context).textTheme.caption,
          // ),
        ],
      ),
    );
  }
}
