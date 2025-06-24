import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainAuthButton extends StatelessWidget {
  const MainAuthButton({
    super.key,
    required this.lable,
    required this.onPressed,
    required this.fontSize,
  });

  final String lable;
  final Function() onPressed;
  final double fontSize;


  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: const Color.fromARGB(255, 232, 232, 232),
      borderRadius: BorderRadius.circular(20), // This is for the Material widget
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: double.infinity,
        // Add the shape property for the MaterialButton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // You can adjust the radius here
        ),
        child: Text(
          lable,
          style: GoogleFonts.lato(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
