import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utang/auth/loginpage.dart';
import 'package:utang/screens/homescreen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),
              // App Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF008975),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 45,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // register Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius:  BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius:  BorderRadius.circular(20),
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                     const SizedBox(height: 15,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius:  BorderRadius.circular(20),
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 14),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homescreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008975),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Forgot Password Link
                    TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        'Lupa Kata Sandi?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'atau',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A388),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Masuk Ke Akun yang sudah ada',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}