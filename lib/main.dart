import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/all_bindings.dart';

import 'package:note_app/globles/pallets.dart';
import 'package:note_app/screens/home_page.dart';
import 'package:note_app/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IdeaVault',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(snapshot.data);
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data == null) {
                        return LoginPage();
                      } else {
                        return HomePage();
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            );
          default:
            return MaterialPageRoute(builder: (context) => LoginPage());
        }
      },
      debugShowCheckedModeBanner: false,
      initialBinding: AllBindings(),
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
    );
  }
}
