import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/components/product_card.dart';
import 'package:orev/components/rounded_icon_btn.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/models/OrderProduct.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/Order_Details/order_details.dart';
import 'package:orev/screens/address/address.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/payment_success/payment_success.dart';
import 'package:orev/screens/sign_in/sign_in_screen.dart';
import 'package:orev/services/order_services.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:orev/size_config.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

import 'package:twilio_flutter/twilio_flutter.dart';

class DetailsScreenDesktop extends StatefulWidget {
  final Product product;
  final int varientNumberCart;
  const DetailsScreenDesktop(
      {Key key, @required this.product, this.varientNumberCart})
      : super(key: key);

  @override
  _DetailsScreenDesktopState createState() => _DetailsScreenDesktopState();
}

class _DetailsScreenDesktopState extends State<DetailsScreenDesktop> {
  List<String> foodVariantsTitles = [];
  List<Varient> foodVariants = [];
  List<Product> youMayAlsoLikeList = [];
  int selectedFoodVariants = 0;
  bool orevwallet = false;
  String soldby = "";
  bool L_loading = false;
  double codSellerCharge = 0.0;

  void getVarientList() {
    for (var title in widget.product.varients) {
      foodVariantsTitles.add(title.title);
      foodVariants.add(title);
    }
  }

  void getDefaultVarient() {
    if (widget.varientNumberCart != null) {
      selectedFoodVariants = widget.varientNumberCart;
    } else {
      int index = 0;
      for (var varient in widget.product.varients) {
        if (varient.default_product == true) {
          selectedFoodVariants = index;
          break;
        }
        index += 1;
      }
    }
  }

  Future<void> getYouMayAlsoLikeProductList() async {
    L_loading = true;
    ProductServices _services = ProductServices();
    List<dynamic> ymalp = widget.product.youmayalsolike;
    for (var pr in ymalp) {
      youMayAlsoLikeList.add(await _services.getProduct(pr));
    }
    sellingdistance =
        await _services.getSellerSellingDistance(widget.product.sellerId);
    vendorlocation = await _services.getSellerLocation(widget.product.sellerId);
    deliveryCost =
        await _services.getSellerDeliveryCharge(widget.product.sellerId);
    deliveryCharge = deliveryCost["charge"].toDouble();
    freekms = deliveryCost["freeRadius"].toDouble();
    if (authkey != "") {
      UserServices _services2 = UserServices();
      var result = await _services2.getUserById(user_key);
      walletbalance = result["walletAmt"].toDouble();
    }
    codSellerCharge = await _services.getSellerCODcost(widget.product.sellerId);
    cod_available =
        await _services.getSellerCODAvailable(widget.product.sellerId);
    setState(() {
      L_loading = false;
    });
  }

  Future<void> getWalletBalance() async {
    UserServices _services = UserServices();
    var result = await _services.getUserById(user_key);
    walletbalance = result["walletAmt"].toDouble();
    setState(() {});
  }

  String user_key;

  String authkey = '';

  TwilioFlutter twilioFlutter;

  @override
  void initState() {
    // twilioFlutter = TwilioFlutter(
    //     accountSid : 'ACd65329a40fdca6b7260504938fd8a16f', // replace *** with Account SID
    //     authToken : '547309e1bd486a67d6283dbad5cacf4d',  // replace xxx with Auth Token
    //     twilioNumber : '7982916348'  // replace .... with Twilio Number
    // );

    // var twilioFlutter = TwilioFlutter(accountSid: '', authToken: '', twilioNumber: '');

    firstTime = true;
    authkey = UserSimplePreferences.getAuthKey() ?? '';
    getVarientList();
    getDefaultVarient();
    if (authkey != "") {
      user_key = AuthProvider().user.uid;
    }
    getYouMayAlsoLikeProductList();
    super.initState();
  }

  // void sendSms() async {
  //   twilioFlutter.sendSMS(toNumber: '+919540014357', messageDetailsScreenDesktop: 'aryan twilio msg');
  // }
  bool cod_available = false;
  int quantity = 1;
  Map<String, dynamic> SelectedAddress;
  int _radioSelected = 0;
  String coupon = "";
  int coupon_value = 100;
  bool deliverable = true;
  bool firstTime = false;
  double sellingdistance = 0.0;
  double walletbalance = 0.0;
  double newwalletbalance = 0.0;
  GeoPoint vendorlocation;
  Map deliveryCost;
  double freekms = 0.0;
  double deliveryCharge = 0.0;

  @override
  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenHeight(18)),
          );
        });
  }

  getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> addressmap = [];

    updateWalletBalance(newwalletbalance, orderId, timestamp) async {
      UserServices _service = new UserServices();
      var user = await _service.getUserById(authkey);
      var transactionsList = user["walletTransactions"];
      transactionsList.add({
        "newWalletBalance": newwalletbalance,
        "oldWalletBalance": walletbalance,
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

    void _showCODDialog(totalCost, finalDeliveryCost, usedWalletMoney) {
      totalCost = totalCost + codSellerCharge;
      SelectedAddress = addressmap[_radioSelected];
      slideDialog.showSlideDialog(
          context: context,
          child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              firstTime = true;
              _radioSelected = 0;
              setState(() {});
              return true;
            },
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: getProportionateScreenHeight(80),
                                width: getProportionateScreenHeight(80),
                                child: Image.network(widget.product
                                    .varients[selectedFoodVariants].images[0]),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product.title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              getProportionateScreenHeight(15)),
                                    ),
                                    Text(
                                      "${widget.product.varients[selectedFoodVariants].title}",
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(13)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: getProportionateScreenHeight(90),
                                  child: Text(
                                    "Deliver to",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            getProportionateScreenHeight(16)),
                                  )),
                              SizedBox(
                                width: getProportionateScreenHeight(20),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      SelectedAddress["name"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenHeight(16)),
                                    ),
                                    Text(
                                      SelectedAddress["adline1"] +
                                          " " +
                                          SelectedAddress["adline2"] +
                                          " " +
                                          SelectedAddress["city"] +
                                          " " +
                                          SelectedAddress["state"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(14)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: getProportionateScreenHeight(90),
                                  child: Text(
                                    "Pay with",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            getProportionateScreenHeight(16)),
                                  )),
                              SizedBox(
                                width: getProportionateScreenHeight(20),
                              ),
                              Text(
                                "Cash on Delivery (COD)",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: getProportionateScreenHeight(16)),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: getProportionateScreenHeight(90),
                                  child: Text(
                                    "COD Charges",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            getProportionateScreenHeight(16)),
                                  )),
                              SizedBox(
                                width: getProportionateScreenHeight(20),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "\₹${codSellerCharge}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenHeight(16)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: getProportionateScreenHeight(90),
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            getProportionateScreenHeight(16)),
                                  )),
                              SizedBox(
                                width: getProportionateScreenHeight(20),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "\₹${totalCost}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenHeight(16)),
                                    ),
                                    Text(
                                      "(includes tax + Delivery + COD Charges)",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(14)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(35)),
                          SwipeButton(
                            thumb: Icon(Icons.double_arrow_outlined),
                            activeThumbColor: kPrimaryColor4,
                            borderRadius: BorderRadius.circular(8),
                            activeTrackColor: kPrimaryColor3,
                            height: getProportionateScreenHeight(70),
                            child: Text(
                              "Swipe to place your order",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenHeight(12),
                              ),
                            ),
                            onSwipe: () async {
                              String authkey =
                                  UserSimplePreferences.getAuthKey() ?? "";
                              if (authkey == "") {
                                print("Some error occured");
                              }
                              String orderId = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              String transactionId = "COD";

                              Order order = Order(
                                  qty: quantity,
                                  transactionId: transactionId,
                                  cod: true,
                                  deliveryBoy: "",
                                  deliveryCost: finalDeliveryCost,
                                  orderStatus: "Ordered",
                                  product: new OrderProduct(
                                      brandname: widget.product.brandname,
                                      id: widget.product.id,
                                      sellerId: widget.product.sellerId,
                                      title: widget.product.title,
                                      detail: widget.product.detail,
                                      variant: widget.product
                                          .varients[selectedFoodVariants],
                                      tax: widget.product.tax),
                                  orderId: orderId,
                                  totalCost: totalCost,
                                  userId: authkey,
                                  timestamp: DateTime.now().toString(),
                                  selectedAddress: SelectedAddress,
                                  responseMsg: "Cash on Delivery order",
                                  codcharges: codSellerCharge,
                                  usedOrevWallet: orevwallet,
                                  invoice: "",
                                  orevWalletAmountUsed: usedWalletMoney);

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
                                    "default":
                                        order.product.variant.default_product,
                                    "id": order.product.variant.id,
                                    "onSale": {
                                      "comparedPrice":
                                          order.product.variant.comparedPrice,
                                      "discountPercentage": order
                                          .product.variant.discountPercentage,
                                      "isOnSale":
                                          order.product.variant.isOnSale,
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
                                  "name": SelectedAddress["name"],
                                  "adline1": SelectedAddress["adline1"],
                                  "adline2": SelectedAddress["adline2"],
                                  "city": SelectedAddress["city"],
                                  "state": SelectedAddress["state"],
                                  "pincode": SelectedAddress["pincode"],
                                },
                                "codcharges": order.codcharges,
                                "usedOrevWallet": order.usedOrevWallet,
                                "orevWalletAmountUsed":
                                    order.orevWalletAmountUsed,
                                "transactionId": transactionId,
                                "invoice": order.invoice,
                              };
                              OrderServices _services = new OrderServices();

                              try {
                                await _services.addOrder(values, order.orderId);
                                Fluttertoast.showToast(
                                    msg: "Order Placed",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 2,
                                    gravity: ToastGravity.BOTTOM);
                                updateWalletBalance(
                                    newwalletbalance, orderId, order.timestamp);
                                Navigator.push(
                                    context,
                                    (MaterialPageRoute(
                                        builder: (context) => PaymentSuccess(
                                              transaction_success: true,
                                              order: order,
                                              cod: true,
                                            ))));
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 2,
                                    gravity: ToastGravity.BOTTOM);
                              }
                            },
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          Text(
                            "By placing your order, you agree to Orev's privacy notice and conditions of use.",
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(12)),
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
    }

    double totalCost = 0.0;
    double finalDeliveryCost = 0.0;

    // updateTotalCost(walletBalance) {
    //     totalCost = totalCost - walletbalance;
    // }

    Future<double> getFinalCost(SelectedAddress, boo) async {
      List<Location> locations =
          await locationFromAddress(SelectedAddress["pincode"].toString());
      var distanceInMeters = await Geolocator.distanceBetween(
        locations[0].latitude,
        locations[0].longitude,
        vendorlocation.latitude,
        vendorlocation.longitude,
      );

      if ((distanceInMeters / 1000) < sellingdistance) {
        deliverable = true;
      } else {
        deliverable = false;
      }

      if (distanceInMeters / 1000 > freekms) {
        totalCost =
            widget.product.varients[selectedFoodVariants].price * quantity +
                deliveryCharge;
        finalDeliveryCost = deliveryCharge;
      } else {
        totalCost =
            widget.product.varients[selectedFoodVariants].price * quantity;
        finalDeliveryCost = 0.0;
      }

      if (boo) {
        setState(() {});
      }
    }

    Future<void> getAllAddress() async {
      ProductServices _services = ProductServices();
      var userref = await _services.users.doc(user_key).get();
      addressmap = userref["address"];

      if (firstTime) {
        SelectedAddress = addressmap[0];

        List<Location> locations =
            await locationFromAddress(addressmap[0]["pincode"].toString());
        var distanceInMeters = await Geolocator.distanceBetween(
          locations[0].latitude,
          locations[0].longitude,
          vendorlocation.latitude,
          vendorlocation.longitude,
        );
        if ((distanceInMeters / 1000) < sellingdistance) {
          deliverable = true;
        } else {
          deliverable = false;
        }
        for (var maps in addressmap) {
          List<Location> locations =
              await locationFromAddress(maps["pincode"].toString());
          var distanceInMeters = await Geolocator.distanceBetween(
            locations[0].latitude,
            locations[0].longitude,
            vendorlocation.latitude,
            vendorlocation.longitude,
          );
          maps["distanceInMeters"] = distanceInMeters;
        }

        getFinalCost(SelectedAddress, false);

        firstTime = false;
      }
    }

    _navigateAndDisplaySelection(
        BuildContext context, bool buynowkeandar) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Address()),
      );

      if (result) {
        setState(() {
          if (buynowkeandar) {
            Navigator.pop(context);
          }
          final snackBar = SnackBar(
            content: Text('Address Added Successfully'),
            backgroundColor: kPrimaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }

    if (authkey != "") {
      getAllAddress();
    }

    getFinalCost(SelectedAddress, false);

    void _showDialog() {
      _radioSelected = 0;
      SelectedAddress = addressmap[0];
      getFinalCost(SelectedAddress, false);
      slideDialog.showSlideDialog(
        context: context,
        barrierDismissible: false,
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            firstTime = true;
            _radioSelected = 0;
            setState(() {});
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
                              "Choose your location",
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
                              "Choose a delivery address for your product.",
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
                                    height: getProportionateScreenHeight(180),
                                    child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: addressmap.length,
                                      itemBuilder: (context, i) {
                                        return GestureDetector(
                                          onTap: () async {
                                            var distanceInMeters = addressmap[i]
                                                ["distanceInMeters"];

                                            if ((distanceInMeters / 1000) <
                                                sellingdistance) {
                                              deliverable = true;
                                            } else {
                                              deliverable = false;
                                            }
                                            _radioSelected = i;
                                            SelectedAddress = addressmap[i];
                                            await getFinalCost(
                                                SelectedAddress, true);
                                            setState(() {});
                                          },
                                          child: Container(
                                              width:
                                                  getProportionateScreenHeight(
                                                      200),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3, horizontal: 13),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: _radioSelected == i
                                                      ? kPrimaryColor2
                                                      : Color(0xff565656),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      addressmap[i]["name"],
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              getProportionateScreenHeight(
                                                                  18),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            15),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          addressmap[i]
                                                              ["adline1"],
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getProportionateScreenHeight(
                                                                      14),
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  3),
                                                        ),
                                                        Text(
                                                          addressmap[i]
                                                              ["adline2"],
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getProportionateScreenHeight(
                                                                      14),
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  3),
                                                        ),
                                                        Text(
                                                          addressmap[i]
                                                                  ["city"] +
                                                              " ," +
                                                              addressmap[i]
                                                                  ["state"],
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  getProportionateScreenHeight(
                                                                      14),
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height: getProportionateScreenHeight(10)),
                                  StatefulBuilder(builder:
                                      (BuildContext context, setState) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              _navigateAndDisplaySelection(
                                                  context, true);
                                            },
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "Add New Address",
                                                style: TextStyle(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            13),
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
                                          ),
                                        ),
                                        coupon == "aryan"
                                            ? Text(
                                                "You saved \₹$coupon_value",
                                                style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          13),
                                                ),
                                              )
                                            : coupon == ""
                                                ? Text("",
                                                    style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              13),
                                                    ))
                                                : Text("Invalid Coupon",
                                                    style: TextStyle(
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              13),
                                                    )),
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
                                                          SelectedAddress =
                                                              addressmap[
                                                                  _radioSelected];

                                                          await getFinalCost(
                                                              SelectedAddress,
                                                              false);

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
                                                            color:
                                                                kPrimaryColor),
                                                      )
                                                    : Text(
                                                        totalCost >=
                                                                walletbalance
                                                            ? "Balance: ₹${newwalletbalance = 0.0}"
                                                            : "Balance: ₹${newwalletbalance = (walletbalance - (totalCost))}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                getProportionateScreenHeight(
                                                                    12),
                                                            color:
                                                                kPrimaryColor),
                                                      ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
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
                                                                  "\₹${totalCost}",
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
                                                                  totalCost >
                                                                          walletbalance
                                                                      ? "\₹${totalCost = ((totalCost) - walletbalance)}"
                                                                      : "\₹${totalCost = 0.0}",
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
                                                                  totalCost >=
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            deliverable == true
                                                ? Center()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "This product is not availabe in the selected location",
                                                      textAlign:
                                                          TextAlign.center,
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
                                                  getProportionateScreenHeight(
                                                      5),
                                            ),
                                            cod_available == true
                                                ? Center()
                                                : Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Cash On Delivery is not available for this product",
                                                      textAlign:
                                                          TextAlign.center,
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
                                                  getProportionateScreenHeight(
                                                      10),
                                            ),
                                          ],
                                        ),
                                        deliverable == true
                                            ? cod_available
                                                ? DefaultButton(
                                                    textheight: 15,
                                                    colour: Colors.white,
                                                    height: 70,
                                                    color: kPrimaryColor2,
                                                    text: orevwallet == true
                                                        ? totalCost == 0.0
                                                            ? "Place Order"
                                                            : "Cash on Delivery (COD)"
                                                        : "Cash on Delivery (COD)",
                                                    press: () {
                                                      // Navigator.pop(context);
                                                      var usedWalletMoney =
                                                          walletbalance -
                                                              newwalletbalance;
                                                      _showCODDialog(
                                                          totalCost,
                                                          finalDeliveryCost,
                                                          usedWalletMoney);
                                                    },
                                                  )
                                                : Center()
                                            : cod_available
                                                ? DefaultButton(
                                                    textheight: 15,
                                                    colour: Colors.white,
                                                    height: 70,
                                                    color: kSecondaryColor,
                                                    text:
                                                        "Cash on Delivery (COD)",
                                                    press: () {},
                                                  )
                                                : Center(),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(10),
                                        ),
                                        deliverable == true
                                            ? orevwallet == true
                                                ? totalCost == 0.0
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
                                                                builder: (context) => OrderDetails(
                                                                    key:
                                                                        UniqueKey(),
                                                                    usedorevwallet:
                                                                        orevwallet,
                                                                    codSellerCharge:
                                                                        0.0,
                                                                    orevWalletMoneyUsed:
                                                                        usedWalletMoney,
                                                                    product: widget
                                                                        .product,
                                                                    currentVarient:
                                                                        selectedFoodVariants,
                                                                    quantity:
                                                                        quantity,
                                                                    selectedaddress:
                                                                        SelectedAddress,
                                                                    totalCost:
                                                                        totalCost,
                                                                    deliveryCost:
                                                                        finalDeliveryCost,
                                                                    newwalletbalance:
                                                                        newwalletbalance,
                                                                    oldwalletbalance:
                                                                        walletbalance)),
                                                          );
                                                        },
                                                      )
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
                                                            builder: (context) => OrderDetails(
                                                                key:
                                                                    UniqueKey(),
                                                                usedorevwallet:
                                                                    orevwallet,
                                                                codSellerCharge:
                                                                    0.0,
                                                                orevWalletMoneyUsed:
                                                                    usedWalletMoney,
                                                                product: widget
                                                                    .product,
                                                                currentVarient:
                                                                    selectedFoodVariants,
                                                                quantity:
                                                                    quantity,
                                                                selectedaddress:
                                                                    SelectedAddress,
                                                                totalCost:
                                                                    totalCost,
                                                                deliveryCost:
                                                                    finalDeliveryCost,
                                                                newwalletbalance:
                                                                    newwalletbalance,
                                                                oldwalletbalance:
                                                                    walletbalance)),
                                                      );
                                                    })
                                            : DefaultButton(
                                                textheight: 15,
                                                // colour: Colors.white,
                                                height: 70,
                                                color: kSecondaryColor,
                                                text: "Pay Online",
                                                press: () {},
                                              ),
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

    List<dynamic> keys = [];

    Future<void> addToCart() async {
      ProductServices _services = ProductServices();
      var favref = await _services.cart.doc(user_key).get();
      keys = favref["cartItems"];

      var x = widget.product.varients[selectedFoodVariants].id;

      bool alreadyexixts = false;

      for (var k in keys) {
        if (k["varientNumber"] == x && k["productId"] == widget.product.id) {
          var currentqty = k["qty"];
          var newqty = currentqty + quantity;
          k["qty"] = newqty;
          alreadyexixts = true;
        }
      }
      if (!alreadyexixts) {
        keys.add({
          "productId": widget.product.id,
          "qty": quantity,
          "varientNumber": x,
        });
      }

      await _services.cart.doc(user_key).update({'cartItems': keys});
      setState(() {
        final snackBar = SnackBar(
          content: Text('Item added to Cart'),
          backgroundColor: kPrimaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      // list.add(SizedBox(width: getProportionateScreenHeight(20)));
    }

    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(10)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenHeight(10)),
            !L_loading
                ? Expanded(
                    child: DirectSelectContainer(
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: kPrimaryColor2,
                          child: ListView(
                            children: [
                              ProductImages(
                                  key: UniqueKey(),
                                  product: widget.product,
                                  currentVarient: selectedFoodVariants),
                              TopRoundedContainer(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    ProductDescription(
                                      key: UniqueKey(),
                                      product: widget.product,
                                      currentVarient: selectedFoodVariants,
                                      quantity: quantity,
                                    ),
                                    TopRoundedContainer(
                                      color: Color(0xFFF6F7F9),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Row(
                                              // mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Expanded(
                                                    child: DirectSelectList<
                                                            String>(
                                                        values:
                                                            foodVariantsTitles,
                                                        defaultItemIndex:
                                                            selectedFoodVariants,
                                                        itemBuilder: (String
                                                                value) =>
                                                            getDropDownMenuItem(
                                                                value),
                                                        focusedItemDecoration:
                                                            getDslDecoration(),
                                                        onItemSelectedListener:
                                                            (item, index,
                                                                context) {
                                                          selectedFoodVariants =
                                                              index;
                                                          setState(() {});
                                                        })),
                                                // SizedBox(width: getProportionateScreenHeight(100),),
                                                Icon(
                                                  Icons.unfold_more,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenHeight(
                                                          15),
                                                ),
                                                RoundedIconBtn(
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: Colors.black,
                                                  ),
                                                  press: () {
                                                    if (quantity != 1) {
                                                      setState(() {
                                                        quantity--;
                                                        getFinalCost(
                                                            SelectedAddress,
                                                            false);
                                                      });
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                    width:
                                                        getProportionateScreenHeight(
                                                            20)),
                                                Text(
                                                  "x " + quantity.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              20)),
                                                ),
                                                SizedBox(
                                                    width:
                                                        getProportionateScreenHeight(
                                                            20)),
                                                RoundedIconBtn(
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                  ),
                                                  showShadow: true,
                                                  press: () {
                                                    if (quantity <
                                                        widget
                                                            .product
                                                            .varients[
                                                                selectedFoodVariants]
                                                            .qty) {
                                                      setState(() {
                                                        quantity++;
                                                        getFinalCost(
                                                            SelectedAddress,
                                                            false);
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Seller Quantity Exceeded",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          timeInSecForIosWeb: 2,
                                                          gravity: ToastGravity
                                                              .BOTTOM);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          !widget
                                                      .product
                                                      .varients[
                                                          selectedFoodVariants]
                                                      .inStock ==
                                                  false
                                              ? !L_loading
                                                  ? TopRoundedContainer(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              0.1,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              0.1,
                                                          bottom:
                                                              getProportionateScreenHeight(
                                                                  30),
                                                          top:
                                                              getProportionateScreenHeight(
                                                                  10),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            DefaultButton(
                                                              color:
                                                                  kPrimaryColor2,
                                                              text: "Buy Now",
                                                              press: () {
                                                                // Navigator.pushNamed(
                                                                //     context,
                                                                //     Invoice
                                                                //         .routeName);
                                                                // sendSms();
                                                                setState(() {});
                                                                if (authkey ==
                                                                    '') {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      SignInScreen
                                                                          .routeName);
                                                                } else {
                                                                  if (addressmap
                                                                      .isEmpty) {
                                                                    _navigateAndDisplaySelection(
                                                                        context,
                                                                        false);
                                                                  } else {
                                                                    firstTime =
                                                                        true;
                                                                    _radioSelected =
                                                                        0;
                                                                    setState(
                                                                        () {});
                                                                    _showDialog();
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  getProportionateScreenHeight(
                                                                      15),
                                                            ),
                                                            DefaultButton(
                                                              text:
                                                                  "Add To Cart",
                                                              press: () {
                                                                if (authkey ==
                                                                    '') {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      SignInScreen
                                                                          .routeName);
                                                                } else {
                                                                  addToCart();
                                                                }
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : TopRoundedContainer(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              0.1,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              0.1,
                                                          bottom:
                                                              getProportionateScreenHeight(
                                                                  30),
                                                          top:
                                                              getProportionateScreenHeight(
                                                                  10),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            DefaultButton(
                                                              color:
                                                                  kPrimaryColor2,
                                                              text: "Buy Now",
                                                              press: () {
                                                                if (authkey ==
                                                                    '') {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      SignInScreen
                                                                          .routeName);
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  getProportionateScreenHeight(
                                                                      15),
                                                            ),
                                                            DefaultButton(
                                                              text:
                                                                  "Add To Cart",
                                                              press: () {
                                                                if (authkey ==
                                                                    '') {
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      SignInScreen
                                                                          .routeName);
                                                                }
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                              : TopRoundedContainer(
                                                  color: Colors.white,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .screenWidth *
                                                            0.1,
                                                        right: SizeConfig
                                                                .screenWidth *
                                                            0.1,
                                                        bottom:
                                                            getProportionateScreenHeight(
                                                                30),
                                                        top:
                                                            getProportionateScreenHeight(
                                                                10),
                                                      ),
                                                      child: DefaultButton(
                                                        color: kSecondaryColor,
                                                        text: "Out of Stock",
                                                        press: () {},
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              authkey != ""
                                  ? Container(
                                      padding: EdgeInsets.only(bottom: 20),
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    getProportionateScreenHeight(
                                                        15),
                                                bottom:
                                                    getProportionateScreenHeight(
                                                        5)),
                                            child: Text(
                                              "You Might Also Like",
                                              style: smallerheadingStyle,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                          ScrollConfiguration(
                                            behavior: ScrollBehavior(),
                                            child: GlowingOverscrollIndicator(
                                              axisDirection:
                                                  AxisDirection.right,
                                              color: kPrimaryColor2,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    ...List.generate(
                                                      widget
                                                          .product
                                                          .youmayalsolike
                                                          .length,
                                                      (index) {
                                                        if (youMayAlsoLikeList
                                                                .length ==
                                                            0) {
                                                          return SizedBox
                                                              .shrink();
                                                        } else {
                                                          return ProductCard(
                                                              product:
                                                                  youMayAlsoLikeList[
                                                                      index]);
                                                        }
                                                        // here by default width and height is 0
                                                      },
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                20)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Center(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  )),
          ],
        );
      },
    );
  }
}
