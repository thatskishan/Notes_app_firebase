import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 2,
            child: Image.asset("assets/images/notes.png"),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            "Tasker",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          )
        ],
      ),
    );
  }
}
