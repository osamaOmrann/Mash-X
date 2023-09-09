import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              Text('ash',
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
                onPressed: () {},
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
}
