import 'package:flutter/material.dart';
import 'package:orev/screens/address/components/AddressPageDesktop.dart';
import 'package:orev/screens/address/components/AddressPageMobile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'components/AddressPageTablet.dart';
import 'components/body.dart';

class Address extends StatelessWidget {
  static String routeName = "/Address";

  const Address({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Form"),
      ),
      body: ScreenTypeLayout(
        mobile: AddressPageMobile(),
        tablet: AddressPageTablet(),
        desktop: AddressPageDesktop(),
      ),
    );
  }
}
