import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orev/components/custom_surfix_icon.dart';
import 'package:orev/components/default_button.dart';
import 'package:orev/components/form_error.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/complete_profile/complete_profile_screen.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:orev/services/product_services.dart';
import 'package:orev/services/user_services.dart';
import 'package:search_choices/search_choices.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'city_and_states.dart';

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  String password;
  String conform_password;
  bool remember = false;
  String phone;
  String Name;
  List<String> errors = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  String selectedValueSingleDialog = "";
  String selected_state = "";
  String selected_city = "Search for your City";
  String AddressLine1 = "";
  String AddressLine2 = "";
  String Addressname = "";
  List<dynamic> addressmap = [];
  String user_key;

  Future<void> getAllAddress() async {
    ProductServices _services = ProductServices();
    print(user_key);
    var userref = await _services.users.doc(user_key).get();
    addressmap = userref["address"];
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();
    user_key = AuthProvider().user.uid;
    getAllAddress();
    super.initState();
  }

  String pincode;
  @override
  Widget build(BuildContext context) {
    Future<void> setAddress(addressDict) async {
      addressmap.add(addressDict);
      ProductServices _services = ProductServices();
      print(user_key);
      var finalmap = {"address": addressmap};
      await _services.updateAddress(finalmap, user_key);
      Navigator.pop(context, true);
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildAddressNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField1(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField2(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(20),
                horizontal: getProportionateScreenHeight(13)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xff565656),
              ),
            ),
            child: SearchChoices.single(
              onClear: () {
                setState(() {
                  selected_state = "";
                  selected_city = "Search for your City";
                });
              },
              underline: NotGiven(),
              selectedValueWidgetFn: (item) {
                return Container(
                    transform: Matrix4.translationValues(-10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: (Text(item.toString())));
              },
              items: state(),
              value: selected_state,
              hint: "Search for your State",
              padding: 30,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selected_state = value;
                  });
                }
              },
              isExpanded: true,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(20),
                horizontal: getProportionateScreenHeight(13)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xff565656),
              ),
            ),
            child: SearchChoices.single(
              onClear: () {
                selected_city = "Search for your City";
              },
              padding: 30,
              underline: NotGiven(),
              selectedValueWidgetFn: (item) {
                return Container(
                    transform: Matrix4.translationValues(-10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: (Text(item.toString())));
              },
              hint: "Search for your City",
              items: city(selected_state),
              value: selected_city,
              onChanged: (value) {
                if (value != null) {
                  selected_city = value;
                }

// selectedValueSingleDialog = value;
              },
              isExpanded: true,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPincodeFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              errors = [];
              if (_formKey.currentState.validate() &&
                  selected_state != "" &&
                  selected_city != "Search for your City") {
                var Adddict = {
                  "name": Addressname,
                  "adline1": AddressLine1,
                  "adline2": AddressLine2,
                  "pincode": int.parse(pincode),
                  "state": selected_state,
                  "city": selected_city
                };
                await setAddress(Adddict);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPincodeFormField() {
    return TextFormField(
      maxLength: 6,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => pincode = newValue,
      onChanged: (value) {
        pincode = value;
        if (value.isNotEmpty) {
          removeError(error: kPincodeNullError);
        }
        if (value.length == 10) {
          removeError(error: kShortPincodeError);
          removeError(error: kLongPincodeError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPincodeNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPincodeError);

          return "";
        } else if (value.length > 6) {
          addError(error: kLongPincodeError);

          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: "PIN Code",
        hintText: "Enter your PIN Code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.pin_drop_outlined),
      ),
    );
  }

  TextFormField buildAddressFormField1() {
    return TextFormField(
      onSaved: (newValue) => AddressLine1 = newValue,
      onChanged: (value) {
        AddressLine1 = value;
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address Line 1",
        hintText: "House Number ,Floor ,Building",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAddressFormField2() {
    return TextFormField(
      onSaved: (newValue) => AddressLine2 = newValue,
      onChanged: (value) {
        AddressLine2 = value;
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address Line 2",
        hintText: "Street Address ,P.O.Box ,Company Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAddressNameFormField() {
    return TextFormField(
      onSaved: (newValue) => Addressname = newValue,
      onChanged: (value) {
        Addressname = value;
        if (value.isNotEmpty) {
          removeError(error: kAddressNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => Name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
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
