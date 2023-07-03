import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

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
                arguments: [postUserUid, false]);
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
          trailing: IconButton(
            icon:
                const Icon(Icons.info_outline_rounded, color: Colors.blueGrey),
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.profileScreenId,
                  arguments: [postUserUid, false]);
            },
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
