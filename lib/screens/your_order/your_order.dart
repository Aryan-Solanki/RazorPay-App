import 'package:flutter/material.dart';
import 'package:orev/models/Order.dart';
import 'package:orev/models/OrderProduct.dart';
import 'package:orev/models/Varient.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:orev/services/order_services.dart';
import 'package:orev/services/product_services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../constants.dart';
import 'components/YourOrderDesktop.dart';
import 'components/YourOrderMobile.dart';
import 'components/YourOrderTablet.dart';
import 'components/body.dart';

class YourOrder extends StatefulWidget {
  static String routeName = "/your_order";
  @override
  _YourOrderState createState() => _YourOrderState();
}

class _YourOrderState extends State<YourOrder> {
  int numberOfItems = 0;
  String user_key;
  List<Order> orders = [];

  Future<void> getOrderInfo() async {
    OrderServices _services = OrderServices();
    var querySnapshot =
        await _services.orders.where("userId", isEqualTo: user_key).get();
    querySnapshot.docs.forEach((doc) {
      orders.add(
        new Order(
            qty: doc["qty"],
            cod: doc["cod"],
            deliveryBoy: doc["deliveryBoy"],
            deliveryCost: doc["deliveryCost"],
            orderStatus: doc["orderStatus"],
            product: new OrderProduct(
                brandname: doc["product"]["brandname"],
                id: doc["product"]["id"],
                sellerId: doc["product"]["sellerId"],
                title: doc["product"]["title"],
                detail: doc["product"]["detail"],
                variant: new Varient(
                    default_product: doc["product"]["variant"]["default"],
                    isOnSale: doc["product"]["variant"]["onSale"]["isOnSale"],
                    comparedPrice: doc["product"]["variant"]["onSale"]
                        ["comparedPrice"],
                    discountPercentage: doc["product"]["variant"]["onSale"]
                        ["discountPercentage"],
                    price: doc["product"]["variant"]["price"],
                    inStock: doc["product"]["variant"]["stock"]["inStock"],
                    qty: doc["product"]["variant"]["stock"]["qty"],
                    title: doc["product"]["variant"]["title"],
                    images: doc["product"]["variant"]["variantDetails"]
                        ["images"],
                    id: doc["product"]["variant"]["id"]),
                tax: doc["product"]["tax"]),
            orderId: doc["orderId"],
            totalCost: doc["totalCost"],
            userId: doc["userId"],
            timestamp: doc["timestamp"],
            selectedAddress: doc["address"],
            responseMsg: doc["responseMsg"],
            codcharges: doc["codcharges"].toDouble(),
            usedOrevWallet: doc["usedOrevWallet"],
            orevWalletAmountUsed: doc["orevWalletAmountUsed"].toDouble(),
            transactionId: doc["transactionId"],
            invoice: doc["invoice"]),
      );
    });
    setState(() {});
  }

  @override
  void initState() {
    user_key = AuthProvider().user.uid;
    getOrderInfo();
    super.initState();
  }

  refresh() async {
    // ProductServices _services = ProductServices();
    // var favref = await _services.cart.doc(user_key).get();
    // keys = favref["cartItems"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          body: ScreenTypeLayout(
            mobile: YourOrderMobile(
              keys: orders,
              key: UniqueKey(),
              notifyParent: refresh,
            ),
            tablet: YourOrderTablet(
              keys: orders,
              key: UniqueKey(),
              notifyParent: refresh,
            ),
            desktop: YourOrderDesktop(
              keys: orders,
              key: UniqueKey(),
              notifyParent: refresh,
            ),
          ),
        ),
      ),
    );
  }
}
