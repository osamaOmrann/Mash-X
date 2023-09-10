import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}