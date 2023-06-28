import 'package:flutter/material.dart';
import '../api_connections/api.dart';

class StockInPage extends StatefulWidget {
  const StockInPage({super.key});

  @override
  State<StockInPage> createState() => _StockInPageState();
}

class _StockInPageState extends State<StockInPage> {
  List<dynamic> products = [];
  String selectedProductId = '';
  int quantityAdded = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      var productList = await API.getProducts();
      setState(() {
        products = productList;
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  Future<void> addStockIn() async {
    if (selectedProductId.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select a product'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (quantityAdded <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a valid quantity'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await API.addStockHistory(selectedProductId, quantityAdded);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Stock in recorded successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to add stock in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Stock In'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedProductId.isNotEmpty ? selectedProductId : (products.isNotEmpty ? products[0]['id'].toString() : ''),
              onChanged: (String? newValue) {
                setState(() {
                  selectedProductId = newValue!;
                });
              },
              items: products.map<DropdownMenuItem<String>>((dynamic product) {
                final String productId = product['id'].toString();
                final String productName = product['name'] as String;
                return DropdownMenuItem<String>(
                  value: productId,
                  child: Text(productName),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Quantity Added',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  quantityAdded = int.parse(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo
              ),
              onPressed: addStockIn,
              child: const Text('Stock In'),
            ),
          ],
        ),
      ),
    );
  }
}