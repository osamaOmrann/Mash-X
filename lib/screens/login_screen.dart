import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mash/data_base/internet_provider.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
  RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: height * .07,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'M',
                style: TextStyle(
                    fontSize: width * .15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6850a4)),
              ),
              Text('ashX',
                  style: TextStyle(
                      fontSize: width * .07, color: Color(0xff6850a4)))
            ],
          ),
          SizedBox(
            height: height * .53,
          ),
          Text('Or login with'),
          SizedBox(
            height: height * .023,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedLoadingButton(
                controller: googleController,
                onPressed: handleGoogleSignIn,
                child: Icon(FontAwesomeIcons.google),
                successColor: Color(0xff6850a4),
                color: Color(0xff6850a4),
                width: width * .13,
                borderRadius: width * .05,
              ),
              RoundedLoadingButton(
                controller: phoneController,
                onPressed: () {},
                child: Icon(FontAwesomeIcons.phone),
                successColor: Color(0xff6850a4),
                color: Color(0xff6850a4),
                width: width * .13,
                borderRadius: width * .05,
              ),
            ],
          ),
          SizedBox(height: height * .03,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have account?'),
              TextButton(onPressed: () {}, child: Text('Sign up', style: TextStyle(color: Color(0xff6850a4)),))
            ],
          )
        ],
      ),
    );
  }

  //Handling Google Sign In
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if(ip.hasInternet ==  false) {
      openSnackBar(context, 'Check your internet connection', Color(0xff6850a4));
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if(sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Color(0xff6850a4));
          googleController.reset();
        } else {
          //Checking User Existence

        }
      });
    }
  }
}
