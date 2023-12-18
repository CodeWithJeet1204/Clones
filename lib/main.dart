import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/search_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDcqXTQPqTS2Nh_xsMv5u4Dbv7e7NBvkFI',
        appId: "1:1082239166770:android:239858feab2cc75c784f2b",
        messagingSenderId: "1082239166770",
        projectId: "instagram-1204",
        storageBucket: "instagram-1204.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Jeetgram',
        theme: ThemeData.dark(
          useMaterial3: true,
        ).copyWith(
          colorScheme: const ColorScheme.dark(),
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/responsive': (context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              ),
          '/search': (context) => const SearchScreen(),
        },
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Some error occured\nClose & Open the app again"),
                );
              } else {
                return const LoginScreen();
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else {
              return const SignUpScreen();
            }
          }),
        ),
      ),
    );
  }
}


// 3 methods for stream
// 1. FirebaseAuth.instance.idTokenChanges() - runs every time user sign in or sign out
// 2. FirebaseAuth.instance.userChanges() - > same as idTokenChanges, but also gets called when user changes email/password
// 3. FirebaseAuth.instance.authStateChanges() -> Gets called only when user sign in/sign out