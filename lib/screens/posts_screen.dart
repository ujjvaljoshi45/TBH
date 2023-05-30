import 'package:flutter/material.dart';
import 'package:tobe_honest/screens/profile_screen.dart';

import 'add_post_screen.dart';

class PostsScreen extends StatelessWidget {
  static String postsScreenId = 'posts_screen';
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      ),
      body: const PostsList(),
    );
  }
}

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  List<PostTitle> postsList = [const PostTitle()];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return const PostTitle();
      },
      itemCount: postsList.length,
    );
  }
}

class PostTitle extends StatelessWidget {
  const PostTitle({Key? key}) : super(key: key);

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
          subtitle: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'the post containing some kind of a text will be present over here it is the most important part',
              style: TextStyle(
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
