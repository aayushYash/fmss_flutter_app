import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Textfield extends StatelessWidget {
  final controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final bool multiline;

  const Textfield(
      {super.key,
      required this.controller,
      required this.icon,
      required this.hintText,
      required this.obscureText,
      required this.multiline,
      });

  @override
  Widget build(context) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width - 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          
          obscureText: obscureText,
          controller: controller,
          keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
          maxLines: multiline ? 10: 1,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              fillColor: Colors.grey.shade100,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade500)),
              hintText: hintText,
              hintStyle: GoogleFonts.robotoSlab(
                  textStyle: TextStyle(color: Colors.grey.shade500)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              filled: true,
              icon: Icon(
                icon,
                color: Colors.grey.shade500,
              )),
        ),
      ),
    );
  }
}
