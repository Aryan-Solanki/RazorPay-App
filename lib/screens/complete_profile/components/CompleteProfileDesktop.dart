import 'package:flutter/material.dart';
import 'package:orev/constants.dart';
import 'package:orev/size_config.dart';

import 'complete_profile_form.dart';

class CompleteProfileDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: kPrimaryColor2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    Text("Complete Profile", style: headingStyle),
                    Text(
                      "Complete your details or continue  \nwith social media",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    CompleteProfileForm(),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    Text(
                      "By continuing your confirm that you agree \nwith our Terms and Conditions",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
