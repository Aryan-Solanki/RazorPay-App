import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:orev/components/custom_surfix_icon.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/components/form_error.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/address/address.dart';
import 'package:orev/screens/complete_profile/complete_profile_screen.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:orev/screens/wallet/wallet.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:search_choices/search_choices.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class UpdateProfileForm extends StatefulWidget {
  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm>
    with ChangeNotifier {
  String newname;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> addressmap = [];
  String user_key;
  String name = "";
  double orevwallet = 0.0;

  Future<void> getAllAddress() async {
    ProductServices _services = ProductServices();
    print(user_key);
    var userref = await _services.users.doc(user_key).get();
    addressmap = userref["address"];
  }

  getUserName() async {
    UserServices _services = new UserServices();
    var doc = await _services.getUserById(user_key);
    name = doc["name"];
    orevwallet = doc["walletAmt"].toDouble();
    setState(() {});
  }

  changeName(newName) async {
    UserServices _services = new UserServices();
    var values = {"id": user_key, "name": newName};
    await _services.updateUserData(values);
    setState(() {
      final snackBar = SnackBar(
        content: Text('Value Updated'),
        backgroundColor: kPrimaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
    super.initState();
    user_key = UserSimplePreferences.getAuthKey() ?? "";
    getAllAddress();
    getUserName();
    super.initState();
  }

  String pincode;
  @override
  Widget build(BuildContext context) {
    Future<void> setAddress(index) async {
      addressmap.removeAt(index);
      ProductServices _services = ProductServices();
      var finalmap = {"address": addressmap};
      await _services.updateAddress(finalmap, user_key);
      setState(() {
        final snackBar = SnackBar(
          content: Text('Address Removed'),
          backgroundColor: kPrimaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }

    _navigateAndDisplaySelection(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Address()),
      );

      if (result) {
        getAllAddress();
        setState(() {
          final snackBar = SnackBar(
            content: Text('Address Added Successfully'),
            backgroundColor: kPrimaryColor,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUpdateNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Container(
            padding: EdgeInsets.all(getProportionateScreenHeight(10)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: kTextColor)),
            child: Column(
              children: [
                GFAccordion(
                  expandedTitleBackgroundColor: Colors.white,
                  contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                  titlePadding:
                      EdgeInsets.only(left: getProportionateScreenHeight(8)),
                  titleChild: Text(
                    "My Addresses (${addressmap.length})",
                    style: TextStyle(fontSize: getProportionateScreenHeight(15)),
                  ),
                  // content: 'GetFlutter is an open source library that comes with pre-build 1000+ UI components.'
                  contentChild: Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: getProportionateScreenHeight(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: addressmap.length,
                            itemBuilder: (context, i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        addressmap[i]["name"],
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15)),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setAddress(i);
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            size:
                                                getProportionateScreenHeight(20),
                                            color: kPrimaryColor,
                                          ))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(addressmap[i]["adline1"],
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        13))),
                                        Text(addressmap[i]["adline2"],
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        13))),
                                        Text(addressmap[i]["city"],
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        13))),
                                        Text(addressmap[i]["state"],
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        13))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Divider(color: Colors.black)
                                ],
                              );
                            }),
                        GestureDetector(
                          onTap: () {
                            _navigateAndDisplaySelection(context);
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Add New Address",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(13),
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Container(
            height: getProportionateScreenHeight(80),
            padding: EdgeInsets.only(
                right: getProportionateScreenHeight(20),
                left: getProportionateScreenHeight(20)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: kTextColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Orev Balance",
                  style: TextStyle(fontSize: getProportionateScreenHeight(15)),
                ),
                Text(
                  "₹$orevwallet",
                  style: TextStyle(fontSize: getProportionateScreenHeight(15)),
                )
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, Wallet.routeName);
                },
                  child: Text("Add Balance",style: TextStyle(color: Colors.blue,fontSize: getProportionateScreenHeight(13)),)
              )
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Update",
            press: () async {
              if (newname != "") {
                changeName(newname);
              }
            },
          ),
        ],
      ),
    );
  }

  Container buildUpdateNameFormField() {
    return Container(
      height: getProportionateScreenHeight(80),
      child: TextFormField(
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        style: TextStyle(
          fontSize: getProportionateScreenHeight(16),
        ),
        onChanged: (value) {
          newname = value;
        },
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontSize: getProportionateScreenHeight(15),
          ),
          hintStyle: TextStyle(
            fontSize: getProportionateScreenHeight(16),
          ),
          labelText: "Full Name",
          hintText: "$name",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      // onSaved: (newValue) => Name = newValue,
      onChanged: (value) {},
      validator: (value) {},
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter Your Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
