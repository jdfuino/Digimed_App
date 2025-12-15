import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _singleton = NavigationService._internal();
  late BuildContext _context;

  factory NavigationService() {
    return _singleton;
  }

  NavigationService._internal();

  void updateContext(BuildContext context) {
    _context = context;
  }

  void navigateToLogin() {
    Navigator.pushNamed(_context, '/login');
  }
}