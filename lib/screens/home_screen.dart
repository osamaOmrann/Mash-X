import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/screens/home_bottom_sheet.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: height * .11,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Mash', style: TextStyle(color: Color(0xff98a6f3), fontSize: width * .061, fontFamily: 'backHome', fontWeight: FontWeight.bold),),
                  Text(' X', style: TextStyle(fontSize: width * .0661, color: Colors.red),),
                  Spacer(),
                  IconButton(onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                        context: context, builder: (_) => HomeBottomSheet());
                  }, icon: Icon(Icons.menu, color: Color(0xff98a6f3), size: width * .09,))
                ],
              ),
            ),
          ),
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                sp.imageUrl ?? ''
              ),
              radius: 50,
            ),
          ),
          Center(
            child: Text(
              'From ${sp.provider}'
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sp.userSignOut();
          nextScreenReplace(context, LoginScreen());
        },
        child: Text('Log out', style: TextStyle(fontSize: 9),),
      ),
    );
  }
}
