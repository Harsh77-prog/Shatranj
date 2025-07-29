import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shatranj/service/assets_manager.dart';
import 'package:shatranj/widgets/main_auth_button.dart';
import 'package:shatranj/widgets/widgets.dart';

import '../constants.dart';
import '../widgets/social_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 33, 33),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(AssetsManager.chessIcon),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                cursorColor: const Color.fromARGB(255, 33, 33, 33),
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  hintText: "enter your e-mail",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 232, 232, 232),
                  border: outlineBorder,
                  enabledBorder: outlineBorder,
                  disabledBorder: outlineBorder,
                  focusedBorder: outlineBorder,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: const Color.fromARGB(255, 33, 33, 33),
                obscureText: true,
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  hintText: "and password",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 232, 232, 232),
                  border: outlineBorder,
                  enabledBorder: outlineBorder,
                  disabledBorder: outlineBorder,
                  focusedBorder: outlineBorder,
                ),
              ),
              const SizedBox(
                height: 0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Forgot Password Method Here
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MainAuthButton(
                lable: "Log In",
                onPressed: () {
                  // TODO: login user with email and password
                },
                fontSize: 24,
              ),
              const SizedBox(
                height: 50,
              ),
              Text("- OR - ",
                  style: GoogleFonts.lato(
                    color: const Color.fromARGB(255, 232, 232, 232),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialButton(
                      label: "Play as Guest",
                      height: 55,
                      width: 55,
                      onTap: () {},
                      assetImage: AssetsManager.userWhiteIcon),
                  SocialButton(
                      label: "Google",
                      height: 55,
                      width: 55,
                      onTap: () {},
                      assetImage: AssetsManager.googleIcon),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              HaveAccountWidget(
                  label: "Don't have an Account?",
                  labelAction: "Sign Up",
                  onPressed: () {
                    Navigator.pushNamed(context, Constants.signUpScreen);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  final outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Color.fromARGB(255, 232, 232, 232)),
  );
}
