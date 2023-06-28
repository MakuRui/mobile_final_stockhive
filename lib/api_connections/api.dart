import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static Future<bool> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.32/final_stockhive_appdev/index.php'), // Replace with your local API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Authentication successful
        return true;
      } else {
        // Authentication failed
        return false;
      }
    } catch (e) {
      // Error occurred during API call
      print('API Exception: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getStockDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.32/final_stockhive_appdev/stock_data_mobile_api.php'), // Replace with your API endpoint URL
      );

      if (response.statusCode == 200) {
        // API call successful
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          return jsonData;
        } else {
          // Handle the case when jsonData is null
          print('Stock data is null');
          return [];
        }
      } else {
        // API call failed
        return [];
      }
    } catch (e) {
      // Error occurred during API call
      print('API Exception: $e');
      return [];
    }
  }
  static Future<List<dynamic>> getProducts() async {
    var url = Uri.parse('http://192.168.1.32/final_stockhive_appdev/stock_view_mobile_api.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data as List<dynamic>; // Return the response as a List<dynamic>
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<void> addStockHistory(String productId, int quantityAdded) async {
    var url = Uri.parse('http://192.168.1.32/final_stockhive_appdev/stock_in_mobile_api.php');
    var requestBody = {
      'product_id': productId,
      'quantity_added': quantityAdded.toString(),
    };

    var response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data['message']); // Optionally, you can handle the success response here
    } else {
      throw Exception('Failed to add stock in');
    }
  }
}
