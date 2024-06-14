import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squares/squares.dart';

import '../providers/game_provider.dart';

Widget buildGameType({
  required String lable,
  String? gameTime,
  IconData? icon,
  required Function() onTap,
}) {
  Color cardColor = Color.fromARGB(255, 199, 149, 100); // Define the color here
  double cardElevation = 2.0; // Define the elevation here

  return InkWell(
    onTap: onTap,
    child: Card(
      color: cardColor, // Set the color of the card here
      elevation: cardElevation, // Set the elevation of the card here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon)
              : gameTime! == '60+0'
              ? const SizedBox.shrink()
              : Text(gameTime),
          const SizedBox(
            height: 10,
          ),
          Text(
            lable,
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 76, 50, 35)),
          )
        ],
      ),
    ),
  );
}



String getTimerToDisplay({
  required GameProvider gameProvider,
  required bool isUser,
}) {
  String timer = '';
  // check if is user
  if (isUser) {
    if (gameProvider.player == Squares.white) {
      timer = gameProvider.whitesTime.toString().substring(2, 7);
    }
    if (gameProvider.player == Squares.black) {
      timer = gameProvider.blacksTime.toString().substring(2, 7);
    }
  } else {
    // if its not user do the opposite
    if (gameProvider.player == Squares.white) {
      timer = gameProvider.blacksTime.toString().substring(2, 7);
    }
    if (gameProvider.player == Squares.black) {
      timer = gameProvider.whitesTime.toString().substring(2, 7);
    }
  }

  return timer;
}

// method to display the correct time below the board, if user is white then display white time
// if user is black then display black time

final List<String> gameTimes = [
  'Bullet 1+0',
  'Bullet 2+1',
  'Bullet 3+0',
  'Blitz 3+2',
  'Blitz 5+0',
  'Blitz 5+5',
  'Rapid 10+0',
  'Rapid 15+10',
  'Rapid 25+0',
  'Classical 30+0',
  'Classical 45+45',
  'Classical 60+0'
      'Custom ',
];

final List<String> gameDifficultyList = [
  'GRANDEE',
  'ARDASHIR',
  'CAÏSSA',
];

// var textFormDecoration = InputDecoration(
//   labelText: 'password',
//   hintText: 'Enter your Password',
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(8),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: const BorderSide(
//         color: Color.fromARGB(255, 248, 248, 245), width: 1),
//     borderRadius: BorderRadius.circular(8),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: const BorderSide(
//         color: Color.fromARGB(255, 248, 248, 245), width: 1),
//     borderRadius: BorderRadius.circular(8),
//   ),
// );
//
// var textFormField = TextFormField(
//   decoration: textFormDecoration,
//   style: GoogleFonts.lato(
//     color: Color.fromARGB(255, 248, 248, 245), // Change this to the desired text color
//   ),
// );


// pick an image
// Future<File?> pickImage({
//   required bool fromCamera,
//   required Function(String) onFail,
// }) async {
//   File? fileImage;
//   if (fromCamera) {
//     try {
//       final takenPhoto =
//       await ImagePicker().pickImage(source: ImageSource.camera);
//
//       if (takenPhoto != null) {
//         fileImage = File(takenPhoto.path);
//       }
//     } catch (e) {
//       onFail(e.toString());
//     }
//   } else {
//     try {
//       final chosenImage =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//
//       if (chosenImage != null) {
//         fileImage = File(chosenImage.path);
//       }
//     } catch (e) {
//       onFail(e.toString());
//     }
//   }
//
//   return fileImage;
// }

// validate email method
bool validateEmail(String email) {
  // Regular expression for email validation
  final RegExp emailRegex =
  RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  // Check if the email matches the regular expression
  return emailRegex.hasMatch(email);
}