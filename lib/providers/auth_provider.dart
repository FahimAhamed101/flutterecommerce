import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
}
