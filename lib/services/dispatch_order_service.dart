import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dispatch_order.dart';
import 'secure_storage_service.dart';

class DispatchOrderService {
  static const String _dispatchOrdersEndpoint = 'https://personal-d9p61k4i.outsystemscloud.com/production/rest/v1/dispatchOrders';
  
  /// Fetches dispatch orders for the current user
  static Future<List<DispatchOrder>> getDispatchOrders() async {
    try {
      // Get the JWT token
      final String? token = await SecureStorageService.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Make the API call with the token in the Authorization header
      final response = await http.get(
        Uri.parse(_dispatchOrdersEndpoint),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => DispatchOrder.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load dispatch orders: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw the exception to be handled by the caller
      throw Exception('Error fetching dispatch orders: $e');
    }
  }
}
