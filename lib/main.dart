import 'package:final_stockhive/auth/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StockHive());
}

class StockHive extends StatelessWidget {
  const StockHive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockHive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:Colors.white,
        primaryColorDark: const Color(0xFF05046a),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: const LoginPage(),
    );
  }
}
