import 'package:flutter/material.dart';
import 'package:tobe_honest/constants.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            const TextField(
              autofocus: true,
              autocorrect: true,
              minLines: 3,
              maxLines: 5,
              style: TextStyle(color: Colors.black),
              decoration: kInputDecoration,
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Add'))
          ],
        ),
      ),
    );
  }
}
