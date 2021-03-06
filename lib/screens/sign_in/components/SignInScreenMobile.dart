import 'package:flutter/material.dart';
import 'package:orev/components/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class SignInScreenMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenHeight(27),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
