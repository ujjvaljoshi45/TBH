import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tobe_honest/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String profileScreenId = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late String userUid;
  late String userDocId;
  late bool isCurrentUser;
  late String userDisplayName = '';
  late String userPhotoURL =
      'https://firebasestorage.googleapis.com/v0/b/tobehonest-be7ed.appspot.com/o/files%2Fuser.png?alt=media&token=c0da5735-3120-4a9b-8c2f-b511b8c9887e';
  bool gotDisplayName = false;
  final ImagePicker _imagePicker = ImagePicker();
  File? _photo;

  Future<void> getUser(String uid) async {
    await Firebase.initializeApp();
    var docRef = await FirebaseFirestore.instance.collection('myusers').get();
    for (var doc in docRef.docs) {
      if (doc.get('uid') == uid) {
        setState(() {
          userDocId = doc.id;
          userDisplayName = doc.get('displayName');
          userPhotoURL = doc.get('photoURL');
          if (userPhotoURL.isEmpty) {
            userPhotoURL =
                'https://firebasestorage.googleapis.com/v0/b/tobehonest-be7ed.appspot.com/o/files%2Fuser.png?alt=media&token=c0da5735-3120-4a9b-8c2f-b511b8c9887e';
          }
          gotDisplayName = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!gotDisplayName) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      userUid = args[0];
      isCurrentUser = args[1];
      getUser(userUid);
    }
    return Scaffold(
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
          Visibility(
            visible: isCurrentUser,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(
                      context, ModalRoute.withName(HomeScreen.homeScreenId));
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30.0,
                ),
              ),
            ),
          )
        ],
      ),
      body: Visibility(
        visible: gotDisplayName,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    if (isCurrentUser) {
                      final xFile = await _imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (xFile?.path != null) {
                        uploadFile(xFile, context);
                        setState(() {
                          _photo = File(xFile!.path);
                        });
                      }
                    }
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        minRadius: 105.0,
                        maxRadius: 105.0,
                        backgroundColor: Colors.blueGrey,
                        child: CircleAvatar(
                          maxRadius: 100.0,
                          minRadius: 100.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(userPhotoURL),
                        ),
                      ),
                      Visibility(
                        visible: isCurrentUser,
                        child: IconButton(
                            onPressed: () async {
                              if (isCurrentUser) {
                                final xFile = await _imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                if (xFile?.path != null) {
                                  uploadFile(xFile, context);
                                  setState(() {
                                    _photo = File(xFile!.path);
                                  });
                                }
                              }
                            },
                            icon: const Padding(
                              padding:
                                  EdgeInsets.only(left: 10.0, bottom: 10.0),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.blueGrey,
                                size: 28.0,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userDisplayName,
                  style: const TextStyle(
                      fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future uploadFile(XFile? xFile, BuildContext context) async {
    if (xFile != null) {
      final destination = 'files/$userUid';
      try {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('file/');
        await ref.putFile(File(xFile.path));
        String photoURL = await ref.getDownloadURL();
        var collection = FirebaseFirestore.instance
            .collection('myusers')
            .doc(userDocId)
            .update({'photoURL': photoURL})
            .then((_) => debugPrint('Success'))
            .catchError((error) => debugPrint(error));
        setState(() {
          userPhotoURL = photoURL;
        });
        return;
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: Container(
                      height: 100.0,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Error Occured, Please Try Again',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go Back'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }
}
