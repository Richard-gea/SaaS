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
      defaultValue: 'https://your-backend-url.com');

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

    // For now, simulate success (we'll add real backend later)
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _message = 'Thanks! You\'ll be notified when we launch.';
      _emailController.clear();
      _loading = false;
    });

    /* Comment out the real HTTP call for now
    try {
      final uri = Uri.parse('$backendUrl/api/signup');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'source': 'landing'}),
      );

      if (resp.statusCode == 200) {
        setState(() {
          _message = 'Thanks! You\'ll be notified when we launch.';
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
      setState(() => _message = 'Network error. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
    */
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),

              // Header
              Text(
                'Discover Local Restaurant Menus',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Text(
                'Find authentic local restaurants and their menus based on your location. Perfect for tourists and food lovers!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // Email signup form
              Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    Text(
                      'Get notified when we launch:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _loading ? null : submitEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _loading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text('Notify Me'),
                        ),
                      ],
                    ),

                    if (_message != null) ...[
                      SizedBox(height: 12),
                      Text(
                        _message!,
                        style: TextStyle(
                          color: _message!.contains('Thanks')
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 60),

              Text(
                'For restaurants: Join our pilot program — limited spots.',
                style: TextStyle(color: Colors.grey[700]),
              ),

              SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  // TODO: Add contact functionality
                },
                child: Text('Contact us'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
