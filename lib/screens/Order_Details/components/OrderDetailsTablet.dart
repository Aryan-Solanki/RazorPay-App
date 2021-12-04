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

class OrderDetailsTablet extends StatefulWidget {
  const OrderDetailsTablet({
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
  _OrderDetailsTabletState createState() => _OrderDetailsTabletState();
}

class _OrderDetailsTabletState extends State<OrderDetailsTablet> {
  String payment_response;

  String mid = "LsrZNj54827134067770";
  String PAYTM_MERCHANT_KEY = "eMQRe_MdiSf0cuih";
  String website = "DEFAULT";
  bool testing = false;
  bool loading = false;

  String transactionId = "";

  void generateTxnToken() async {
    setState(() {
      loading = true;
    });
    transactionId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        transactionId;

    //Host the Server Side Code on your Server and use your URL here. The following URL may or may not work. Because hosted on free server.
    //Server Side code url: https://github.com/mrdishant/Paytm-Plugin-Server
    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var OrderDetailsTablet = json.encode({
      "mid": mid,
      "key_secret": PAYTM_MERCHANT_KEY,
      "website": website,
      "orderId": transactionId,
      // "amount": (widget.product.varients[widget.currentVarient].price * widget.quantity)
      //     .toString(),
      "amount": "${widget.totalCost}",
      "callbackUrl": callBackUrl,
      "custId": "122",
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: OrderDetailsTablet,
        headers: {'Content-type': "application/json"},
      );
      print("Response is");
      print(response.body);
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          mid,
          transactionId,
          txnToken,
          // (widget.product.varients[widget.currentVarient].price *
          //         widget.quantity)
          //     .toString(),
          "${widget.totalCost}",
          callBackUrl,
          testing);

      paytmResponse.then((value) {
        print(value);
        setState(() async {
          loading = false;
          print("Value is ");
          print(value);
          if (value['error']) {
            payment_response = value['errorMessage'];
          } else {
            if (value['response'] != null) {
              payment_response = value['response']['STATUS'];
              print(
                  "Response                                           STATUS   ${value['response']['STATUS']}");
              String authkey = UserSimplePreferences.getAuthKey() ?? "";
              if (authkey == "") {
                print("Some error occured");
              }

              updateWalletBalance(newwalletbalance, orderId, timestamp) async {
                newwalletbalance = newwalletbalance.toDouble();
                UserServices _service = new UserServices();
                var user = await _service.getUserById(authkey);
                var transactionsList = user["walletTransactions"];
                transactionsList.add({
                  "newWalletBalance": newwalletbalance,
                  "oldWalletBalance": widget.oldwalletbalance,
                  "orderId": orderId,
                  "timestamp": timestamp
                });
                var values = {
                  "id": authkey,
                  "walletAmt": newwalletbalance,
                  "walletTransactions": transactionsList
                };
                _service.updateUserData(values);
              }

              String orderIdnew =
                  DateTime.now().millisecondsSinceEpoch.toString();

              Order order = Order(
                  qty: widget.quantity,
                  cod: false,
                  deliveryBoy: "",
                  deliveryCost: widget.deliveryCost,
                  orderStatus: "Ordered",
                  product: new OrderProduct(
                      brandname: widget.product.brandname,
                      id: widget.product.id,
                      sellerId: widget.product.sellerId,
                      title: widget.product.title,
                      detail: widget.product.detail,
                      variant: widget.product.varients[widget.currentVarient],
                      tax: widget.product.tax),
                  orderId: orderIdnew,
                  totalCost: widget.totalCost,
                  userId: authkey,
                  timestamp: DateTime.now().toString(),
                  selectedAddress: widget.selectedaddress,
                  responseMsg: value['response']['RESPMSG'],
                  codcharges: widget.codSellerCharge,
                  usedOrevWallet: widget.usedOrevWallet,
                  transactionId: transactionId,
                  invoice: "",
                  orevWalletAmountUsed: widget.orevWalletMoneyUsed);
              if (payment_response == "TXN_FAILURE") {
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) => PaymentSuccess(
                              transaction_success: false,
                              order: order,
                            ))));
                print("Transaction Failed");
                print(value['response']['RESPMSG']);
              } else if (payment_response == "TXN_SUCCESS") {
                print("Transaction Successful");
                print(value['response']['RESPMSG']);

                var values = {
                  "qty": order.qty,
                  "cod": order.cod,
                  "deliveryBoy": order.deliveryBoy,
                  "deliveryCost": order.deliveryCost,
                  "orderStatus": order.orderStatus,
                  "product": {
                    "brandname": order.product.brandname,
                    "id": order.product.id,
                    "sellerId": order.product.sellerId,
                    "title": order.product.title,
                    "detail": order.product.detail,
                    "variant": {
                      "title": order.product.variant.title,
                      "default": order.product.variant.default_product,
                      "id": order.product.variant.id,
                      "onSale": {
                        "comparedPrice": order.product.variant.comparedPrice,
                        "discountPercentage":
                            order.product.variant.discountPercentage,
                        "isOnSale": order.product.variant.isOnSale,
                      },
                      "price": order.product.variant.price,
                      "stock": {
                        "inStock": order.product.variant.inStock,
                        "qty": order.product.variant.qty
                      },
                      "variantDetails": {
                        "images": order.product.variant.images,
                        "title": order.product.variant.title,
                      },
                    },
                    "tax": order.product.tax,
                  },
                  "orderId": order.orderId,
                  "totalCost": order.totalCost,
                  "userId": order.userId,
                  "timestamp": order.timestamp,
                  "responseMsg": order.responseMsg,
                  "address": {
                    "name": widget.selectedaddress["name"],
                    "adline1": widget.selectedaddress["adline1"],
                    "adline2": widget.selectedaddress["adline2"],
                    "city": widget.selectedaddress["city"],
                    "state": widget.selectedaddress["state"],
                    "pincode": widget.selectedaddress["pincode"],
                  },
                  "codcharges": order.codcharges,
                  "usedOrevWallet": order.usedOrevWallet,
                  "orevWalletAmountUsed": order.orevWalletAmountUsed,
                  "transactionId": transactionId,
                  "invoice": order.invoice
                };
                OrderServices _services = new OrderServices();
                try {
                  await _services.addOrder(values, order.orderId);
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 2,
                      gravity: ToastGravity.BOTTOM);
                }

                updateWalletBalance(
                    widget.newwalletbalance, transactionId, order.timestamp);

                Fluttertoast.showToast(
                    msg: "Order Placed",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2,
                    gravity: ToastGravity.BOTTOM);
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) => PaymentSuccess(
                              transaction_success: true,
                              order: order,
                              cod: false,
                            ))));
              }
            }
          }
          payment_response += "\n" + value.toString();
        });
      });
      Future.delayed(Duration(seconds: 1), () {
        _btnController.reset();
      });
    } catch (e) {
      _btnController.reset();
      print(e);
    }
  }

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
                        onPressed: () async {
                          generateTxnToken();
                        },
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
