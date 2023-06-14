import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../../utils/custom_colors.dart';
import 'profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = "";
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: TextField(
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              prefixIcon: Icon(
                Ionicons.search_outline,
                color: CustomColors.lightAccent,
              ),
              hintText: "Search for users",
              hintStyle: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600, color: Colors.black38),
              fillColor: Colors.black12,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none)),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: _searchText)
            .where('name', isLessThan: '${_searchText}z')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          documents = documents.where((doc) => doc.id != uid).toList();

          if (documents.isEmpty) {
            return Center(
              child: Text(
                "No users found",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w800, fontSize: 25),
              ),
            );
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = documents[index];
              final data = document.data() as Map<String, dynamic>;
              final String name = data['name'];
              final String imageUrl = data['imageUrl'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
                subtitle: Text(data['role'],style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600),),

                title: Text(name,style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700),),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => ProfileScreen(
                              userId: data['userId'],
                            )),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
