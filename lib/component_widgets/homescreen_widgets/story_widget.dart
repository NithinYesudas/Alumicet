import 'dart:io';
import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../provider/story_provider.dart';
import '../../screens/story_display_screen.dart';
import '../../services/story_services.dart';
import '../../utils/custom_colors.dart';

class StoryWidget extends StatefulWidget {
  const StoryWidget({Key? key}) : super(key: key);

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<StoryProvider>(context,listen: false).fetchStories();
    Provider.of<StoryProvider>(context,listen: false).getMyyStory();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
        height: mediaQuery.height * .13,
        child: Consumer<StoryProvider>(
          builder: (context, storyProvider, child) {
            return ListView.builder(
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                itemCount: storyProvider.getStories.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return storyProvider.myStory == null
                        ? SizedBox(
                            height: mediaQuery.height*.13,
                            width: mediaQuery.height*.13,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        XFile? image = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (image != null) {
                                          Uint8List bytes =
                                              await image.readAsBytes();
                                          StoryServices.uploadStory(
                                              bytes);

                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CustomColors.lightAccent,
                                          shape: const CircleBorder()),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                                 Text("Add Event",style: GoogleFonts.nunitoSans(
                                   fontWeight: FontWeight.bold
                                 ),)
                              ],
                            ),
                          )
                        : Container(
                      height: mediaQuery.height*.13,
                          width: mediaQuery.height*.13,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (ctx) => StoryDisplayScreen(
                                            userId: storyProvider.myStory!.userId,
                                            imageUrl: storyProvider.myStory!.imageUrl,
                                            name: "You")));
                                  },
                                  child: CircleAvatar(
                                    radius: mediaQuery.height*.04,
                                    backgroundColor: CustomColors.lightAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: CircleAvatar(
                                        radius: mediaQuery.height*.035,
                                        backgroundColor: Colors.white,

                                        backgroundImage:
                                            NetworkImage(storyProvider.myStory!.imageUrl),
                                      ),
                                    ),
                                  ),
                                ),
                                Text("You",style: GoogleFonts.nunitoSans(
                                   fontWeight: FontWeight.bold
                               )),

                            ],
                          ),
                        );
                  }
                  final story = storyProvider.getStories[index - 1];
                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(story.userId)
                          .get(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final userData = snapshot.data!.data();
                        return Container(
                          height: mediaQuery.height*.145,
                          width: mediaQuery.height*.145,
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => StoryDisplayScreen(
                                          userId: story.userId,
                                          imageUrl: story.imageUrl,
                                          name: userData["name"])));
                                },
                                child: CircleAvatar(
                                  radius: mediaQuery.height*.042,
                                  backgroundColor: CustomColors.lightAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: mediaQuery.height*.039,
                                      backgroundImage:
                                          NetworkImage(userData!["imageUrl"]),

                                    ),
                                  ),
                                ),
                              ),
                              Text(userData["name"],style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.bold
                              ))
                            ],
                          ),
                        );
                      });
                });
          },
        ));
  }
}
