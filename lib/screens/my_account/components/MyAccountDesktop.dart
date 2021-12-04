import 'package:flutter/material.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/my_account/components/update_profile_form.dart';
import 'package:orev/screens/profile/components/profile_pic.dart';
import 'package:orev/services/user_services.dart';
import 'package:orev/services/user_simple_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class MyAccountDesktop extends StatefulWidget {
  @override
  _MyAccountDesktopState createState() => _MyAccountDesktopState();
}

class _MyAccountDesktopState extends State<MyAccountDesktop> {
  String authkey = "";
  String name = "";

  getUserName() async {
    UserServices _services = new UserServices();
    var doc = await _services.getUserById(authkey);
    name = doc["name"];
    setState(() {});
  }

  @override
  void initState() {
    authkey = UserSimplePreferences.getAuthKey() ?? "";
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          HomeHeader(),
          SizedBox(height: getProportionateScreenHeight(10)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenHeight(20)),
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: kPrimaryColor2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Hello $name!", style: headingStyle),
                        Text(
                          "Update your profile",
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(15)),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        ProfilePic(
                          camera: true,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        UpdateProfileForm(),
                        SizedBox(height: SizeConfig.screenHeight * 0.08),
                        Text(
                          'By continuing your confirm that you agree \nwith our Term and Condition',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getProportionateScreenHeight(13)),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
