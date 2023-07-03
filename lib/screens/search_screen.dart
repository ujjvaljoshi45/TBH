import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tobe_honest/widget/post_tile.dart';

class SearchScreen extends StatefulWidget {
  static String searchScreenId = 'search_screen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchString = '';
  TextEditingController search = TextEditingController();
  Future<void> initFirebase() async {
    await Firebase.initializeApp();
  }

  List<PostTile> postTiles = [];

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  void updateList(Stream<QuerySnapshot> snapshot) async {
    snapshot.forEach((element) {
      var posts = element.docs;
      for (var post in posts) {
        postTiles.add(PostTile(
            postString: post.get('postString'),
            postUserName: post.get('postUser'),
            postUserUid: post.get('userUid')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late Stream<QuerySnapshot> postsStream = FirebaseFirestore.instance
        .collection('posts')
        .where('postUser', isEqualTo: search.text)
        .snapshots();

    updateList(postsStream);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autocorrect: false,
          controller: search,
          style: const TextStyle(color: Colors.black),
          onChanged: (newSearchString) {
            setState(() {
              postTiles.removeRange(0, postTiles.length);
            });
          },
          cursorColor: Colors.grey,
          decoration: const InputDecoration(
            hintText: 'search...',
            filled: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: postsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Woops!Something Went Wrong.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView(
              children: postTiles,
            ),
          );
        },
      )),
    );
  }
}
