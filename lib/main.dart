import 'package:flutter/material.dart';
import 'package:flutterecommerce/providers/product_provider.dart';
import 'package:flutterecommerce/providers/user_provider.dart';
import 'package:flutterecommerce/router.dart';
import 'package:flutterecommerce/screens/Admin/admin_screen.dart';
import 'package:flutterecommerce/screens/auth_screen.dart';
import 'package:flutterecommerce/screens/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

import 'auth/services/auth_service.dart';
import 'constants/global_variables.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        // Add other providers as needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: GlobalVariables.primaryColor,
          primary: GlobalVariables.primaryColor,
          secondary: GlobalVariables.secondaryColor,
          background: GlobalVariables.backgroundColor,
        ),
        // Thêm các thuộc tính theme khác
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: (Provider.of<UserProvider>(context).user.token.isNotEmpty)
          ? (Provider.of<UserProvider>(context).user.type == "admin")
          ? const AdminScreen()
          : const BottomBar()
          : const AuthScreen(),
    );
  }
}