import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../service/assets_manager.dart';
import '../widgets/main_auth_button.dart';
import '../widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(AssetsManager.userIcon),
                    backgroundColor: const Color.fromARGB(255, 232, 232, 232),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 232, 232),
                        border: Border.all(
                          width: 2,
                          color: Color.fromARGB(255, 33, 33, 33),
                        ),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_circle_outline_outlined,
                            color: Color.fromARGB(255, 33, 33, 33),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                cursorColor: const Color.fromARGB(255, 33, 33, 33),
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  hintText: "enter your name",
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
                  hintText: "and choose a password",
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
                lable: "Sign Up",
                onPressed: () {
                  // TODO: login user with email and password
                },
                fontSize: 24,
              ),
              const SizedBox(
                height: 50,
              ),
              HaveAccountWidget(
                  label: "Have an Account?",
                  labelAction: "Log In",
                  onPressed: () {
                    Navigator.pop(context, Constants.loginScreen);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

final outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: const BorderSide(color: Color.fromARGB(255, 232, 232, 232)),
);
