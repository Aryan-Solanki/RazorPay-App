import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/services/order_services.dart';
import 'package:orev/size_config.dart';

import '../../../constants.dart';

class TotalPrice extends StatefulWidget {
  const TotalPrice({
    Key key,
    @required this.product,
    @required this.currentVarient,
    @required this.quantity,
    @required this.totalCost,
    @required this.codSellerCost,
    @required this.walletAmountUsed,
    @required this.onlinePayment,
    @required this.transactionId,
    @required this.deliveryCost,
  }) : super(key: key);
  final Product product;
  final int currentVarient;
  final int quantity;
  final double totalCost;
  final double walletAmountUsed;
  final double deliveryCost;
  final bool onlinePayment;
  final double codSellerCost;
  final String transactionId;
  @override
  _TotalPriceState createState() => _TotalPriceState();
}

bool applied_coupon = false;

class _TotalPriceState extends State<TotalPrice> {
  uploadTransaction() async {
    OrderServices _services = new OrderServices();

    var values = {
      "itemsCost": widget.product.varients[widget.currentVarient].price *
          widget.quantity,
      "delivery": widget.deliveryCost,
      "wallet": widget.walletAmountUsed,
      "codCharges": !widget.onlinePayment ? widget.codSellerCost : 0.0,
      "orderTotal": widget.totalCost
    };
    _services.addTransaction(values, widget.transactionId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenHeight(15)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
          )),
      child: Column(
        children: [
          DetailRow(
              "Items",
              "\₹${widget.product.varients[widget.currentVarient].price} x ${widget.quantity}",
              15.0,
              FontWeight.normal,
              Color(0xff777777),
              Color(0xff777777)),
          DetailRow("Delivery", "+ \₹${widget.deliveryCost}", 15.0,
              FontWeight.normal, Color(0xff777777), Color(0xff777777)),
          DetailRow("Wallet", "- \₹${widget.walletAmountUsed}", 15.0,
              FontWeight.normal, Color(0xff777777), Color(0xff777777)),
          !widget.onlinePayment
              ? DetailRow("COD Charges", "+ \₹${widget.codSellerCost}", 15.0,
                  FontWeight.normal, Color(0xff777777), Color(0xff777777))
              : Center(),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          DetailRow("Order Total:", "\₹${widget.totalCost}", 20.0,
              FontWeight.w800, Colors.black, kPrimaryColor),
        ],
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
}
