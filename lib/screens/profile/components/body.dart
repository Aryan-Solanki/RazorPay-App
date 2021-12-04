import 'package:flutter/material.dart';
import 'package:orev/components/comingsoonpage.dart';
import 'package:orev/providers/auth_provider.dart';
import 'package:orev/screens/help_center/help_center.dart';
import 'package:orev/screens/home/components/home_header.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:orev/screens/my_account/my_account.dart';
import 'package:orev/screens/sign_in/sign_in_screen.dart';
import 'package:orev/screens/wallet/wallet.dart';
import 'package:orev/screens/your_order/your_order.dart';
import 'package:orev/services/user_simple_preferences.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String authkey = "";

  @override
  void initState() {
    authkey = UserSimplePreferences.getAuthKey() ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: kPrimaryColor2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(10)),
              HomeHeader(),
              SizedBox(height: getProportionateScreenHeight(10)),
              Column(
                children: [
                  ProfilePic(
                    camera: false,
                  ),
                  SizedBox(height: 20),
                  ProfileMenu(
                    text: "My Account",
                    icon: "assets/icons/User Icon.svg",
                    press: () {
                      if (authkey != "") {
                        Navigator.pushNamed(context, MyAccount.routeName);
                      } else {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      }
                    },
                  ),
                  ProfileMenu(
                    text: "Orev Wallet",
                    icon: "",
                    press: () {
                      if (authkey != "") {
                        Navigator.pushNamed(context, Wallet.routeName);
                      } else {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      }
                    },
                  ),
                  ProfileMenu(
                    text: "Your Orders",
                    icon: "assets/icons/Bell.svg",
                    press: () {
                      if (authkey != "") {
                        Navigator.pushNamed(context, YourOrder.routeName);
                      } else {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      }
                    },
                  ),
                  ProfileMenu(
                    text: "Help Center",
                    icon: "assets/icons/Question mark.svg",
                    press: () {
                      Navigator.pushNamed(context, HelpCenter.routeName);
                    },
                  ),
                  authkey != ""
                      ? ProfileMenu(
                          text: "Log Out",
                          icon: "assets/icons/Log out.svg",
                          press: () {
                            _auth.signOut();
                            UserSimplePreferences.setAuthKey("");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  returnFromLogOut: true,
                                ),
                              ),
                            );
                          },
                        )
                      : ProfileMenu(
                          text: "Sign In",
                          icon: "assets/icons/Log out.svg",
                          press: () {
                            Navigator.pushReplacementNamed(
                                context, SignInScreen.routeName);
                          },
                        ),
                  ProfileMenu(
                    text: "Become a Vendor",
                    icon: "assets/icons/Shop Icon.svg",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComingSoon(
                                  value: "Vendor Service",
                                  bottomNavigation: false,
                                )),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
