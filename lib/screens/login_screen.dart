// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/button.dart';
import 'package:instagram/widgets/snackbar.dart';
import 'package:instagram/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLoginUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().loginUser(
          context: context,
          email: emailController.text,
          password: passwordController.text);
      if (res == "Success") {
        mySnackBar(context, "Logged In Succesffully");
        Navigator.of(context).pushReplacementNamed('/responsive');
      } else {
        mySnackBar(context, "Some Error Occured");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
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
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor),
                            )
                          : const Text("Login"),
                      horizontal: 0,
                      vertical: 12,
                      onTap: onLoginUser,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // Sign Up
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popAndPushNamed('/signup');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
