import 'dart:io';
import 'package:abojude_flutter/features/auth/forget_password/presentation/forget_password_screen.dart';
import 'package:abojude_flutter/features/auth/forget_password/presentation/forget_password_verify_otp_screen.dart';
import 'package:abojude_flutter/features/auth/login/presentation/login_screen.dart';
import 'package:abojude_flutter/features/auth/register/presentation/register_screen.dart';
import 'package:abojude_flutter/features/auth/register/presentation/register_verify_screen.dart';
import 'package:abojude_flutter/features/auth/register/presentation/select_location_screen.dart';
import 'package:abojude_flutter/features/auth/set_new_password/presentation/set_new_password.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/create_listing_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_step1_photos_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_step2_details_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_step3_location_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_step4_contact_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_step5_review_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_details_screen.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/presentation/buy_sell_success_screen.dart';
import 'package:abojude_flutter/features/home/presentation/home_screen.dart';
import 'package:abojude_flutter/welcome_screen.dart';
import 'package:flutter/cupertino.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  //---------------- Welcome Screen Start----------------
  static const String welcomeScreen = '/welcomeScreen';
  //---------------- Welcome Screen End----------------

  //---------------- Login Screen Start----------------
  static const String loginScreen = '/loginScreen';
  //---------------- Login Screen End----------------

  //---------------- Register Screen Start----------------
  static const String registerScreen = '/registerScreen';
  static const String registerVerifyScreen = '/registerVerifyScreen';
  static const String selectLocationScreen = '/selectLocationScreen';
  static const String homeScreen = '/homeScreen';

  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String forgetPasswordVerifyOtpScreen =
      '/forgetPasswordVerifyOtpScreen';
  static const String setNewPassword = '/setNewPassword';
  static const String createListingScreen = '/createListingScreen';
  static const String buySellStep1Photos = '/buySellStep1Photos';
  static const String buySellStep2Details = '/buySellStep2Details';
  static const String buySellStep3Location = '/buySellStep3Location';
  static const String buySellStep4Contact = '/buySellStep4Contact';
  static const String buySellStep5Review = '/buySellStep5Review';
  static const String buySellDetails = '/buySellDetails';
  static const String buySellSuccess = '/buySellSuccess';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ----------- Welcome Routes start-----------
      case Routes.welcomeScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: WelcomeScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => WelcomeScreen());

      // ----------- Auth Routes start-----------
      case Routes.loginScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const LoginScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const LoginScreen());

      case Routes.homeScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const HomeScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const HomeScreen());

      case Routes.registerScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const RegisterScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const RegisterScreen());

      case Routes.registerVerifyScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const RegisterVerifyScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const RegisterVerifyScreen(),
              );

      case Routes.selectLocationScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SelectLocationScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const SelectLocationScreen(),
              );

      case Routes.forgetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgetPasswordScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ForgetPasswordScreen(),
              );

      case Routes.forgetPasswordVerifyOtpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgetPasswordVerifyOtpScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ForgetPasswordVerifyOtpScreen(),
              );

      case Routes.setNewPassword:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SetNewPassword(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const SetNewPassword());

      case Routes.createListingScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const CreateListingScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const CreateListingScreen(),
              );

      case Routes.buySellStep1Photos:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const BuySellStep1PhotosScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const BuySellStep1PhotosScreen(),
              );

      case Routes.buySellStep2Details:
        final args = settings.arguments as BuySellListingModel;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: BuySellStep2DetailsScreen(model: args),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BuySellStep2DetailsScreen(model: args),
              );

      case Routes.buySellStep3Location:
        final args = settings.arguments as BuySellListingModel;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: BuySellStep3LocationScreen(model: args),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BuySellStep3LocationScreen(model: args),
              );

      case Routes.buySellStep4Contact:
        final args = settings.arguments as BuySellListingModel;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: BuySellStep4ContactScreen(model: args),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BuySellStep4ContactScreen(model: args),
              );

      case Routes.buySellStep5Review:
        final args = settings.arguments as BuySellListingModel;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: BuySellStep5ReviewScreen(model: args),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BuySellStep5ReviewScreen(model: args),
              );

      case Routes.buySellDetails:
        final args = settings.arguments as BuySellListingModel;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: BuySellDetailsScreen(model: args),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BuySellDetailsScreen(model: args),
              );

      case Routes.buySellSuccess:
        final args = settings.arguments as BuySellListingModel;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: BuySellSuccessScreen(model: args),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => BuySellSuccessScreen(model: args),
              );

      // case Routes.interpretationScren:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: const InterpretationScren(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(
      //           builder: (context) => const InterpretationScren(),
      //         );

      // case Routes.userNavigationMenu:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: const NavigationMenu(),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(builder: (context) => const NavigationMenu());

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
                child: child,
              );
            },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
