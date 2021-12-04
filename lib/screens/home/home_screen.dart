import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orev/components/coustom_bottom_nav_bar.dart';
import 'package:orev/components/updateavailablescreen.dart';
import 'package:orev/enums.dart';
import 'package:orev/services/product_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../constants.dart';
import 'components/HomeScreenDesktop.dart';
import 'components/HomeScreenMobile.dart';
import 'components/HomeScreenTablet.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  bool returnFromLogOut;
  HomeScreen({this.returnFromLogOut = false});
  @override
  _HomeScreenState createState() =>
      _HomeScreenState(returnFromLogOut: returnFromLogOut);
}

class _HomeScreenState extends State<HomeScreen> {
  bool firsttime = false;
  bool maintenance = false;
  bool updateAvailable = false;

  bool returnFromLogOut;
  _HomeScreenState({this.returnFromLogOut = false});

  checkInitial() async {
    ProductServices _services = ProductServices();
    DocumentSnapshot check = await _services.initialChecks.get();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;

    if (version != check["currentVersion"] && check["updateAvailable"]) {
      updateAvailable = true;
    }

    maintenance = check["maintenance"];

    if (updateAvailable) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateAvailable(
                  value: "Download Now",
                  bottomNavigation: false,
                )),
      );
    } else if (maintenance) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateAvailable(
                  value: "Come Back Soon",
                  bottomNavigation: false,
                )),
      );
    }
  }

  @override
  void initState() {
    firsttime = true;
    checkInitial();
    super.initState();
  }

  DateTime backbuttonpressedTime;

  @override
  Widget build(BuildContext context) {
    if (returnFromLogOut) {
      Fluttertoast.showToast(
          msg: "You have logged out successfully",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 2,
          gravity: ToastGravity.BOTTOM);
    }
    return WillPopScope(
      onWillPop: () async {
        DateTime currenttime = DateTime.now();
        bool backbutton = backbuttonpressedTime == null ||
            currenttime.difference(backbuttonpressedTime) >
                Duration(seconds: 2);
        if (backbutton) {
          backbuttonpressedTime = currenttime;
          Fluttertoast.showToast(
              msg: "Double Tap to close App",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
              gravity: ToastGravity.BOTTOM);
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: HomeScreenMobile(),
          tablet: HomeScreenTablet(),
          desktop: HomeScreenDesktop(),
        ),
        bottomNavigationBar: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            // Check the sizing information here and return your UI
            if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
              return Visibility(visible: false,child: CustomBottomNavBar(selectedMenu: MenuState.home));
            }

            if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
              return CustomBottomNavBar(selectedMenu: MenuState.home);
            }

            if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
              return CustomBottomNavBar(selectedMenu: MenuState.home);
            }

            return CustomBottomNavBar(selectedMenu: MenuState.home);
          },
        )
      ),
    );
  }
}
