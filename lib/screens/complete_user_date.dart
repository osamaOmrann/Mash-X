import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/helpers/snack_bar.dart';
import 'package:mash/helpers/validation_utils.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:mash/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CompleteUserData extends StatefulWidget {
  @override
  State<CompleteUserData> createState() => _CompleteUserDataState();
}

class _CompleteUserDataState extends State<CompleteUserData> {
  String? _picked_image;
  String image = '';
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stController = TextEditingController();
  RoundedLoadingButtonController saveController =
      RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey();

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
    image = sp.imageUrl!;
    phoneController = TextEditingController(
        text: (sp.phoneNumber == null ||
                sp.phoneNumber == 'null' ||
                sp.phoneNumber == '')
            ? ''
            : sp.phoneNumber);
    nameController = TextEditingController(text: sp.name ?? '');
    emailController = TextEditingController(text: sp.email ?? '');
    buildingController = TextEditingController(
        text: (sp.buildingNumber == null || sp.buildingNumber == 0)
            ? ''
            : sp.buildingNumber?.toString());
    postalCodeController = TextEditingController(
        text: (sp.postalCode == 'null' ||
                sp.postalCode == null ||
                sp.postalCode == '')
            ? ''
            : sp.postalCode);
    cityController = TextEditingController(
        text: (sp.city == 'null' || sp.city == null || sp.city == '')
            ? ''
            : sp.city);
    stController = TextEditingController(
        text: (sp.stName == 'null' || sp.stName == null || sp.stName == '')
            ? ''
            : sp.stName);
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
      key: _scaffoldKey,
      drawer: Drawer(
        child: Center(
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () {
                sp.userSignOut();
                nextScreenReplace(context, LoginScreen());
              },
              icon: Icon(
                Icons.logout,
                color: basicColor,
              ),
              label: Text(
                'Log out',
                style: TextStyle(color: basicColor),
              )),
        ),
      ),
      body: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.down,
        color: Colors.purple,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      _picked_image != null
                          ? Image.file(
                              height: height * .3,
                              width: double.infinity,
                              File(_picked_image!),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              width: double.infinity,
                              height: height * .3,
                              filterQuality: FilterQuality.high,
                              imageUrl: image,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                child: Icon(CupertinoIcons.person_alt),
                              ),
                            ),
                      SizedBox(
                        height: height * .079,
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: height * .3,
                    color: basicColor.withOpacity(.7),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height * .05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * .05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: Icon(
                                CupertinoIcons.list_bullet,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'COMPLETE YOUR DATA',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: height * .22001,
                      left: width * .33,
                      child: _picked_image != null
                          ? Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  border: Border.all(
                                      color: Colors.white, width: width * .007),
                                  borderRadius: BorderRadius.circular(width)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(height * .1),
                                child: Image.file(
                                  File(_picked_image!),
                                  width: height * .15,
                                  height: height * .15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  border: Border.all(
                                      color: Colors.white, width: width * .007),
                                  borderRadius: BorderRadius.circular(width)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(height * .1),
                                child: CachedNetworkImage(
                                  width: height * .15,
                                  height: height * .15,
                                  imageUrl: image,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    child: Icon(CupertinoIcons.person_alt),
                                  ),
                                ),
                              ),
                            )),
                  Positioned(
                    bottom: height * .05,
                    right: width * .25,
                    child: MaterialButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * .021, vertical: height * .007),
                      minWidth: 0,
                      height: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * .03),
                      ),
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                      child: Icon(
                        CupertinoIcons.pen,
                        color: Colors.white,
                      ),
                      color: basicColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * .01,
              ),
              Text(
                sp.name ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * .05),
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .07),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
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
                            color: Color(0xff6850a4),
                          ),
                          labelStyle: TextStyle(color: Color(0xff6850a4)),
                          focusColor: Color(0xff6850a4),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff6850a4)),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      TextFormField(
                        controller: phoneController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (text.trim().length < 5) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        maxLength: 17,
                        decoration: InputDecoration(
                          hintMaxLines: 1,
                          counterText: "",
                          prefixIcon: Icon(
                            CupertinoIcons.phone_fill,
                            color: basicColor,
                          ),
                          labelStyle: TextStyle(color: basicColor),
                          focusColor: basicColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: basicColor),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      TextFormField(
                        controller: cityController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                        maxLength: 17,
                        decoration: InputDecoration(
                          errorMaxLines: 1,
                          counterText: " ",
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: basicColor,
                          ),
                          labelStyle: TextStyle(color: basicColor),
                          focusColor: basicColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff6850a4)),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          labelText: 'City',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      TextFormField(
                        controller: stController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter your street name';
                          }
                          return null;
                        },
                        maxLength: 37,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          counterText: " ",
                          prefixIcon: Icon(
                            Icons.add_road,
                            color: basicColor,
                          ),
                          labelStyle: TextStyle(color: basicColor),
                          focusColor: basicColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: basicColor),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          labelText: 'Street name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .01,
                      ),
                      TextFormField(
                        controller: buildingController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter your building number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        decoration: InputDecoration(
                          hintMaxLines: 1,
                          counterText: "",
                          prefixIcon: Icon(
                            CupertinoIcons.home,
                            color: basicColor,
                          ),
                          labelStyle: TextStyle(color: basicColor),
                          focusColor: basicColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: basicColor),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          labelText: 'Building number',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      TextFormField(
                        controller: postalCodeController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter postal code';
                          }
                          return null;
                        },
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
                          labelText: 'Postal code',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDateDialoge();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * .025),
                          height: height * .065,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey, width: width * .003),
                              borderRadius:
                                  BorderRadius.circular(width * .061)),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: basicColor,
                                ),
                                SizedBox(
                                  width: width * .025,
                                ),
                                Text(
                                  selectedDate == null
                                      ? 'Birth date'
                                      : 'Birth date: ${selectedDate?.year}/${selectedDate?.month}/${selectedDate?.day}',
                                  style: TextStyle(
                                      color: basicColor, fontSize: width * .04),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
        controller: saveController,
        color: basicColor,
        onPressed: () {
          if (sp.imageUrl ==
              'https://cdn-icons-png.flaticon.com/512/149/149071.png') {
            openSnackBar(context, 'Please insert your photo', basicColor);
            saveController.reset();
            return;
          }
          if (selectedDate == null || selectedDate == DateTime.now()) {
            openSnackBar(context, 'Please complete your data', basicColor);
            saveController.reset();
            return;
          }
          if (_formKey.currentState!.validate()) {
            DataBase.updateUserData(
                DataBase.user.uid, 'name', nameController.text.trim());
            DataBase.updateUserData(
                DataBase.user.uid, 'email', emailController.text.trim());
            DataBase.updateUserData(
                DataBase.user.uid, 'phone_number', phoneController.text.trim());
            DataBase.updateUserData(
                DataBase.user.uid, 'city', cityController.text.trim());
            DataBase.updateUserData(
                DataBase.user.uid, 'st_name', stController.text.trim());
            DataBase.updateUserData(
                DataBase.user.uid, 'building_number', int.parse(buildingController.text.trim()));
            DataBase.updateUserData(
                DataBase.user.uid, 'postal_code', postalCodeController.text.trim());
            DataBase.updateUserData(
                DataBase.user.uid, 'birth_date', selectedDate?.millisecondsSinceEpoch);
            sp.saveDataToSharedPreferences();
            saveController.success();
            Future.delayed(const Duration(seconds: 2));
            nextScreenReplace(context, HomeScreen());
          } else {
            saveController.reset();
            return;
          }
        },
        child: Text('Save'),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * .05),
                topRight: Radius.circular(width * .05))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: height * .03, bottom: height * .05),
            children: [
              Text(
                'Choose a pic',
                style: TextStyle(fontFamily: 'Cairo'),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(width * .3, height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                          setState(() {
                            _picked_image = image.path;
                          });
                          DataBase.updateProfilePicture(File(_picked_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/gallery.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(width * .3, height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _picked_image = image.path;
                          });
                          DataBase.updateProfilePicture(File(_picked_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png'))
                ],
              )
            ],
          );
        });
  }

  DateTime? selectedDate;

  void showDateDialoge() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 365 * 40)),
        lastDate: DateTime.now());
    if (date != null) {
      selectedDate = date;
      setState(() {});
    }
  }
}