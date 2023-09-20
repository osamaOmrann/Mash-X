import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mash/helpers/internet_provider.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/helpers/snack_bar.dart';
import 'package:mash/helpers/validation_utils.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/phone_auth_screen.dart';
import 'package:mash/screens/auth/register_screen.dart';
import 'package:mash/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController loginController =
      RoundedLoadingButtonController();
  bool securePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .07),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height * .1,
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
                  height: height * .1,
                ),
                Text('Login'),
                SizedBox(
                  height: height * .041,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter e-mail address';
                    }
                    if (!ValidationUtils.isValidEmail(text)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: basicColor,
                    ),
                    labelStyle: TextStyle(color: basicColor),
                    focusColor: basicColor,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: basicColor),
                        borderRadius: BorderRadius.circular(width * .061)),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(width * .061)),
                  ),
                ),
                SizedBox(
                  height: height * .03,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  obscureText: securePassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password, color: basicColor),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            securePassword = !securePassword;
                            setState(() {});
                          },
                          child: Icon(
                            securePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: securePassword ? Colors.grey : basicColor,
                          )),
                      labelStyle: TextStyle(color: basicColor),
                      focusColor: basicColor,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: basicColor),
                          borderRadius: BorderRadius.circular(width * .061)),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(width * .061))),
                ),
                SizedBox(
                  height: height * .07,
                ),
                RoundedLoadingButton(
                    successColor: basicColor,
                    color: basicColor,
                    borderRadius: width * .05,
                    controller: loginController,
                    onPressed: () => emailPasswordLogin(),
                    child: Text('Login')),
                SizedBox(height: height * .03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have account?'),
                    TextButton(
                        onPressed: () {
                          nextScreenReplace(context, RegisterScreen());
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Color(0xff6850a4)),
                        ))
                  ],
                ),
                SizedBox(
                  height: height * .03,
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
                )
              ],
            ),
          ),
        ),
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
      await sp.userSignOut();
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), basicColor);
          googleController.reset();
        } else {
          //Checking User Existence
          sp.checkUserExists().then((value) async {
            if (value == true) {
              try {
                await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
                    .saveDataToSharedPreferences()
                    .then((value) => sp.setSignIn().then((value) {
                          googleController.success();
                          handleAfterSigningIn();
                        })));
              } catch (e) {
                // Handle the error, e.g., show an error message to the user
                log('Failed to retrieve user data: $e');
              }
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

  Future<void> emailPasswordLogin() async {
    var sp = context.read<SignInProvider>();
    var ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackBar(context, 'Check your internet connection', basicColor);
      loginController.reset();
    } else if (formKey.currentState?.validate() == false) {
      loginController.reset();
      return;
    }
    try {
      sp.userSignOut();
      sp.firebaseAuth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((userCredential) async {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), basicColor);
          loginController.reset();
        } else {
          User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text))
              .user!;
          sp.emailPasswordUser(
              user,
              emailController.text,
              sp.firebaseAuth.currentUser?.displayName,
              passwordController.text);
          await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
              .saveDataToSharedPreferences()
              .then((value) => sp.setSignIn().then((value) {
                    loginController.success();
                    handleAfterSigningIn();
                  })));
        }
      }).onError((error, stackTrace) {
        if (error.toString().contains('The password is invalid') ||
            error.toString().contains('There is no user'))
          openSnackBar(context, 'Invalid email or password', basicColor);
        else
          openSnackBar(context, error.toString(), basicColor);
        loginController.reset();
      });
    } on FirebaseAuthException catch (e) {
      openSnackBar(context, 'Invalid email or password', basicColor);
    }
  }

  handleAfterSigningIn() {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, HomeScreen());
    });
  }
}
