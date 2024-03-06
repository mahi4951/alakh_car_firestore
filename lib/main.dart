import 'dart:async';
import 'dart:io';
import 'package:alakh_car/screens/OTP_screen.dart';
import 'package:alakh_car/screens/admin/banner_screen.dart';
import 'package:alakh_car/screens/admin/brand_screen.dart';
import 'package:alakh_car/screens/admin/car_screen.dart';
import 'package:alakh_car/screens/admin/color_screen.dart';
import 'package:alakh_car/screens/admin/fuel_screen.dart';
import 'package:alakh_car/screens/admin/mela_owner_screen.dart';
import 'package:alakh_car/screens/admin/owner_screen.dart';
import 'package:alakh_car/screens/admin/social_screen.dart';
import 'package:alakh_car/screens/admin/sub_brand_filter_screen.dart';
import 'package:alakh_car/screens/admin/sub_brand_screen.dart';
import 'package:alakh_car/screens/home.dart';
import 'package:alakh_car/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// Make sure to import your CarProvider class

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await FirebaseAppCheck.instance.activate();

//   // await FirebaseAppCheck.instance.activate();

//   WidgetsFlutterBinding.ensureInitialized();
//   HttpOverrides.global = MyHttpOverrides();
//   runApp(const MyApp());
//   FlutterNativeSplash.remove();
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize App Check
  await FirebaseAppCheck.instance.activate();

  // Set custom HttpOverrides
  HttpOverrides.global = MyHttpOverrides();

  // Remove native splash screen
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key, // Add this line to declare key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Alakhcar",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromRGBO(15, 103, 180, 1),
      ),
      initialRoute: 'home',
      routes: {
        //'/': (context) => const SplashFuturePage(),

        // 'SplashScreen': (context) => SplashScreen(),
        '/home': (context) => OTPScreen(),
        '/': (context) => const Home(),
        '/color': (context) => ColorScreen(),
        '/brand': (context) => BrandScreen(),
        '/subbrand': (context) => SubBrandScreen(),
        '/fuel': (context) => FuelScreen(),
        '/owner': (context) => OwnerScreen(),
        '/car': (context) => CarScreen(),
        '/banner': (context) => BannerScreen(),
        '/login': (context) => const LoginPage(),
        '/subbrandfilter': (context) => SubBrandFilterScreen(),
        '/social': (context) => SocialScreen(),
        '/melaowner': (context) => MelaOwnerScreen(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
