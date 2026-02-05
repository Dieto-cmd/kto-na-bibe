import 'package:flutter/material.dart';

InputDecoration textFormFieldDec = InputDecoration(
  fillColor: Colors.grey[700],
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[700] ?? Colors.grey, width: 2.0),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
    borderRadius: BorderRadius.circular(25),
  ),
);

TextStyle hintTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.grey[200],
);

TextStyle regularTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
