import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:orev/components/default_button.dart';
import 'package:orev/components/form_error.dart';
import 'package:orev/components/querysuccess.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:search_choices/search_choices.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:menu_button/menu_button.dart';

class HelpForm extends StatefulWidget {
  @override
  _HelpFormState createState() => _HelpFormState();
}

class _HelpFormState extends State<HelpForm> with ChangeNotifier {
  String selectedKey = "Please Select";

  List<String> keys = <String>[
    'Orders ,Returns & Refunds',
    'Payments ,Pricing & Orev Wallet',
    'Shipping & Delivery',
  ];

  final _formKey = GlobalKey<FormState>();
  @override
  String message = "";
  Widget build(BuildContext context) {
    final Widget normalChildButton = Container(
      height: getProportionateScreenHeight(90),
      child: Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenHeight(40),
            right: getProportionateScreenHeight(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Text(selectedKey,
                    style: TextStyle(fontSize: getProportionateScreenHeight(13)),
                    overflow: TextOverflow.ellipsis)),
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
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: kPrimaryColor2,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MenuButton<String>(
                  // itemBackgroundColor: Colors.transparent,
                  menuButtonBackgroundColor: Colors.transparent,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: kTextColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(28))),
                  child: normalChildButton,
                  items: keys,
                  itemBuilder: (String value) => Container(
                    height: getProportionateScreenHeight(90),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(20),
                        horizontal: getProportionateScreenHeight(40)),
                    child: Text(value,
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(13)),
                        overflow: TextOverflow.ellipsis),
                  ),
                  toggledChild: Container(
                    child: normalChildButton,
                  ),
                  onItemSelected: (String value) {
                    setState(() {
                      selectedKey = value;
                    });
                  },
                  onMenuButtonToggle: (bool isToggle) {
                    print(isToggle);
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                MessageFormField(),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                  text: "Continue",
                  press: () {
                    if (selectedKey != "Please Select" && message != "") {
                      String authkey = UserSimplePreferences.getAuthKey() ?? "";
                      var values = {
                        "description": message,
                        "topic": selectedKey,
                        "id": authkey
                      };
                      UserServices _services = new UserServices();
                      _services.registerComplaint(values);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuerySuccess(
                                  queryname: "Query",
                                )),
                      );
                    } else {
                      if (message == "") {
                        Fluttertoast.showToast(
                            msg: "Write a message to continue",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 2,
                            gravity: ToastGravity.BOTTOM);
                      } else if (selectedKey == "Please Select") {
                        Fluttertoast.showToast(
                            msg: "Please Select a valid  topic",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 2,
                            gravity: ToastGravity.BOTTOM);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Unknown error occured",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 2,
                            gravity: ToastGravity.BOTTOM);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField MessageFormField() {
    return TextFormField(
      style: TextStyle(
        fontSize: getProportionateScreenHeight(15),
      ),
      maxLines: 5,
      onChanged: (value) {
        message = value;
      },
      decoration: InputDecoration(
        labelText: "Message",
        labelStyle: TextStyle(
          fontSize: getProportionateScreenHeight(15),
        ),
        hintStyle: TextStyle(
          fontSize: getProportionateScreenHeight(13),
        ),
        hintText: "Please enter your message ... ",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
