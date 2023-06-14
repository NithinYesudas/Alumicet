import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class StoryDisplayScreen extends StatefulWidget {
  const StoryDisplayScreen({required this.imageUrl,required this.name,required this.userId,Key? key}) : super(key: key);
final String imageUrl,name,userId;

  @override
  State<StoryDisplayScreen> createState() => _StoryDisplayScreenState();
}

class _StoryDisplayScreenState extends State<StoryDisplayScreen> {
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),actions: [
        if(currentUid==widget.userId)IconButton(onPressed: ()async{
          print(widget.userId);

         final result = await FirebaseFirestore.instance.collection("stories").doc(widget.userId).delete();

          nextPage();

        }, icon: const Icon(Icons.delete))
      ],),
      body: SizedBox(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
      child: Image.network(widget.imageUrl,fit: BoxFit.cover,),),
    );
  }

  void nextPage(){
    Navigator.of(context).pop();
  }
}
