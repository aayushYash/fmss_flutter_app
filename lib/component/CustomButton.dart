import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtom extends StatelessWidget {

  void Function()? onTap;
  String text;

  CustomButtom({
    super.key,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Text(
              text,
              style: GoogleFonts.robotoSlab(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
      ),
    );
  }
}
