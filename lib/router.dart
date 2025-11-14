import 'package:flutter/material.dart';
import 'package:flutterecommerce/screens/auth_screen.dart';
import 'package:flutterecommerce/screens/product_details/product_details_screen.dart';

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