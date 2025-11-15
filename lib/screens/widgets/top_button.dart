



import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../auth/services/account_services.dart';
import '../../providers/user_provider.dart';
import 'account_button.dart';

class TopButton extends StatelessWidget {
  const TopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Orders',
              onTap: () {},
            ),
            AccountButton(
              text: (user.type == 'seller') ? 'My Shop' : 'Turn Seller',
              onTap: () {


              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Log Out',
              onTap: () => AccountServices().logOut(context),
            ),
            AccountButton(
              text: 'Set home address',
              onTap: () {

              },
            ),
          ],
        ),
      ],
    );
  }
}