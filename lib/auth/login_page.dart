import 'package:final_stockhive/view_pages/stock_page.dart';
import 'package:flutter/material.dart';
import '../api_connections/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> login() async {
    final String username = controllerUsername.text.trim();
    final String password = controllerPassword.text.trim();

    setState(() {
      isLoading = true;
    });

    bool isAuthenticated = await API.loginUser(username, password);

    setState(() {
      isLoading = false;
    });

    if (isAuthenticated) {
      // Authentication successful
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const StockPage()),
              (route) => false);
    } else {
      // Authentication failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_login.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  SizedBox(height: screenHeight / 10),
                  const Text(
                    'StockHive',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: screenHeight / 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: controllerUsername,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      validator: (value) {
                        return value == null || value.isEmpty
                            ? 'Username is required'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: controllerPassword,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: isLoading ? null : login, // Disable login button when loading
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: isLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                          : const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight / 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
