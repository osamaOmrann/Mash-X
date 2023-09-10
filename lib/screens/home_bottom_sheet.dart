import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/screens/profile_screen.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: height * .7,
      child: IconButton(
        onPressed: () => nextScreen(context, ProfileScreen()),
        icon: Icon(CupertinoIcons.person_alt, size: 55,),
      ),
    );
  }
}
