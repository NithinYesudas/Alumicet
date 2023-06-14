import 'dart:io';
import 'dart:typed_data';


import 'package:alumni_connect/screens/home_tab_screens/rating_screen.dart';
import 'package:alumni_connect/screens/post_edit_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import '../utils/accessory_widgets.dart';
import '../utils/custom_colors.dart';
import 'home_tab_screens/home_screen.dart';
import 'home_tab_screens/profile_screen.dart';
import 'home_tab_screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  List<Widget> screen = [
    const HomeScreen(),
    const SearchScreen(),
    const SizedBox(),
    ProfileScreen(
      userId: FirebaseAuth.instance.currentUser!.uid,
    ),
    const CollegeScreen()
  ];

  int index = 0;
  XFile? image;
  Uint8List? imageInBytes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index],
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        selectedIconTheme: IconThemeData(color: CustomColors.lightAccent),
        elevation: 10,
        currentIndex: index,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        type: BottomNavigationBarType.shifting,
        onTap: (val) {
          setState(() => index = val);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                index == 0 ? Ionicons.home_sharp : Ionicons.home_outline,
              ),
              label: " "),
          BottomNavigationBarItem(
              icon: Icon(
                index == 1 ? Ionicons.search_sharp : Ionicons.search_outline,
              ),
              label: " "),
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () async {
                    try {
                      image = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 40);
                      if (image != null) {
                        imageInBytes = await image!.readAsBytes();
                        newPage();
                      }
                    } catch (e) {
                      AccessoryWidgets.snackBar("An error occurred", context);
                    }
                  },
                  icon: const Icon(
                    Ionicons.add_circle_outline,
                    size: 30,
                  )),
              label: " "),
          const BottomNavigationBarItem(
              icon: Icon(Ionicons.person_circle_outline), label: " "),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.star_border,
              ),
              label: " ")
        ],
      ),
    );
  }

  void newPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => PostEditScreen(image: imageInBytes!)));
  }
}
