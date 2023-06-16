import 'package:alumni_connect/services/post_services.dart';
import 'package:alumni_connect/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class PostViewScreen extends StatefulWidget {
  const PostViewScreen({required this.post, super.key});

  final Map<String, dynamic> post;

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bioController.text = widget.post["caption"];
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.lightAccent,
        foregroundColor: Colors.white,
        title: Text(
          "Edit Post",
          style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mediaQuery.height * .03),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text(
                          "Delete Post",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          "Are you sure you want to delete this post?",
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w600),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              PostServices.deletePost(widget.post["userId"],
                                      widget.post["postId"])
                                  .then((value) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                              "Yes",
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "No",
                              style: GoogleFonts.nunitoSans(),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: mediaQuery.height * .65,
            child: Image.network(
              widget.post["imageUrl"],
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: mediaQuery.height * .03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .05),
            child: TextField(
              controller: _bioController,
              maxLines: null,
              style: GoogleFonts.nunitoSans(),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height * .02),
                  prefixIcon: Icon(
                    Ionicons.accessibility_outline,
                    color: CustomColors.lightAccent,
                  ),
                  hintText: "Edit Caption",
                  hintStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600, color: Colors.black38),
                  fillColor: Colors.black12,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none)),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * .03,
          ),
          ElevatedButton(
              onPressed: () async {
                PostServices.updatePost(
                  widget.post["userId"],
                  widget.post["postId"],
                  _bioController.text,
                ).then((value) => Navigator.of(context).pop());
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width * .1,
                      vertical: mediaQuery.height * .02),
                  backgroundColor: CustomColors.lightAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(
                "Update Post",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    fontSize: mediaQuery.height * .025),
              ))
        ],
      ),
    );
  }
}
