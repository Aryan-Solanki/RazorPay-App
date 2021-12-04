import 'package:flutter/widgets.dart';
import 'package:orev/screens/Order_Details/order_details.dart';
import 'package:orev/screens/address/address.dart';
import 'package:orev/screens/cart/cart_screen.dart';
import 'package:orev/screens/help_center/help_center.dart';
import 'package:orev/screens/help_form/help_form.dart';
import 'package:orev/screens/liked_item/like_screen.dart';
import 'package:orev/screens/complete_profile/complete_profile_screen.dart';
import 'package:orev/screens/details/details_screen.dart';
import 'package:orev/screens/forgot_password/forgot_password_screen.dart';
import 'package:orev/screens/forgot_password/update_password_screen.dart';
import 'package:orev/screens/home/home_screen.dart';
import 'package:orev/screens/login_success/login_success_screen.dart';
import 'package:orev/screens/my_account/my_account.dart';
import 'package:orev/screens/offer_and_category_screen/offerzone_and_category.dart';
import 'package:orev/screens/order_details_multiple/order_details_multiple.dart';
import 'package:orev/screens/otp/otp_screen.dart';
import 'package:orev/screens/payment_success/payment_success.dart';
import 'package:orev/screens/profile/profile_screen.dart';
import 'package:orev/screens/seemore/seemore.dart';
import 'package:orev/screens/sign_in/sign_in_screen.dart';
import 'package:orev/screens/splash/splash_screen.dart';
import 'package:orev/screens/wallet/wallet.dart';
import 'package:orev/screens/your_order/components/your_order_detail.dart';
import 'package:orev/screens/your_order/your_order.dart';

import 'screens/category_page/category_page.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),//done ui
  SignInScreen.routeName: (context) => SignInScreen(),//done ui
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),//done ui
  UpdatePasswordScreen.routeName: (context) => UpdatePasswordScreen(),//not done
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),//done ui
  SignUpScreen.routeName: (context) => SignUpScreen(),//done ui
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),//not done
  // OtpScreen.routeName: (context) => OtpScreen(), no idea where used??
  HomeScreen.routeName: (context) => HomeScreen(),//done ui
  DetailsScreen.routeName: (context) => DetailsScreen(),//done ui
  CartScreen.routeName: (context) => CartScreen(),//ui done
  LikedScreen.routeName: (context) => LikedScreen(),//ui done
  ProfileScreen.routeName: (context) => ProfileScreen(),//uidone
  SeeMore.routeName: (context) => SeeMore(),//uidone
  Address.routeName: (context) => Address(),
  OrderDetails.routeName: (context) => OrderDetails(),//uidone
  OrderDetailsMultiple.routeName: (context) => OrderDetailsMultiple(),//uidone
  YourOrder.routeName: (context) => YourOrder(),//uidone
  YourOrderDetail.routeName: (context) => YourOrderDetail(),//uidone
  Wallet.routeName: (context) => Wallet(),//uidone
  CategoryPage.routeName: (context) => CategoryPage(),//uidone
  MyAccount.routeName: (context) => MyAccount(),//uidone
  HelpCenter.routeName: (context) => HelpCenter(),//uidone
  HelpForm.routeName: (context) => HelpForm(),//uidone
  PaymentSuccess.routeName: (context) => PaymentSuccess(),//uidone
  OfferzoneCategory.routeName: (context) => OfferzoneCategory(),//uidone
};

