import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/login_screen.dart';
import 'package:tobe_honest/screens/profile_screen.dart';

import 'add_post_screen.dart';

var firestore = FirebaseFirestore.instance;

class PostsScreen extends StatelessWidget {
  static String postsScreenId = 'posts_screen';
  const PostsScreen({Key? key}) : super(key: key);
  void initFirebase() async {
    await Firebase.initializeApp();
    print('App Init');
  }

  @override
  Widget build(BuildContext context) {
    initFirebase();
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
                    child: const AddPostScreen(),
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
              onPressed: () {},
              icon: const Icon(
                Icons.search_rounded,
                size: 30.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.profileScreenId);
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

  Future<void> getPostUser(postUserUid) async {
    print('Getting User');
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot snapshot =
        await usersCollection.doc(postUserUid).get();

    if (snapshot.exists) {
      print('Snapshot exists');
      final Map<String, dynamic>? userData =
          snapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        // Access individual fields
        final String name = userData['name'] ?? '';
        final String email = userData['email'] ?? '';

        // Do something with the user data
        print('Name: $name');
        print('Email: $email');
      }
    } else {
      print('Not Exists');
    }
  }

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
            final postUserUid = post.get('uid');
            getPostUser(postUserUid);
            postTiles.add(PostTile(
              postString: postText,
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

// class PostsList extends StatefulWidget {
//   const PostsList({Key? key}) : super(key: key);
//
//   @override
//   State<PostsList> createState() => _PostsListState();
// }
//
// class _PostsListState extends State<PostsList> {
//   List<PostTile> postsList = [const PostTile()];
//   void getDataFromFirestore() async {
//     print('Function Called');
//     await Firebase.initializeApp();
//     print('FIREBASE INITIALIZED');
//     var posts = await firestore.collection('posts').get();
//     print('POSTS GOT');
//     for (var post in posts.docs) {
//       print('Post: $post');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getDataFromFirestore();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return const PostTile();
//       },
//       itemCount: postsList.length,
//     );
//   }
// }

class PostTile extends StatelessWidget {
  var postString = '';

  PostTile({required this.postString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: ListTile(
          onLongPress: () {
            Navigator.pushNamed(context, ProfileScreen.profileScreenId);
          },
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Username',
            style: TextStyle(fontWeight: FontWeight.bold),
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
