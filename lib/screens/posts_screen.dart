import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/profile_screen.dart';

import 'add_post_screen.dart';

var firestore = FirebaseFirestore.instance;

class PostsScreen extends StatelessWidget {
  User? user;
  String? userDisplayName = '';
  static String postsScreenId = 'posts_screen';
  PostsScreen({super.key, this.user});
  void initFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;
    user = args;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true,
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: AddPostScreen(user: user),
                  ),
                );
              });
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 10.0,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          textAlign: TextAlign.start,
          'ToBeHonest',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 20,
        shadowColor: Colors.blueGrey[500],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.profileScreenId,
                    arguments: user?.uid);
              },
              icon: const Icon(
                Icons.person_rounded,
                size: 30.0,
              ),
            ),
          )
        ],
      ),
      body: const PostsStream(),
    );
  }
}

class PostsStream extends StatelessWidget {
  const PostsStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          List<PostTile> postTiles = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }
          final posts = snapshot.data!.docs;
          for (var post in posts) {
            final postText = post.get('postString');
            final postUser = post.get('postUser');
            final postUserUid = post.get('userUid');
            postTiles.add(PostTile(
              postUserName: postUser,
              postString: postText,
              postUserUid: postUserUid,
            ));
          }
          return ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: postTiles,
          );
        });
  }
}

class PostTile extends StatelessWidget {
  var postString = '';
  var postUserName = '';
  var postUserUid = '';
  PostTile(
      {super.key,
      required this.postString,
      required this.postUserName,
      required this.postUserUid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: ListTile(
          onLongPress: () {
            Navigator.pushNamed(context, ProfileScreen.profileScreenId,
                arguments: postUserUid);
          },
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: Text(
            postUserName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              postString,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
          isThreeLine: true,
          shape: const RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: Colors.blueGrey),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
