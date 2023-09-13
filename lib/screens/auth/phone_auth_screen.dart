import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mash/helpers/internet_provider.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/helpers/snack_bar.dart';
import 'package:mash/helpers/validation_utils.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:mash/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final RoundedLoadingButtonController submitController =
      RoundedLoadingButtonController();
  FocusNode focusNode = FocusNode();
  String phoneNumber = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: basicColor,),
          onPressed: () => nextScreenReplace(context, LoginScreen()),
        ),
      ),
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * .05),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
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
              SizedBox(height: height * .1),
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
                    color: Color(0xff6850a4),
                  ),
                  labelStyle: TextStyle(color: Color(0xff6850a4)),
                  focusColor: Color(0xff6850a4),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff6850a4)),
                      borderRadius: BorderRadius.circular(width * .061)),
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(width * .061)),
                ),
              ),
              SizedBox(height: height * .03),
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
                    color: Color(0xff6850a4),
                  ),
                  labelStyle: TextStyle(color: Color(0xff6850a4)),
                  focusColor: Color(0xff6850a4),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff6850a4)),
                      borderRadius: BorderRadius.circular(width * .061)),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(width * .061)),
                ),
              ),
              SizedBox(height: height * .03),
              IntlPhoneField(
                initialCountryCode: 'DE',
                focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: Color(0xff6850a4)),
                  labelStyle: TextStyle(color: Color(0xff6850a4)),
                  focusColor: Color(0xff6850a4),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff6850a4)),
                      borderRadius: BorderRadius.circular(width * .061)),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(width * .061)),
                ),
                languageCode: "en",
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                  log(phoneNumber);
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
              ),
              SizedBox(height: height * .03),
              RoundedLoadingButton(
                  color: basicColor,
                  controller: submitController,
                  onPressed: () => login(context, phoneNumber),
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    ),
    );
  }

  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackBar(context, 'Check your internet connection', basicColor);
      submitController.reset();
    } else {
      if (_formKey.currentState!.validate() && phoneNumber.length > 5) {
        sp.userSignOut();
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobile,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnackBar(context, e.toString(), basicColor);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var width = MediaQuery.of(context).size.width;
                    RoundedLoadingButtonController confirmController = RoundedLoadingButtonController();
                    return WillPopScope(
                      onWillPop: () async {
                        submitController.reset();
                        return true;
                      },
                      child: AlertDialog(
                        title: Text('Enter code'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: otpController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.code,
                                  color: basicColor,
                                ),
                                labelStyle: TextStyle(color: basicColor),
                                focusColor: basicColor,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: basicColor),
                                    borderRadius:
                                        BorderRadius.circular(width * .061)),
                                labelText: 'Code',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius:
                                        BorderRadius.circular(width * .061)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RoundedLoadingButton(
                              controller: confirmController,
                                color: basicColor,
                                onPressed: () async {
                                  final code = otpController.text.trim();
                                  AuthCredential authCredential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: code);
                                  User user = (await FirebaseAuth.instance
                                          .signInWithCredential(authCredential))
                                      .user!;
                                  sp.phoneNumberUser(user, emailController.text,
                                      nameController.text);

                                  //Check User Existence
                                  sp.checkUserExists().then((value) async {
                                    if (value == true) {
                                      await sp
                                          .getUserDataFromFireStore(sp.uid)
                                          .then((value) => sp
                                              .saveDataToSharedPreferences()
                                              .then((value) =>
                                                  sp.setSignIn().then((value) {
                                                    submitController.success();
                                                    nextScreenReplace(
                                                        context, HomeScreen());
                                                  })));
                                    } else {
                                      sp.saveDataToFireStore().then((value) => sp
                                          .saveDataToSharedPreferences()
                                          .then((value) =>
                                              sp.setSignIn().then((value) {
                                                submitController.success();
                                                nextScreenReplace(
                                                    context, HomeScreen());
                                              })));
                                    }
                                  });
                                },
                                child: Text('Confirm'))
                          ],
                        ),
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      } else {
        submitController.reset();
        openSnackBar(context, 'Valid data is required', basicColor);
      }
    }
  }
}
