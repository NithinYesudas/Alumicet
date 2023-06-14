
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';
import '../../provider/profile_provider.dart';

class ProfileHeadSection extends StatefulWidget {
  const ProfileHeadSection({required this.userId, Key? key}) : super(key: key);
  final String userId;

  @override
  State<ProfileHeadSection> createState() => _ProfileHeadSectionState();
}

class _ProfileHeadSectionState extends State<ProfileHeadSection> {
  @override
  void initState() {
    Provider.of<ProfileProvider>(context,listen: false).fetchUserDetails(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Selector<ProfileProvider,UserProfile?>(
      selector: (_,myProfileProvider)=>myProfileProvider.getSelectedUser,
        builder: (context, getSelectedUser, child) {
      final selectedUser = getSelectedUser;
      if(selectedUser==null){
        return const SizedBox();
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: mediaQuery.height * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(selectedUser.imageUrl),
                        radius: mediaQuery.width * .09,
                      ),
                  Text(
                    "Jobs\n   ${selectedUser.postCount}",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w700,
                        fontSize: mediaQuery.width * .04),
                  ),
                  Text(
                    "Connections\n     ${selectedUser.followingCount}",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w700,
                        fontSize: mediaQuery.width * .04),
                  ),
                  Text(
                    "Followers\n      ${selectedUser.followersCount}",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w700,
                        fontSize: mediaQuery.width * .04),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              selectedUser.name,
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: mediaQuery.width * .05),
            ),
            Text(
              selectedUser.bio,
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: mediaQuery.width * .04),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}
