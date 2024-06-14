import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class PlayerColorRadioButton extends StatelessWidget {
  const PlayerColorRadioButton({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final PlayerColor value;
  final PlayerColor? groupValue;
  final Function(PlayerColor?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 232, 232, 232),
              Color.fromARGB(255, 232, 232, 232),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 33, 33, 33),
              offset: Offset(7, 7),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Color.fromARGB(255, 33, 33, 33),
              offset: Offset(-7, -7),
              blurRadius: 15,
            ),
          ],
        ),
        child: RadioListTile<PlayerColor>(
          title: Text(
            title,
            style: GoogleFonts.lato(
              color: Color.fromARGB(255, 33, 33, 33),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          value: value,
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          tileColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading, // Align the radio button to the start
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}




class GameLevelRadioButton extends StatelessWidget {
  const GameLevelRadioButton({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final GameDifficulty value;
  final GameDifficulty? groupValue;
  final ValueChanged<GameDifficulty?> onChanged;

  @override
  Widget build(BuildContext context) {
    final capitalizedTitle = title[0].toUpperCase() + title.substring(1);
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 232, 232, 232),
              Color.fromARGB(255, 232, 232, 232),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(25, 25, 25, 1.0),
              offset: Offset(7, 7),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Color.fromRGBO(60, 60, 60, 1.0),
              offset: Offset(-7, -7),
              blurRadius: 15,
            ),
          ],
        ),
        child: RadioListTile<GameDifficulty>(
          title: Text(
            capitalizedTitle,
            style: GoogleFonts.lato(
              color: Color.fromARGB(255, 33, 33, 33),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          value: value,
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          tileColor: Colors.transparent,
          controlAffinity: ListTileControlAffinity.leading, // Align the radio button to the start
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }

}








class BuildCustomTime extends StatelessWidget {
  const BuildCustomTime({
    Key? key,
    required this.time,
    required this.onLeftArrowClicked,
    required this.onRightArrowClicked,
    this.arrowColor = Colors.white,
    this.containerColor = Colors.transparent,
  }) : super(key: key);

  final String time;
  final Function() onLeftArrowClicked;
  final Function() onRightArrowClicked;
  final Color arrowColor;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: time == '0' ? null : onLeftArrowClicked,
          child: Container(
            color: containerColor,
            child: Icon(
              Icons.arrow_back,
              color: arrowColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Color.fromARGB(255, 245, 245, 245)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  time,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Color.fromARGB(255, 245, 245, 245),
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onRightArrowClicked,
          child: Container(
            color: containerColor,
            child: Icon(
              Icons.arrow_forward,
              color: arrowColor,
            ),
          ),
        ),
      ],
    );
  }
}


class HaveAccountWidget extends StatelessWidget {
  const HaveAccountWidget({
    Key? key,
    required this.label,
    required this.labelAction,
    required this.onPressed,
    this.padding = const EdgeInsets.all(8.0), // Add default padding
    this.textColor = const Color.fromARGB(255, 245, 245, 245), // Add default text color
    this.buttonColor = const Color.fromARGB(255, 245, 245, 245), // Add default button color
  }) : super(key: key);

  final String label;
  final String labelAction;
  final Function() onPressed;
  final EdgeInsets padding;
  final Color textColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: textColor,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              labelAction,
              style: GoogleFonts.lato(
                color: buttonColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 100.0),
      closeIconColor: Color.fromARGB(255, 199, 149, 100),
      content: Text(content)));
}