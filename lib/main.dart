import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/item_list_provider.dart';
import 'package:flutter_application_1/provider/profile_list_provider.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/login/login_screen.dart';
import 'package:flutter_application_1/screens/login/signup.dart';
import 'package:flutter_application_1/screens/profile_regist.dart';
import 'package:flutter_application_1/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:643967719377:android:0eef4f41f3e5047b65b2f0",
        databaseURL: "https://test-app-854cc-default-rtdb.asia-southeast1.firebasedatabase.app/",
        messagingSenderId: "643967719377",
        projectId: "test-app-854cc",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ItemListProvider()),
        ChangeNotifierProvider(create: (context)=> ProfileProvider())
        // Lainnya provider yang mungkin Anda tambahkan
      ], // Inisialisasi provider Anda
    child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home' : (context) =>  HomePage(),
        '/registProfile': (context) => RegistrationPage(),
      },
    );
  }
}