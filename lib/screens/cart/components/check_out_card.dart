import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/models/Cart.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/order_details_multiple/order_details_multiple.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class CheckoutCard extends StatefulWidget {
  final List<dynamic> keys;
  final Map currentAddress;
  final Function func;
  const CheckoutCard({
    Key key,
    this.keys,
    @required this.currentAddress,
    @required this.func,
  }) : super(key: key);
  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  String coupon = "";
  List<Cart> CartList = [];
  List<Cart> SecondCartList = [];
  double totalamt = 0.0;
  double totaldeliveryamt = 0.0;
  bool checkoutavailable = false;
  bool cod_available = true;
  Map codSellerCost = new Map();

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

  String user_key;

  Future<void> removeFromCart(varientid, productId) async {
    ProductServices _services = ProductServices();
    var favref = await _services.cart.doc(user_key).get();
    var keys = favref["cartItems"];
    bool found = false;
    var ind = 0;
    for (var cartItem in keys) {
      if (cartItem["varientNumber"] == varientid &&
          cartItem["productId"] == productId) {
        found = true;
        break;
      }
      ind += 1;
    }
    keys.removeAt(ind);
    await _services.cart.doc(user_key).update({'cartItems': keys});
  }

  reUpdateCartCost() {
    totalamt = 0.0;
    finalDeliveryCost = 0.0;
    var sellerIdList = [];
    ProductServices _services = new ProductServices();
    for (var cart in SecondCartList) {
      totalamt += cart.variantPrice * cart.numOfItem;
      if (!sellerIdList.contains(cart.product.sellerId)) {
        sellerIdList.add(cart.product.sellerId);
        if (cart.deliverable) {
          if (cart.distanceInMeters / 1000 > cart.freekms) {
            finalDeliveryCost += cart.deliveryCharges;
          }
          // codSellerCost +=
          //     await _services.getSellerCODcost(cart.product.sellerId);
        }
      }
    }
    totalamt = totalamt + finalDeliveryCost;
  }

  Future<void> getAllCartProducts(currentAddress) async {
    // setState(() {
    //   checkoutavailable = false;
    // });
    checkoutavailable = false;
    for (var k in widget.keys) {
      ProductServices _services = new ProductServices();
      UserServices _user_services = new UserServices();
      Product product = await _services.getProduct(k["productId"]);
      if (product == null) {
        removeFromCart(k["varientNumber"], k["productId"]);
      } else {
        var checklist =
            await getVarientNumber(k["varientNumber"], k["productId"]);
        var xx = checklist[0];
        var y = checklist[1];
        if (!y) {
          removeFromCart(k["varientNumber"], k["productId"]);
          continue;
        }

        Map returnMap = await _user_services.isAvailableOnUserLocation(
            currentAddress, product.sellerId);

        if (returnMap["deliverable"]) {
          Cart c = new Cart(
            product: product,
            varientNumber: product.varients[xx].id,
            numOfItem: k["qty"],
            actualVarientNumber: xx,
            deliverable: true,
            deliveryCharges: returnMap["deliveryCost"],
            codAvailable: returnMap["codAvailable"],
            codCharges: returnMap["codCharges"].toDouble(),
            distanceInMeters: returnMap["distanceInMeters"].toDouble(),
            freekms: returnMap["freekms"].toDouble(),
            variantPrice: product.varients[xx].price.toDouble(),
          );
          CartList.add(c);
          SecondCartList.add(c);
          totalamt += product.varients[xx].price * k["qty"];
        } else {
          Cart c = new Cart(
            product: product,
            varientNumber: product.varients[xx].id,
            actualVarientNumber: xx,
            numOfItem: k["qty"],
            deliverable: false,
            deliveryCharges: returnMap["deliveryCost"],
            codAvailable: returnMap["codAvailable"],
            codCharges: returnMap["codCharges"].toDouble(),
            distanceInMeters: returnMap["distanceInMeters"].toDouble(),
            freekms: returnMap["freekms"].toDouble(),
            variantPrice: product.varients[xx].price.toDouble(),
          );
          CartList.add(c);
        }
      }
    }
    ProductServices _services = new ProductServices();
    var sellerIdList = [];
    for (var cart in SecondCartList) {
      if (!cart.codAvailable) {
        cod_available = false;
      }
      if (!sellerIdList.contains(cart.product.sellerId)) {
        sellerIdList.add(cart.product.sellerId);
        if (cart.deliverable) {
          if (cart.distanceInMeters / 1000 > cart.freekms) {
            finalDeliveryCost += cart.deliveryCharges;
          }
          codSellerCost.addAll({
            cart.product.sellerId:
                await _services.getSellerCODcost(cart.product.sellerId)
          });
        }
      }
    }
    setState(() {
      if (totalamt == 0.0) {
        checkoutavailable = false;
      } else {
        checkoutavailable = true;
      }
      totalamt = totalamt + finalDeliveryCost;
      if (counter >= 0) {
        widget.func();
      }
      counter += 1;
    });
  }

  Future<void> getWalletBalance() async {
    UserServices _services = UserServices();
    var result = await _services.getUserById(user_key);
    walletbalance = result["walletAmt"].toDouble();
    setState(() {});
  }

  int counter;

  @override
  void initState() {
    user_key = AuthProvider().user.uid;
    getAllCartProducts(widget.currentAddress);
    getWalletBalance();
    counter = 0;
    super.initState();
  }

  bool orevwallet = false;
  double walletbalance = 0.0;
  double newwalletbalance = 0.0;
  double finalDeliveryCost = 0.0;

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: context,
      barrierDismissible: false,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Expanded(
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Shipping location",
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(23),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This will be your shipping location",
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(12),
                              color: Color(0xff565656),
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 13),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            widget.currentAddress["name"],
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        18),
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(15),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget
                                                    .currentAddress["adline1"],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        3),
                                              ),
                                              Text(
                                                widget
                                                    .currentAddress["adline2"],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        3),
                                              ),
                                              Text(
                                                widget.currentAddress["city"] +
                                                    ", " +
                                                    widget.currentAddress[
                                                        "state"] +
                                                    " (" +
                                                    widget.currentAddress[
                                                            "pincode"]
                                                        .toString() +
                                                    ")",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        3),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Use Orev Wallet",
                                                    style: TextStyle(
                                                        fontSize:
                                                            getProportionateScreenHeight(
                                                                13)),
                                                  ),
                                                  Transform.scale(
                                                    scale:
                                                        getProportionateScreenHeight(
                                                            1),
                                                    child: Checkbox(
                                                      activeColor:
                                                          kPrimaryColor,
                                                      value: orevwallet,
                                                      onChanged: (bool
                                                          newValue) async {
                                                        orevwallet = newValue;
                                                        if (!orevwallet) {
                                                          reUpdateCartCost();
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              orevwallet == false
                                                  ? Text(
                                                      "Balance: ₹$walletbalance",
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  12),
                                                          color: kPrimaryColor),
                                                    )
                                                  : Text(
                                                      totalamt >= walletbalance
                                                          ? "Balance: ₹${newwalletbalance = 0.0}"
                                                          : "Balance: ₹${newwalletbalance = (walletbalance - (totalamt))}",
                                                      style: TextStyle(
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  12),
                                                          color: kPrimaryColor),
                                                    ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  30),
                                                        ),
                                                        Container(
                                                            child: Text(
                                                          "Total",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize:
                                                                  getProportionateScreenHeight(
                                                                      23)),
                                                        )),
                                                        SizedBox(
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  20),
                                                        ),
                                                        orevwallet == false
                                                            ? Text(
                                                                "\₹${totalamt}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            20)),
                                                              )
                                                            : Text(
                                                                totalamt >
                                                                        walletbalance
                                                                    ? "\₹${totalamt = ((totalamt) - walletbalance)}"
                                                                    : "\₹${totalamt = 0.0}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            20)),
                                                              ),
                                                      ],
                                                    ),
                                                    orevwallet == false
                                                        ? Column(
                                                            children: [
                                                              Text(
                                                                "       (includes tax + Delivery: \₹$finalDeliveryCost)",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            13)),
                                                              )
                                                            ],
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                "       (includes tax + Delivery: \₹$finalDeliveryCost)",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            13)),
                                                              ),
                                                              Text(
                                                                totalamt >=
                                                                        newwalletbalance
                                                                    ? "( - Orev Wallet: ${walletbalance - newwalletbalance})"
                                                                    : "( - Orev Wallet: ${walletbalance - newwalletbalance})",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            13)),
                                                              )
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      cod_available
                                          ? Center()
                                          : Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Cash On Delivery is not available for this product",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          13),
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      cod_available
                                          ? orevwallet
                                              ? totalamt == 0.0
                                                  ? DefaultButton(
                                                      textheight: 15,
                                                      colour: Colors.white,
                                                      height: 70,
                                                      color: kPrimaryColor2,
                                                      text: "Place Order",
                                                      press: () {
                                                        // Navigator.pop(context);
                                                        var usedWalletMoney =
                                                            walletbalance -
                                                                newwalletbalance;

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => OrderDetailsMultiple(
                                                                  usedOrevWallet:
                                                                      orevwallet,
                                                                  key:
                                                                      UniqueKey(),
                                                                  CartList:
                                                                      CartList,
                                                                  orevWalletMoneyUsed:
                                                                      usedWalletMoney,
                                                                  selectedaddress:
                                                                      widget
                                                                          .currentAddress,
                                                                  totalCost:
                                                                      totalamt,
                                                                  deliveryCost:
                                                                      finalDeliveryCost,
                                                                  newwalletbalance:
                                                                      newwalletbalance,
                                                                  onlinePayment:
                                                                      true,
                                                                  codSellerCost:
                                                                      codSellerCost,
                                                                  oldwalletbalance:
                                                                      walletbalance)),
                                                        );

                                                        // _showCODDialog(
                                                        //     totalCost,
                                                        //     finalDeliveryCost,
                                                        //     usedWalletMoney);
                                                      },
                                                    )
                                                  : DefaultButton(
                                                      textheight: 15,
                                                      colour: Colors.white,
                                                      height: 70,
                                                      color: kPrimaryColor2,
                                                      text:
                                                          "Cash on Delivery (COD)",
                                                      press: () {
                                                        // Navigator.pop(context);
                                                        var usedWalletMoney =
                                                            walletbalance -
                                                                newwalletbalance;

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => OrderDetailsMultiple(
                                                                  usedOrevWallet:
                                                                      orevwallet,
                                                                  key:
                                                                      UniqueKey(),
                                                                  CartList:
                                                                      CartList,
                                                                  orevWalletMoneyUsed:
                                                                      usedWalletMoney,
                                                                  selectedaddress:
                                                                      widget
                                                                          .currentAddress,
                                                                  totalCost:
                                                                      totalamt,
                                                                  deliveryCost:
                                                                      finalDeliveryCost,
                                                                  newwalletbalance:
                                                                      newwalletbalance,
                                                                  onlinePayment:
                                                                      false,
                                                                  codSellerCost:
                                                                      codSellerCost,
                                                                  oldwalletbalance:
                                                                      walletbalance)),
                                                        );

                                                        // _showCODDialog(
                                                        //     totalCost,
                                                        //     finalDeliveryCost,
                                                        //     usedWalletMoney);
                                                      },
                                                    )
                                              : DefaultButton(
                                                  textheight: 15,
                                                  colour: Colors.white,
                                                  height: 70,
                                                  color: kPrimaryColor2,
                                                  text:
                                                      "Cash on Delivery (COD)",
                                                  press: () {
                                                    // Navigator.pop(context);
                                                    var usedWalletMoney = 0.0;

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => OrderDetailsMultiple(
                                                              usedOrevWallet:
                                                                  orevwallet,
                                                              key: UniqueKey(),
                                                              CartList:
                                                                  CartList,
                                                              orevWalletMoneyUsed:
                                                                  usedWalletMoney,
                                                              selectedaddress:
                                                                  widget
                                                                      .currentAddress,
                                                              totalCost:
                                                                  totalamt,
                                                              deliveryCost:
                                                                  finalDeliveryCost,
                                                              newwalletbalance:
                                                                  newwalletbalance,
                                                              onlinePayment:
                                                                  false,
                                                              codSellerCost:
                                                                  codSellerCost,
                                                              oldwalletbalance:
                                                                  walletbalance)),
                                                    );

                                                    // _showCODDialog(
                                                    //     totalCost,
                                                    //     finalDeliveryCost,
                                                    //     usedWalletMoney);
                                                  },
                                                )
                                          : orevwallet == true
                                              ? totalamt == 0.0
                                                  ? DefaultButton(
                                                      textheight: 15,
                                                      colour: Colors.white,
                                                      height: 70,
                                                      color: kPrimaryColor2,
                                                      text: "Place Order",
                                                      press: () {
                                                        // Navigator.pop(context);
                                                        var usedWalletMoney =
                                                            walletbalance -
                                                                newwalletbalance;

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => OrderDetailsMultiple(
                                                                  usedOrevWallet:
                                                                      orevwallet,
                                                                  key:
                                                                      UniqueKey(),
                                                                  CartList:
                                                                      CartList,
                                                                  orevWalletMoneyUsed:
                                                                      usedWalletMoney,
                                                                  selectedaddress:
                                                                      widget
                                                                          .currentAddress,
                                                                  totalCost:
                                                                      totalamt,
                                                                  deliveryCost:
                                                                      finalDeliveryCost,
                                                                  newwalletbalance:
                                                                      newwalletbalance,
                                                                  onlinePayment:
                                                                      true,
                                                                  codSellerCost:
                                                                      codSellerCost,
                                                                  oldwalletbalance:
                                                                      walletbalance)),
                                                        );

                                                        // _showCODDialog(
                                                        //     totalCost,
                                                        //     finalDeliveryCost,
                                                        //     usedWalletMoney);
                                                      },
                                                    )
                                                  : Center()
                                              : Center(),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      orevwallet == true
                                          ? totalamt == 0.0
                                              ? Center()
                                              : DefaultButton(
                                                  textheight: 15,
                                                  colour: Colors.white,
                                                  height: 70,
                                                  color: kPrimaryColor,
                                                  text: "Pay Online",
                                                  press: () {
                                                    var usedWalletMoney =
                                                        walletbalance -
                                                            newwalletbalance;

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => OrderDetailsMultiple(
                                                              usedOrevWallet:
                                                                  orevwallet,
                                                              key: UniqueKey(),
                                                              CartList:
                                                                  CartList,
                                                              orevWalletMoneyUsed:
                                                                  usedWalletMoney,
                                                              selectedaddress:
                                                                  widget
                                                                      .currentAddress,
                                                              totalCost:
                                                                  totalamt,
                                                              deliveryCost:
                                                                  finalDeliveryCost,
                                                              newwalletbalance:
                                                                  newwalletbalance,
                                                              onlinePayment:
                                                                  true,
                                                              codSellerCost:
                                                                  codSellerCost,
                                                              oldwalletbalance:
                                                                  walletbalance)),
                                                    );

                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) => OrderDetails(
                                                    //           key:
                                                    //           UniqueKey(),
                                                    //           product: widget
                                                    //               .product,
                                                    //           currentVarient:
                                                    //           selectedFoodVariants,
                                                    //           quantity:
                                                    //           quantity,
                                                    //           selectedaddress:
                                                    //           SelectedAddress,
                                                    //           totalCost:
                                                    //           totalCost,
                                                    //           deliveryCost:
                                                    //           finalDeliveryCost,
                                                    //           newwalletbalance:
                                                    //           newwalletbalance,
                                                    //           oldwalletbalance:
                                                    //           walletbalance)),
                                                    // );
                                                  },
                                                )
                                          : DefaultButton(
                                              textheight: 15,
                                              colour: Colors.white,
                                              height: 70,
                                              color: kPrimaryColor,
                                              text: "Pay Online",
                                              press: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetailsMultiple(
                                                              usedOrevWallet:
                                                                  orevwallet,
                                                              key: UniqueKey(),
                                                              CartList:
                                                                  CartList,
                                                              orevWalletMoneyUsed:
                                                                  0.0,
                                                              selectedaddress:
                                                                  widget
                                                                      .currentAddress,
                                                              totalCost:
                                                                  totalamt,
                                                              deliveryCost:
                                                                  finalDeliveryCost,
                                                              newwalletbalance:
                                                                  newwalletbalance,
                                                              onlinePayment:
                                                                  true,
                                                              codSellerCost:
                                                                  codSellerCost,
                                                              oldwalletbalance:
                                                                  walletbalance)),
                                                );
                                              })
                                    ],
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {});
    }

    // getAllCartProducts();
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: kPrimaryColor2,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(15),
              horizontal: getProportionateScreenHeight(30),
            ),
            // height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(15)),
                          children: [
                            TextSpan(
                              text: "\₹$totalamt",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(18),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenHeight(190),
                        child: checkoutavailable
                            ? DefaultButton(
                                text: "Checkout",
                                press: () {
                                  _showDialog();
                                },
                              )
                            : DefaultButton(
                                text: "Checkout",
                                color: kSecondaryColor,
                                press: () {},
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
