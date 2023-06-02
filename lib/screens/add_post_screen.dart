import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/constants.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key, required this.user}) : super(key: key);
  User? user;
  String postString = '';
  String? postUser = '';

  Future<void> createNewPost() async {
    await Firebase.initializeApp();
    postUser = user?.displayName;
    await FirebaseFirestore.instance.collection('posts').add({
      'postUser': postUser,
      'postString': postString,
      'userUid': user?.uid,
      'timestamp': DateTime.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Add Post',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              autofocus: true,
              autocorrect: true,
              minLines: 3,
              maxLines: 5,
              style: const TextStyle(color: Colors.black),
              decoration: kInputDecoration,
              onChanged: (newPostString) => postString = newPostString,
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  createNewPost();
                  Navigator.pop(context);
                },
                child: const Text('Add'))
          ],
        ),
      ),
    );
  }
}
