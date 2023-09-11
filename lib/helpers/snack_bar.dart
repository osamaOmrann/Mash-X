import 'package:flutter/material.dart';

void openSnackBar(context, msg, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,), backgroundColor: color,));
}