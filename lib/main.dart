import 'package:alumni_connect/provider/post_provider.dart';
import 'package:alumni_connect/provider/profile_provider.dart';
import 'package:alumni_connect/provider/story_provider.dart';
import 'package:alumni_connect/screens/auth/auth_pages.dart';
import 'package:alumni_connect/screens/auth/login_screen.dart';
import 'package:alumni_connect/screens/auth/signup_screen.dart';
import 'package:alumni_connect/screens/auth/user_data_collection_screen.dart';
import 'package:alumni_connect/screens/chat_screens/chat_list_screen.dart';
import 'package:alumni_connect/screens/home_tab_screens/home_screen.dart';
import 'package:alumni_connect/screens/main_screen.dart';
import 'package:alumni_connect/screens/splashScreen.dart';
import 'package:alumni_connect/utils/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAEYE7Xko9v4w0CSnROJzv3e6ULwtn2ETk",
          appId: "1:57060374969:web:5a62897f22c157787d1e68",

          messagingSenderId: "57060374969",
          storageBucket: "buddies-e2a97.appspot.com",
          projectId: "buddies-e2a97"));
  runApp(const BuddiesApp());
}

class BuddiesApp extends StatelessWidget {
  const BuddiesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(create: (ctx) => PostProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (ctx) => ProfileProvider()),
        ChangeNotifierProvider<StoryProvider>(create: (ctx) => StoryProvider())
      ],
      child: MaterialApp(
        routes: {
          "SignUpScreen": (ctx) => const SignUpScreen(),
          "LoginScreen": (ctx) => const LoginScreen(),
          "HomeScreen": (ctx) => const HomeScreen(),
          "MainScreen": (ctx) => const MainScreen(),
          "ChatScreen": (ctx) => ChatScreen()
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            primaryColor: CustomColors.darkPrimary,
            hintColor: CustomColors.darkAccent),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              } else if (snapshot.hasData) {
                return const MainScreen();
              } else {
                return const AuthPages();
              }
            }),
      ),
    );
  }
}
