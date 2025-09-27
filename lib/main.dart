import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menus Nearby',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _emailController = TextEditingController();
  bool _loading = false;
  String? _message;

// TODO: replace with your deployed backend URL
  final String backendUrl = const String.fromEnvironment('BACKEND_URL',
      defaultValue: 'http://localhost:4000');

 Future<void> submitEmail() async {
  final email = _emailController.text.trim();
  if (email.isEmpty || !email.contains('@')) {
    setState(() => _message = 'Please enter a valid email.');
    return;
  }

  setState(() {
    _loading = true;
    _message = null;
  });

  try {
    final uri = Uri.parse('$backendUrl/api/signup');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'source': 'landing'}),
    );

    if (resp.statusCode == 200) {
      setState(() {
        _message = 'Thanks! You\'ll be notified.';
        _emailController.clear();
      });
    } else if (resp.statusCode == 400) {
      setState(() => _message = 'Please enter a valid email.');
    } else if (resp.statusCode == 409) {
      setState(() => _message = 'This email is already registered.');
    } else {
      setState(() => _message = 'Failed to sign up. Try again later.');
    }
  } catch (e) {
    setState(() => _message = 'Network error. Check console.');
  } finally {
    setState(() => _loading = false);
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _priceCard(String title, String price, String subtitle) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text(price,
            style: TextStyle(
                fontSize: 16,
                color: Colors.orange[700],
                fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Menus Nearby',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800])),
              SizedBox(height: 12),
              Text('Get notified when we launch in your city!',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 24),

// Signup form
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _loading ? null : submitEmail,
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
                    child: _loading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text('Notify Me'),
                  )
                ],
              ),

              if (_message != null) ...[
                SizedBox(height: 12),
                Text(_message!, style: TextStyle(color: Colors.green[700])),
              ],

              SizedBox(height: 30),
              Text('For restaurants: Join our pilot program — limited spots.',
                  style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 12),
              TextButton(
                  onPressed: () {/* link to contact */},
                  child: Text('Contact us')),
            ],
          ),
        ),
      ),
    );
  }
}
