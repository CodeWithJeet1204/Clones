// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/button.dart';
import 'package:instagram/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            // Image
            SvgPicture.asset(
              'assets/insta_logo.svg',
              color: primaryColor,
            ),
            const SizedBox(height: 64),
            // Email
            MyTextField(
              controller: emailController,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            // Password
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              keyboardType: TextInputType.text,
              isObscured: true,
            ),
            const SizedBox(height: 36),
            // Login
            MyPrimaryButton(
              buttonText: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Sign Up"),
              horizontal: 0,
              vertical: 12,
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                setState(() {
                  isLoading = false;
                });
              },
            ),
            const SizedBox(height: 48),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).popAndPushNamed('/login');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Sign Up
          ],
        ),
      ),
    );
  }
}
