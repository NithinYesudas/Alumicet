import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../../services/auth_services.dart';
import '../../utils/accessory_widgets.dart';
import '../../utils/custom_colors.dart';

class UserDataCollection extends StatefulWidget {
  const UserDataCollection({Key? key}) : super(key: key);

  @override
  State<UserDataCollection> createState() => _UserDataCollectionState();
}

class _UserDataCollectionState extends State<UserDataCollection> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passOutYearController =
      TextEditingController();
  bool isLoading = false;
  Uint8List? image;
  XFile? file;
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  ImageProvider get imageProvider {
    if (image == null) {
      return const AssetImage("assets/images/avatar.png");
    } else {
      try{
        return MemoryImage(image!);
      }
      catch(error){
        AccessoryWidgets.snackBar(error.toString(), context);
        return const AssetImage("assets/images/avatar.png");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: mediaQuery.height * .025,
              ),
              SizedBox(
                height: mediaQuery.height * .25,
                width: mediaQuery.width * .7,
                child: Image.asset(
                  "assets/images/userdetails.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: mediaQuery.height * .05,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: mediaQuery.width * .02,
                    right: mediaQuery.width * .45),
                child: Text("Almost there.!",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * .06)),
              ),
              Text(
                "Let's add a few details about you to get started.!",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    color: CustomColors.darkAccent),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              Center(
                child: CircleAvatar(
                    radius: mediaQuery.width * .1,
                    backgroundImage: imageProvider),
              ),
              TextButton(
                  onPressed: () async {
                    try {
                       file = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        var f = await file!.readAsBytes();

                        setState(()  {
                          image = f;
                        });
                      }
                    } catch (error) {
                      AccessoryWidgets.snackBar(error.toString(), context);
                    }
                  },
                  child: Text(
                    "Add Photo",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * .04,
                        color: CustomColors.darkAccent),
                  )),
              SizedBox(
                height: mediaQuery.height * .01,
              ),
              Form(
                  key: _key,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05),
                    height: mediaQuery.height * .4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 2 || value.contains(RegExp(r'[0-9]'))) {
                              return "Invalid name";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.person_outline,
                                color: CustomColors.lightAccent,
                              ),
                              hintText: "Name",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        TextFormField(
                          controller: _bioController,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return "Please Enter a valid bio";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.accessibility_outline,
                                color: CustomColors.lightAccent,
                              ),
                              hintText: "Bio",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        TextFormField(
                          controller: _passOutYearController,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return "Please Enter a valid bio";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.calendar_outline,
                                color: CustomColors.lightAccent,
                              ),
                              hintText: "Year of Passing Out",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Colors.black12,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),

                        ElevatedButton(
                            onPressed: () async {
                              bool isValid = _key.currentState!.validate();
                              if (isValid) {
                                setState(() {
                                  isLoading = true;
                                });

                                bool isSuccessful =
                                    await AuthServices.uploadDetails(
                                        image!,
                                        _nameController.text.toLowerCase(),
                                        _bioController.text,
                                        _passOutYearController.text,
                                        context);
                                isLoading = false;
                                if (isSuccessful) {
                                  nextPage();
                                } else {
                                  setState(() {});
                                }
                              }
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width * .11,
                                        vertical: mediaQuery.height * .015)),
                                backgroundColor: MaterialStateProperty.all(
                                    CustomColors.darkAccent)),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Create Account",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: mediaQuery.width * .04),
                                  ))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void nextPage() {
    Navigator.of(context).pushReplacementNamed("MainScreen");
  }
}
