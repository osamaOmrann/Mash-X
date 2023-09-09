import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/screens/home_screen.dart';
import 'package:mash/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    Timer(Duration(seconds: 2), () {
      sp.isSignedIn == false
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          LoadingAnimationWidget.staggeredDotsWave(
            color: Color(0xff6850a4),
            size: width * .25,
          ),
          Text(
            'Mash',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Color(0xff6850a4)),
          )
        ],
      ),
    );
  }
}
