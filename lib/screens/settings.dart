import 'package:flutter/material.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return Scaffold(
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
