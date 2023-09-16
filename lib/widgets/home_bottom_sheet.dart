import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/screens/profile_screen.dart';
import 'package:mash/screens/profile_screen.dart';
import 'package:mash/screens/settings.dart';
import 'package:mash/screens/store_screen.dart';
import 'package:mash/widgets/job_offer_widget.dart';
import 'package:provider/provider.dart';

class HomeBottomSheet extends StatelessWidget {
  String userImage;
  HomeBottomSheet(this.userImage);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: width * .03,),
              GestureDetector(
                onTap: () {nextScreen(context, UserProfilePage(DataBase.user.uid));},
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(userImage),
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
              GestureDetector(
                onTap: () {nextScreen(context, StoreScreen());},
                  child: Image.asset('assets/images/bag.png', width: width * .081,)),
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
          ),
            SizedBox(height: height * .045,),
            Text('    Wählen Sie Lhre Stadt'),
          SizedBox(height: height * .01,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * .05, vertical: height * .01),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(width * .07)
            ),
            child: Row(
              children: [
                Image.asset('assets/images/location.png', width: width * .065,),
                Text('Adresse', style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
          SizedBox(height: height * .045,),
          Text('Menü:', style: TextStyle(fontSize: width * .055),),
          SizedBox(height: height * .019,),
          Expanded(child: ListView.builder(
            physics: BouncingScrollPhysics(),
              itemCount: 21,
              itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: height * .03),
              child: JobOfferWidget(),
            );
          }))
        ],
      ),
    );
  }
}
