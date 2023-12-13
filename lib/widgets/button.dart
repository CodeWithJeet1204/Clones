// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

class MyPrimaryButton extends StatefulWidget {
  MyPrimaryButton({
    super.key,
    required this.buttonText,
    this.width = double.infinity,
    this.color = blueColor,
    this.horizontal = 0,
    required this.vertical,
    this.radius = 4,
    required this.onTap,
    // required this.secondButtonText,
  });

  Widget buttonText;
  // final Widget secondButtonText;
  final double? width;
  final Color color;
  final double horizontal;
  final double vertical;
  final double radius;
  final void Function()? onTap;

  @override
  State<MyPrimaryButton> createState() => _MyPrimaryButtonState();
}

class _MyPrimaryButtonState extends State<MyPrimaryButton> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: widget.vertical, horizontal: widget.horizontal),
        decoration: ShapeDecoration(
          color: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
        child: widget.buttonText,
      ),
    );
  }
}
