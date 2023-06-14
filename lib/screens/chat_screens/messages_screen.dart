
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../component_widgets/chat_widgets/messages_list.dart';
import '../../models/user_model.dart';
import '../../services/chat_services.dart';
import '../../utils/custom_colors.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({required this.selectedUser, Key? key}) : super(key: key);
  final UserProfile? selectedUser;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedUserId = selectedUser!.userId;
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: CustomColors.lightAccent,
        leading: Padding(
          padding: EdgeInsets.only(
              left: mediaQuery.width * .03,
              top: mediaQuery.width * .02,
              bottom: mediaQuery.width * .02),
          child: CircleAvatar(
            backgroundImage: NetworkImage(selectedUser!.imageUrl),
          ),
        ),
        title: Text(
          selectedUser!.name,
          style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: MessagesList(
            selectedUserId: selectedUserId,
          )),
          Container(
            height: mediaQuery.height * .1,
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .01),
            child: Row(
              children: [
                SizedBox(
                  width: mediaQuery.width*.8,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Ionicons.lock_closed_outline,color: CustomColors.lightAccent,),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 5),
                        hintText: "Message",
                        hintStyle: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600, color: Colors.black38),
                        fillColor: Colors.black12,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(left:20,right: 15,bottom: 15,top: 15),
                    backgroundColor: CustomColors.lightAccent,
                    shape: const CircleBorder()
                  ),
                    onPressed: () {
                    ChatServices.sendMessage(_controller.text, selectedUserId);
                    _controller.clear();
                    }, child: const Icon(Ionicons.send_sharp,color: Colors.white,))
              ],
            ),
          )
        ],
      ),
    );
  }
}
