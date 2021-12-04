// CartScreenMobile

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:menu_button/menu_button.dart';
import 'package:orev/constants.dart';
import 'package:orev/models/Cart.dart';
import 'package:orev/models/Product.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/address/address.dart';
import 'package:orev/screens/home/components/icon_btn_with_counter.dart';
import 'package:orev/screens/sign_in/sign_in_screen.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';

import '../../../size_config.dart';
import '../cart_screen.dart';
import 'cart_card.dart';
import 'check_out_card.dart';

class CartScreenMobile extends StatefulWidget {
  final List<dynamic> keys;
  final Map currentAddress;
  final Function(Map) notifyParent;
  const CartScreenMobile({
    Key key,
    this.keys,
    @required this.notifyParent,
    @required this.currentAddress,
  }) : super(key: key);
  @override
  CartScreenMobileState createState() =>
      CartScreenMobileState(keys: keys, currentAddress: currentAddress);
}

class CartScreenMobileState extends State<CartScreenMobile> {
  Map currentAddress;
  List<dynamic> keys;
  CartScreenMobileState({@required this.keys, this.currentAddress});

  List<Cart> CartList = [];
  double totalamt = 0.0;
  bool codSelected = false;

  Future<void> removeFromCart(varientid, productId) async {
    ProductServices _services = ProductServices();
    var favref = await _services.cart.doc(user_key).get();
    keys = favref["cartItems"];
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
    widget.notifyParent(currentAddress);
  }

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

  codSelectedState() {
    setState(() {
      codSelected = true;
    });
  }

  Future<void> getAllCartProducts(currentAddress) async {
    loading = true;
    try {
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
            CartList.add(
              new Cart(
                product: product,
                varientNumber: product.varients[xx].id,
                actualVarientNumber: xx,
                numOfItem: k["qty"],
                deliverable: true,
                deliveryCharges: returnMap["deliveryCost"],
                codAvailable: returnMap["codAvailable"],
                codCharges: returnMap["codCharges"],
              ),
            );
            totalamt += product.varients[xx].price * k["qty"];
          } else {
            CartList.add(
              new Cart(
                product: product,
                varientNumber: product.varients[xx].id,
                actualVarientNumber: xx,
                numOfItem: k["qty"],
                deliverable: false,
                deliveryCharges: returnMap["deliveryCost"],
                codAvailable: returnMap["codAvailable"],
                codCharges: returnMap["codCharges"],
              ),
            );
          }
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  bool loading;
  int i;

  @override
  void initState() {
    loading = true;
    i = 0;
    user_key = AuthProvider().user.uid;
    getAllCartProducts(widget.currentAddress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        widget.notifyParent(currentAddress);
      });
    }

    stopLoading() {
      // setState(() {
      //   loading = false;
      // });
    }

    changeAddress(CurrentAddress) {
      setState(() {
        CartList = [];
        currentAddress = CurrentAddress;
        getAllCartProducts(CurrentAddress);
      });
    }

    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        AddressHeader(
          loading: loading,
          address: true,
          notifyParent: changeAddress,
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        CartList.length != 0
            ? !loading
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(20)),
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: kPrimaryColor2,
                          child: ListView.builder(
                            itemCount: CartList.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                key: Key(CartList[index].product.id.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  removeFromCart(CartList[index].varientNumber,
                                      CartList[index].product.id);
                                  CartList.removeAt(index);
                                  widget.notifyParent(currentAddress);
                                },
                                background: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      SvgPicture.asset(
                                          "assets/icons/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: CartList[index].deliverable
                                    ? CartCard(
                                        cart: CartList[index],
                                        notifyParent: refresh,
                                        key: UniqueKey(),
                                        errorvalue: "", //not_deliverable
                                      )
                                    : CartCard(
                                        cart: CartList[index],
                                        notifyParent: refresh,
                                        key: UniqueKey(),
                                        errorvalue:
                                            "not_deliverable", //not_deliverable
                                      ),
                              ),
                            ),
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
                    ),
                  )
            : Expanded(
                child: Center(
                  child: Text(
                    "No items added in cart",
                    style: TextStyle(fontSize: getProportionateScreenHeight(15)),
                  ),
                ),
              ),
        CheckoutCard(
          func: stopLoading,
          keys: keys,
          key: UniqueKey(),
          currentAddress: currentAddress,
        )
      ],
    );
  }
}

class AddressHeader extends StatefulWidget {
  final bool simplebutton;
  final bool address;
  final bool loading;
  final Function func;
  final Function(Map) notifyParent;
  const AddressHeader({
    bool this.simplebutton = true,
    bool this.address = false,
    @required this.func,
    @required this.notifyParent,
    @required this.loading,
    Key key,
  }) : super(key: key);

  @override
  _AddressHeaderState createState() => _AddressHeaderState();
}

class _AddressHeaderState extends State<AddressHeader> {
  final GlobalKey<CartScreenMobileState> myCartScreenState =
      GlobalKey<CartScreenMobileState>();

  int numberOfItems = 0;
  int numberOfIAddress = 0;
  String user_key;
  List<dynamic> keys = [];
  List<dynamic> addressmap = [];
  String authkey = '';
  List<String> addresses = [];
  var addressMapFinal = Map();
  var CurrentAddress;

  Future<void> getCartNumber() async {
    ProductServices _services = ProductServices();
    var favref = await _services.cart.doc(user_key).get();
    keys = favref["cartItems"];
    numberOfItems = keys.length;
    setState(() {});
  }

  Future<void> getuseraddress() async {
    UserServices _services = UserServices();
    var user = await _services.getUserById(authkey);
    addressmap = user["address"];
    numberOfIAddress = addressmap.length;
    for (var address in addressmap) {
      var stringaddress =
          '${address["adline1"]}, ${address["adline2"]}, ${address["city"]}-${address["pincode"].toString()} ';
      addresses.add(stringaddress);
      addressMapFinal[stringaddress] = address;
    }
    selectedKey = addresses[0];
    CurrentAddress = addressmap[0];
    addresses.add("Add new Address");
    setState(() {});
  }

  @override
  void initState() {
    authkey = UserSimplePreferences.getAuthKey() ?? '';
    if (authkey != "") {
      user_key = AuthProvider().user.uid;
      getCartNumber();
      getuseraddress();
    }
    super.initState();
  }

  String selectedKey = '';

  @override
  Widget build(BuildContext context) {
    final Widget normalChildButton = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      width: SizeConfig.screenWidth * 0.6,
      height: getProportionateScreenHeight(65),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
            left: getProportionateScreenHeight(10),
            right: getProportionateScreenHeight(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Text(
              selectedKey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(14),
              ),
            )),
            FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                Icons.arrow_drop_down,
                // color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );

    if (authkey != "") {
      getCartNumber();
    }
    function(value, boo) {
      widget.func(value, boo);
    }

    bool rukbc = false;

    _navigateAndDisplaySelection(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Address()),
      );

      if (result) {
        addresses = [];
        getuseraddress();
        setState(() {
          final snackBar = SnackBar(
            content: Text('Address Added Successfully'),
            backgroundColor: kPrimaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: SizeConfig.screenWidth * 0.75,
              height: getProportionateScreenHeight(65),
              child: MenuButton<String>(
                menuButtonBackgroundColor: Colors.transparent,
                decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(
                        0.1), //border: Border.all(color: Colors.grey[300]!),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    )),
                child: normalChildButton,
                items: addresses,
                itemBuilder: (String value) => !rukbc
                    ? Container(
                        color: kSecondaryColor.withOpacity(0.1),
                        height: getProportionateScreenHeight(65),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenHeight(10)),
                        child: Text(value,
                            style: TextStyle(
                                fontSize: getProportionateScreenHeight(13)),
                            overflow: TextOverflow.ellipsis),
                      )
                    : Center(),
                toggledChild: Container(
                  child: normalChildButton,
                ),
                onItemSelected: (String value) {
                  setState(() {
                    if (!widget.loading) {
                      if (value == addresses[addresses.length - 1]) {
                        _navigateAndDisplaySelection(context);
                      } else {
                        selectedKey = value;
                        CurrentAddress = addressMapFinal[selectedKey];
                        widget.notifyParent(CurrentAddress);
                      }
                    }
                  });
                },
                onMenuButtonToggle: (bool isToggle) {},
              ),
            );
          }),
          numberOfItems == 0
              ? IconBtnWithCounter(
                  svgSrc: "assets/icons/Cart Icon.svg",
                  press: () {},
                )
              : IconBtnWithCounter(
                  svgSrc: "assets/icons/Cart Icon.svg",
                  numOfitem: numberOfItems,
                  press: () {},
                ),
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/Bell.svg",
          //   numOfitem: 3,
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}
