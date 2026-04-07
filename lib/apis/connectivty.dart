import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CheckConnectivity {
  // Method to check internet connectivity
  Future<bool> isConnected() async {
    if (kIsWeb) return true;
    return await InternetConnection().hasInternetAccess;
  }
}