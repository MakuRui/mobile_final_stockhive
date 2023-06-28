import 'package:flutter/material.dart';
import '../api_connections/api.dart';
import '../auth/login_page.dart';
import 'stock_in_page.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<String> stockName = [];
  List<List<String>> stockInfoList = [];

  @override
  void initState() {
    super.initState();
    fetchStockDetails();
  }

  Future<void> fetchStockDetails() async {
    final stockDetails = await API.getStockDetails();
    setState(() {
      stockName = stockDetails.map<String>((details) => details['name'] as String).toList();
      stockInfoList = stockDetails.map<List<String>>((details) {
        return [
          details['name'] as String,
          details['quantity'].toString(),
        ];
      }).toList();
    });
  }

  Future<void> _refreshStockDetails() async {
    // Simulate a delay for the refresh action
    await Future.delayed(const Duration(seconds: 2));
    await fetchStockDetails();
  }

  void _logout() {
    // Perform logout logic here

    // Navigate to the login page and replace the current route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _navigateToStockInPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StockInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          'STOCKS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshStockDetails,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Stock Name',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Stock Quantity',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stockInfoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  stockInfoList[index][0], // Access stock category
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  stockInfoList[index][1], // Access stock quantity
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToStockInPage,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
