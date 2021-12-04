import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/components/orevwallet_afterpage.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:paytm/paytm.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../size_config.dart';

class WalletScreenMobile extends StatefulWidget {
  @override
  _WalletScreenMobileState createState() => _WalletScreenMobileState();
}

class _WalletScreenMobileState extends State<WalletScreenMobile> {
  String payment_response;

  String mid = "LsrZNj54827134067770";
  String PAYTM_MERCHANT_KEY = "eMQRe_MdiSf0cuih";
  String website = "DEFAULT";
  bool testing = false;
  bool loading = false;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void generateTxnToken() async {
    setState(() {
      loading = true;
    });
    String transactionId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        transactionId;

    //Host the Server Side Code on your Server and use your URL here. The following URL may or may not work. Because hosted on free server.
    //Server Side code url: https://github.com/mrdishant/Paytm-Plugin-Server
    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": mid,
      "key_secret": PAYTM_MERCHANT_KEY,
      "website": website,
      "orderId": transactionId,
      "amount": amount,
      "callbackUrl": callBackUrl,
      "custId": "122",
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      print("Response is");
      print(response.body);
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          mid, transactionId, txnToken, (amount), callBackUrl, testing);

      paytmResponse.then((value) {
        print(value);
        setState(() {
          loading = false;
          print("Value is ");
          print(value);
          if (value['error']) {
            payment_response = value['errorMessage'];
          } else {
            if (value['response'] != null) {
              payment_response = value['response']['STATUS'];
              print("Response STATUS ${value['response']['STATUS']}");
              String authkey = UserSimplePreferences.getAuthKey() ?? "";
              if (authkey == "") {
                print("Some error occured");
              }
              updateWalletBalance(newwalletbalance, orderId, timestamp) async {
                UserServices _service = new UserServices();
                var user = await _service.getUserById(authkey);
                var oldwalletbalance = user["walletAmt"];
                var transactionsList = user["walletTransactions"];
                transactionsList.add({
                  "newWalletBalance": newwalletbalance,
                  "oldWalletBalance": oldwalletbalance,
                  "orderId": orderId,
                  "timestamp": timestamp
                });
                var values = {
                  "id": authkey,
                  "walletAmt": newwalletbalance + oldwalletbalance,
                  "walletTransactions": transactionsList
                };
                _service.updateUserData(values);
              }

              if (payment_response == "TXN_FAILURE") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AfterOrevWallet(
                            transaction: false,
                          )),
                );
                print("Transaction Failed");
                print(value['response']['RESPMSG']);
              } else if (payment_response == "TXN_SUCCESS") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AfterOrevWallet(
                            transaction: true,
                          )),
                );
                print("Transaction Successful");
                print(value['response']['RESPMSG']);

                updateWalletBalance(double.parse(amount), transactionId,
                    DateTime.now().toString());

                Fluttertoast.showToast(
                    msg: "Transaction Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2,
                    gravity: ToastGravity.BOTTOM);

                setState(() {
                  getCurrentBalance();
                });
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

  String amount;

  Color ruppeecolor = Colors.black45;

  double currentBalance = 0.0;

  getCurrentBalance() async {
    String authkey = UserSimplePreferences.getAuthKey() ?? "";
    UserServices _service = new UserServices();
    var user = await _service.getUserById(authkey);
    currentBalance = user["walletAmt"].toDouble();
    setState(() {});
  }

  @override
  void initState() {
    getCurrentBalance();
    super.initState();
  }

  String coupon = "";
  @override
  Widget build(BuildContext context) {
    double coupon_value = 234.0;

    void _showDialog() {
      slideDialog.showSlideDialog(
          context: context,
          child: Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: kPrimaryColor2,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(20)),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Apply Coupon Code",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenHeight(25),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                                inputDecorationTheme: InputDecorationTheme(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                            )),
                            child: TextField(
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(20),
                                  fontWeight: FontWeight.bold),
                              onChanged: (value) {
                                coupon = value;
                                print(value);
                              },
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: getProportionateScreenHeight(
                                                13)),
                                        child: Text(
                                          "Apply",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(12),
                                            color: kPrimaryColor2,
                                          ),
                                        ),
                                      )),
                                  hintText: 'Enter Coupon Code',
                                  hintStyle: TextStyle(
                                      fontSize: getProportionateScreenHeight(20),
                                      fontWeight: FontWeight.bold,
                                      color: ruppeecolor),
                                  contentPadding: EdgeInsets.only(
                                      bottom:
                                          getProportionateScreenHeight(13))),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          coupon == "aryan"
                              ? Text(
                                  "You saved \₹$coupon_value",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: getProportionateScreenHeight(15),
                                  ),
                                )
                              : coupon == ""
                                  ? Text("",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                      ))
                                  : Text("Invalid Coupon",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                      )),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ));
    }

    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        HomeHeader(),
        SizedBox(height: getProportionateScreenHeight(10)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(20)),
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: kPrimaryColor2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Orev Wallet",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(25),
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        "Available Orev Balance ₹$currentBalance",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(15)),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                      ),
                      Text(
                        "Add Money",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(18),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(30),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                            inputDecorationTheme: InputDecorationTheme(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
                        )),
                        child: TextField(
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(30),
                              fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            amount = value;
                            if (value == "") {
                              setState(() {
                                ruppeecolor = Colors.black45;
                              });
                            }
                            if (value != "" && ruppeecolor == Colors.black45) {
                              setState(() {
                                ruppeecolor = Colors.black;
                              });
                            }
                            print(value);
                          },
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    print("halua");
                                    _showDialog();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: getProportionateScreenHeight(13)),
                                    child: Text(
                                      "Apply Coupon Code",
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenHeight(12),
                                        color: kPrimaryColor2,
                                      ),
                                    ),
                                  )),
                              prefixIcon: Text(
                                '₹',
                                style: TextStyle(
                                    fontSize: getProportionateScreenHeight(40),
                                    color: ruppeecolor),
                              ),
                              // prefixStyle: TextStyle(fontSize: getProportionateScreenHeight(45)),
                              hintText: 'Amount',
                              hintStyle: TextStyle(
                                  fontSize: getProportionateScreenHeight(30),
                                  fontWeight: FontWeight.bold,
                                  color: ruppeecolor),
                              contentPadding: EdgeInsets.only(
                                  bottom: getProportionateScreenHeight(13))),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(100),
                      ),
                      RoundedLoadingButton(
                        successColor: kPrimaryColor,
                        duration: Duration(milliseconds: 1300),
                        width: getProportionateScreenHeight(500),
                        height: getProportionateScreenHeight(56),
                        color: kPrimaryColor2,
                        child: Text("  Proceed  ",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(18),
                                color: Colors.white)),
                        controller: _btnController,
                        onPressed: () async {
                          generateTxnToken();
                        },
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
