import 'package:flutter/material.dart';
import 'package:orev/screens/wallet/components/WalletScreenDesktop.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../size_config.dart';
import 'components/WalletScreenMobile.dart';
import 'components/WalletScreenTablet.dart';
import 'components/body.dart';

class Wallet extends StatefulWidget {
  static String routeName = "/Wallet";

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenTypeLayout(
          mobile: WalletScreenMobile(),
          tablet: WalletScreenTablet(),
          desktop: WalletScreenDesktop(),
        ),
      ),
    );
  }
}
