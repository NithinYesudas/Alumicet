
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../utils/custom_colors.dart';

class MutualFollowersList extends StatelessWidget {
  MutualFollowersList({required this.selectedUserId, Key? key})
      : super(key: key);

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String selectedUserId;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      height: mediaQuery.height * .04,
      child: Selector<ProfileProvider,List<dynamic>>(
        selector: (_,myProfileProvider)=> myProfileProvider.getMutualFollowers,
          builder: (ctx, getMutualFollowers, snapshot) {
        if (getMutualFollowers.isEmpty) {
          return const SizedBox();
        }
        final data = getMutualFollowers;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .04),
          width: mediaQuery.width,
          child: Row(
            children: [
              Text(
                "Followed by: ",
                style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(data[0]["imageUrl"]),
                  ),
                  Text(data[0]["name"],
                      style:
                          GoogleFonts.nunitoSans(fontWeight: FontWeight.w700)),
                  data.length > 1
                      ? TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return SizedBox(
                                    height: mediaQuery.height * .5,
                                    child: ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (ctx, index) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  data[index]["imageUrl"]),
                                            ),
                                            title: Text(data[index]["name"],
                                                style: GoogleFonts.nunitoSans(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          );
                                        }),
                                  );
                                });
                          },
                          child: Text(
                            " and ${data.length} others",
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w700,
                                color: CustomColors.lightAccent),
                          ),
                        )
                      : const SizedBox()
                ],
              )
            ],
          ),
        );
      }),
    );
  }
  
}
