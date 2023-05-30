import 'package:flutter/material.dart';

const InputDecoration kInputDecoration = InputDecoration(
  filled: true,
  focusColor: Colors.black,
  fillColor: Colors.white,
  hintStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
  border: UnderlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
);
