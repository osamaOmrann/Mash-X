import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mash/helpers/internet_provider.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/helpers/snack_bar.dart';
import 'package:mash/helpers/validation_utils.dart';
import 'package:mash/main.dart';
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
  final RoundedLoadingButtonController registerController =
      RoundedLoadingButtonController();
  bool securePasswordI = true;
  bool securePasswordII = true;
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .07),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height * .061,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'M',
                      style: TextStyle(
                          fontSize: width * .15,
                          fontWeight: FontWeight.bold,
                          color: basicColor),
                    ),
                    Text('ashX',
                        style:
                            TextStyle(fontSize: width * .07, color: basicColor))
                  ],
                ),
                SizedBox(
                  height: height * .05,
                ),
                Text('Register'),
                SizedBox(
                  height: height * .041,
                ),
                TextFormField(
                  controller: nameController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: basicColor,
                    ),
                    labelStyle: TextStyle(color: basicColor),
                    focusColor: basicColor,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: basicColor),
                        borderRadius: BorderRadius.circular(width * .061)),
                    labelText: 'Full name',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(width * .061)),
                  ),
                ),
                SizedBox(
                  height: height * .021,
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
                  height: height * .021,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (text.length < 8) {
                      return 'Password must be at least eight characters';
                    }
                    return null;
                  },
                  obscureText: securePasswordI,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password, color: basicColor),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            securePasswordI = !securePasswordI;
                            setState(() {});
                          },
                          child: Icon(
                            securePasswordI
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: securePasswordI ? Colors.grey : basicColor,
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
                  height: height * .021,
                ),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Confirm password';
                    }
                    if (text != passwordController.text) {
                      return 'The two passwords are not identical';
                    }
                    return null;
                  },
                  obscureText: securePasswordII,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password, color: basicColor),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            securePasswordII = !securePasswordII;
                            setState(() {});
                          },
                          child: Icon(
                              securePasswordII
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  securePasswordII ? Colors.grey : basicColor)),
                      labelStyle: TextStyle(color: basicColor),
                      focusColor: basicColor,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: basicColor),
                          borderRadius: BorderRadius.circular(width * .061)),
                      labelText: 'Confirm password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(width * .061))),
                ),
                SizedBox(
                  height: height * .021,
                ),
                RoundedLoadingButton(
                    successColor: basicColor,
                    color: basicColor,
                    borderRadius: width * .05,
                    controller: registerController,
                    onPressed: () => createAccountCliked(),
                    child: Text('Register')),
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
                ),
                SizedBox(
                  height: height * .021,
                ),
                Text('Or login with'),
                SizedBox(
                  height: height * .013,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundedLoadingButton(
                      controller: googleController,
                      onPressed: handleGoogleSignIn,
                      child: Icon(FontAwesomeIcons.google),
                      successColor: basicColor,
                      color: basicColor,
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
                      successColor: basicColor,
                      color: basicColor,
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
      sp.userSignOut();
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

  Future<void> createAccountCliked() async {
    var sp = context.read<SignInProvider>();
    var ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackBar(context, 'Check your internet connection', basicColor);
      registerController.reset();
    } else if (formKey.currentState?.validate() == false) {
      registerController.reset();
      return;
    }
    sp.userSignOut();
    sp.firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((userCredential) async {
      if (sp.hasError == true) {
        openSnackBar(context, sp.errorCode.toString(), basicColor);
        registerController.reset();
      } else {
        User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text))
            .user!;
        sp.emailPasswordUser(user, emailController.text, nameController.text,
            passwordController.text);
        sp.saveDataToFireStore().then((value) => sp
            .saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
                  registerController.success();
                  handleAfterSigningIn();
                })));
      }
    }).onError((error, stackTrace) {
      if (error
          .toString()
          .contains('The email address is already in use by another account'))
        openSnackBar(
            context,
            'The email address is already in use by another account',
            basicColor);
      if (error.toString().contains('badly formatted'))
        openSnackBar(context, 'Enter a valid email address', basicColor);
      else
        openSnackBar(context, error.toString(), basicColor);
      registerController.reset();
    });
  }
}
