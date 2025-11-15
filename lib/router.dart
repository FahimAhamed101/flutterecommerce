import 'package:flutter/material.dart';
import 'package:flutterecommerce/screens/Admin/admin_screen.dart';
import 'package:flutterecommerce/screens/auth_screen.dart';
import 'package:flutterecommerce/screens/product_details/product_details_screen.dart';
import 'package:flutterecommerce/screens/widgets/bottom_bar.dart';

import 'models/product.dart';




Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
  case AuthScreen.routeName:
  return MaterialPageRoute(
  settings: routeSettings,
  builder: (_) => const AuthScreen(),
  );
    case ProductDetailsScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailsScreen(
          product: product,
        ),
      );


    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Page fault!'),
          ),
        ),
      );
  }


}