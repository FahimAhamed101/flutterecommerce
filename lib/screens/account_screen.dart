import 'package:flutter/material.dart';
import 'package:flutterecommerce/screens/widgets/top_button.dart';
import 'package:provider/provider.dart';

import '../auth/services/account_services.dart';
import '../constants/global_variables.dart';
import '../providers/user_provider.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  int unreadCount = 0;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();

  }







  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Tăng chiều cao một chút
        child: AppBar(
          elevation: 0, // Bỏ shadow
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Column(
            //mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 7),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Hello, ',
                      ),
                      TextSpan(
                        text: user.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ]),
              ),
            ],
          ),

        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          TopButton(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Your Orders',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          ),
          Divider(),


        ],
      ),
    );
  }
}