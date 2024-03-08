import 'package:flutter/material.dart';
import 'package:fundamentalscience/component/CustomButton.dart';
import 'package:fundamentalscience/component/TextField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void signIn() async{
    FocusManager.instance.primaryFocus?.unfocus();
    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username.text, password: password.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(credential.user!.uid.toString()),));
    }
    on FirebaseAuthException catch (e){
      if(e.code == "user-not-found"){
        print('Wrong email id');
        const snack = SnackBar(content: Text('Wrong Email Id'));
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
      if(e.code == "wrong-password"){
        print('wrong password');
        const snackPassword = SnackBar(content: Text('Wrong Password'));
        ScaffoldMessenger.of(context).showSnackBar(snackPassword);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon of lock

              const SizedBox(height: 40),
              const Icon(Icons.lock, size: 80),
              const SizedBox(
                height: 25,
              ),

              // Login Text
              Text(
                "Admin Login",
                style: GoogleFonts.robotoSlab(
                    textStyle: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Sign In to admin panel',
                  style: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(color: Colors.grey.shade600))),
              const SizedBox(
                height: 40,
              ),

              // textfield for username   
              Textfield(
                  controller: username,
                  icon: Icons.person,
                  hintText: "Username",
                  obscureText: false,
                  multiline: false,),
              const SizedBox(
                height: 10,
              ),
              Textfield(
                  controller: password,
                  icon: Icons.password,
                  hintText: "Password",
                  obscureText: true,
                  multiline: false,),
              const SizedBox(height: 20,),
              CustomButtom(text: 'Sign In',onTap: signIn,),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: GestureDetector(
                      child: Text("Fortgot Password?", style: GoogleFonts.robotoSlab(color: Colors.grey.shade500),)
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
