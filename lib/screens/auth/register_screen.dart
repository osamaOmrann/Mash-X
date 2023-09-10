import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mash/data_base/internet_provider.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/helpers/snack_bar.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:mash/screens/auth/phone_auth_screen.dart';
import 'package:mash/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                onPressed: () {
                  nextScreenReplace(context, PhoneAuthScreen());
                  phoneController.reset();
                },
                child: Icon(FontAwesomeIcons.phone),
                successColor: Color(0xff6850a4),
                color: Color(0xff6850a4),
                width: width * .13,
                borderRadius: width * .05,
              ),
            ],
          ),
          SizedBox(
            height: height * .03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?'),
              TextButton(
                  onPressed: () {
                    nextScreenReplace(context, LoginScreen());
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Color(0xff6850a4)),
                  ))
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
    if (ip.hasInternet == false) {
      openSnackBar(
          context, 'Check your internet connection', Color(0xff6850a4));
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Color(0xff6850a4));
          googleController.reset();
        } else {
          //Checking User Existence
          sp.checkUserExists().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSigningIn();
                      })));
            } else {
              sp.saveDataToFireStore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSigningIn();
                      })));
            }
          });
        }
      });
    }
  }

  handleAfterSigningIn() {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, HomeScreen());
    });
  }
}
