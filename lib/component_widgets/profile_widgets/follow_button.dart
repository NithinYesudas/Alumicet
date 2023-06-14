
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../screens/chat_screens/messages_screen.dart';
import '../../services/follow_services.dart';
import '../../utils/custom_colors.dart';

class FollowButton extends StatefulWidget {
  const FollowButton(
      {required this.userId, Key? key})
      : super(key: key);
  final String userId;


  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProfileProvider>(context, listen: false)
        .getIsFollowing(widget.userId, currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .05,
        width: MediaQuery.of(context).size.width * .9,
        child: Consumer<ProfileProvider>(builder: (context, data, child) {
          bool isFollowed = data.isFollowing;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: CustomColors.lightAccent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        )),
                    onPressed: () {
                      var result = FollowServices.followUnfollow(
                              isFollowed, widget.userId, context)
                          .whenComplete(() => null);
                      result.then((value) {
                        data.getIsFollowing(widget.userId, currentUserId);
                      });
                    },
                    child: Text(
                      isFollowed ? "DisConnect" : "Connect",
                      style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * .045,
                          color: Colors.white),
                    )),
              ),
              if (isFollowed) ...[
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MessagesScreen(selectedUser: data.getSelectedUser)));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.black12,
                      padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: MediaQuery.of(context).size.width * .1)),
                  child: Text(
                    "Message",
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * .045,
                    ),
                  ),
                )
              ]
            ],
          );
        }));
  }
}
