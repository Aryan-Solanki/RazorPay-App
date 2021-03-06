import 'package:flutter/material.dart';
import 'package:orev/screens/forgot_password/components/updatepassword.dart';

import '../../size_config.dart';
import 'components/body.dart';

class UpdatePasswordScreen extends StatelessWidget {
  static String routeName = "/update_password";
  String phone_uid;
  UpdatePasswordScreen({this.phone_uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password",style: TextStyle(
          fontSize: getProportionateScreenHeight(18),
        )),
      ),
      body: UpdatePassword(phone_uid: phone_uid),
    );
  }
}
