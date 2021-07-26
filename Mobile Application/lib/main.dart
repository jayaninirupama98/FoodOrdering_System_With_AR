import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:resturent_app/uis/mainScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final Color primarySwatch = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: ThemeData(
              primarySwatch: primarySwatch,
            ),
            home: Scaffold(
              body: Center(
                child: Text('There was an error initializing firebase'),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: ThemeData(
              primarySwatch: primarySwatch,
            ),
            home: MainScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'Restaurant App',
          theme: ThemeData(
            primarySwatch: primarySwatch,
          ),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
