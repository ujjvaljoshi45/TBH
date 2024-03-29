import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/profile_screen.dart';
import 'package:tobe_honest/screens/search_screen.dart';

import '../../widget/post_tile.dart';
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
        title: Row(
          children: [
            const Expanded(
              flex: 4,
              child: Text(
                textAlign: TextAlign.start,
                'ToBeHonest',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Expanded(flex: 4, child: SizedBox()),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchScreen.searchScreenId);
                },
                icon: const Icon(Icons.search_rounded),
              ),
            ),
          ],
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
                    arguments: [user?.uid, true]);
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