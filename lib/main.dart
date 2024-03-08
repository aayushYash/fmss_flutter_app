import 'package:flutter/material.dart';
import 'package:fundamentalscience/pages/dashboard.dart';
import 'package:fundamentalscience/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  Future<void> checkUser() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  }

  late  AnimationController animController;

  late Animation<double> anim;

  @override
  void initState(){
    super.initState();
    animController = AnimationController(vsync: this,duration: const Duration(seconds: 2))..forward()..repeat();
    anim = Tween(begin: 0.0, end: 2.0).animate(animController);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
              if (firebaseUser == null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              }
            });
          }
          return Center(child: CircularProgressIndicator(
            value: animController.value,
            semanticsLabel: 'Loading',
            color: Colors.black, 
          ));
        },
      ),
    );
  }
}
