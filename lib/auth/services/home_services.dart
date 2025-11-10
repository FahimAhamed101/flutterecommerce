import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants/error_handling.dart';
import '../../constants/global_variables.dart';
import '../../constants/utils.dart';
import '../../models/product.dart';
import '../../providers/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      // Use the existing products endpoint
      http.Response res = await http.get(
        Uri.parse('$uri/api/products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var jsonData = jsonDecode(res.body) as List;
          // Take only first 6-8 products for deals section
          var limitedData = jsonData.take(8).toList();
          productList = limitedData.map((item) {
            // Handle sellerId conversion
            if (item['sellerId'] != null && item['sellerId'] is Map) {
              item['shopName'] = item['sellerId']['shopName']?.toString() ?? '';
              item['shopAvatar'] = item['sellerId']['shopAvatar']?.toString() ?? '';
              item['sellerId'] = item['sellerId']['_id']?.toString() ?? '';
            }
            return Product.fromMap(item);
          }).toList();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}