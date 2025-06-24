import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {super.key,
      required this.label,
      required this.height,
      required this.width,
      required this.onTap,
      required this.assetImage});

  final String label;
  final double height;
  final double width;
  final Function() onTap;
  final String assetImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 33, 33, 33),
                  image: DecorationImage(image: AssetImage(assetImage)))),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 232, 232, 232),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
