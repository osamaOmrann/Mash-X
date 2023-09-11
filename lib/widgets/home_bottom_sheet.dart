import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/screens/profile_screen.dart';
import 'package:mash/screens/settings.dart';
import 'package:provider/provider.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    final sp = context.watch<SignInProvider>();
    return Container(
      height: height * .685,
      padding: EdgeInsets.only(
        left: width * .039,
        right: width * .039,
        top: height * .021
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: width * .03,),
              GestureDetector(
                onTap: () {nextScreen(context, ProfileScreen());},
                child: CircleAvatar(
                  backgroundImage: NetworkImage(sp.imageUrl ?? ''),
                  radius: width * .061,
                ),
              ),
              SizedBox(height: width * 0.09, width: width *.05,),
              Container(
                height: width * 0.09,
                width: width * .003,
                color: Colors.black,
              ),
              SizedBox(height: width * 0.09),
              SizedBox(width: width * .065,),
              Image.asset('assets/images/cs.png', width: width * .081,),
              SizedBox(width: width * .065,),
              Image.asset('assets/images/bag.png', width: width * .081,),
              SizedBox(width: width * .061,),
              GestureDetector(
                onTap: () {nextScreen(context, Settings());},
                  child: Icon(Icons.settings, color: Color(0xff3392ee), size: width * .09,)),
              SizedBox(width: width * .06,),
              Image.asset('assets/images/telegram.png', width: width * .081,),
              Spacer(),
              GestureDetector(
                onTap: () {Navigator.pop(context);},
                  child: Icon(CupertinoIcons.chevron_down, color: Color(0xff96a8f1),))
            ],
          )
        ],
      ),
    );
  }
}
