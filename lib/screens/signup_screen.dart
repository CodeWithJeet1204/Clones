// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/button.dart';
import 'package:instagram/widgets/image_picker.dart';
import 'package:instagram/widgets/snackbar.dart';
import 'package:instagram/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Uint8List? _image;
  bool isImageTapped = false;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    bioController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    if (im == null) {
      setState(() {
        isImageTapped = false;
      });
    } else {
      setState(() {
        _image = im;
        isImageTapped = true;
      });
    }
  }

  void signUpUser() async {
    if (isImageTapped) {
      if (formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        String res = await AuthMethods().signUpUser(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
          bio: bioController.text,
          file: _image!,
          context: context,
        );

        setState(() {
          isLoading = false;
        });

        if (res != 'Success') {
          mySnackBar(context, "Some Error Occured");
        } else {
          Navigator.of(context).pushReplacementNamed('/responsive');
        }
      } else {
        mySnackBar(context, "Enter all the details");
      }
    } else {
      mySnackBar(context, "Pls Select An Image First");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign Up"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1000,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),
                  // Image
                  SvgPicture.asset(
                    'assets/insta_logo.svg',
                    color: primaryColor,
                  ),
                  const SizedBox(height: 48),
                  // Profile Picture
                  isImageTapped
                      ? Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Colors.grey.shade400,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Colors.grey.shade400,
                                    backgroundImage: const NetworkImage(
                                      'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg',
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton.filled(
                                tooltip: "Change Profile Picture",
                                iconSize: 30,
                                onPressed: selectImage,
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                            ),
                          ],
                        )
                      : IconButton.filled(
                          tooltip: "Change Profile Picture",
                          iconSize: 70,
                          padding: const EdgeInsets.only(
                            top: 22,
                            right: 22,
                            left: 22,
                            bottom: 16,
                          ),
                          onPressed: selectImage,
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),

                  const SizedBox(height: 18),
                  // Username
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextField(
                          controller: usernameController,
                          hintText: "Username",
                          keyboardType: TextInputType.text,
                        ),
                        // Bio
                        const SizedBox(height: 24),
                        MyTextField(
                          controller: bioController,
                          hintText: "Bio",
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Login
                  MyPrimaryButton(
                    buttonText: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          )
                        : const Text("Sign Up"),
                    horizontal: 0,
                    vertical: 12,
                    onTap: signUpUser,
                  ),
                  const SizedBox(height: 48),
                  Flexible(
                    flex: 0,
                    child: Container(),
                  ),
                  // Login
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
