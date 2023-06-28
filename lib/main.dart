import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/splash.dart';

void main() async {
  // inisialisai firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      // Set navigatorkey in main method
      navigatorKey: GlobalContextService.navigatorKey,
      title: 'Mobile Programming',
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

/* https://stackoverflow.com/questions/68695028/error-undefined-name-context-in-flutter
GlobalcontextService*/

class GlobalContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
