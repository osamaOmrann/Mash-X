import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/helpers/validation_utils.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CompleteUserData extends StatefulWidget {
  @override
  State<CompleteUserData> createState() => _CompleteUserDataState();
}

class _CompleteUserDataState extends State<CompleteUserData> {
  String? _picked_image;
  String image = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController buldingController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stController = TextEditingController();
  RoundedLoadingButtonController saveController = RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
    image = sp.imageUrl!;
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
                              errorWidget: (context, url, error) => CircleAvatar(
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
                      left: width * .321,
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
                                borderRadius: BorderRadius.circular(height * .1),
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
                                  border: Border.all(
                                      color: Colors.white, width: width * .007),
                                  borderRadius: BorderRadius.circular(width)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(height * .1),
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: width * .05),
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .07),
                child: Column(
                  children: [
                    /*if(sp.name == null || sp.name!.trim().isEmpty) */ TextFormField(
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
                    /*if(sp.name == null || sp.name!.trim().isEmpty) */ SizedBox(
                      height: height * .03,
                    ),
                    /*if(sp.email == null || sp.email!.trim().isEmpty)*/ TextFormField(
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
                    /*if(sp.email == null || sp.email!.trim().isEmpty)*/ SizedBox(
                      height: height * .03,
                    ),
                    /*if(sp.phoneNumber == null || sp.phoneNumber!.trim().isEmpty)*/ TextFormField(
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
                      keyboardType: TextInputType.numberWithOptions(),
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
                            borderRadius: BorderRadius.circular(width * .061)),
                        labelText: 'Phone number',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(width * .061)),
                      ),
                    ),
                    /*if(sp.phoneNumber == null || sp.phoneNumber!.trim().isEmpty)*/ SizedBox(
                      height: height * .03,
                    ),
                    /*if(sp.city == null || sp.city!.trim().isEmpty)*/ TextFormField(
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
                            borderRadius: BorderRadius.circular(width * .061)),
                        labelText: 'City',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(width * .061)),
                      ),
                    ),
                    /*if(sp.city == null || sp.city!.trim().isEmpty)*/ SizedBox(
                      height: height * .01,
                    ),
                    /*if(sp.stName == null || sp.stName!.trim().isEmpty)*/ TextFormField(
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
                            borderRadius: BorderRadius.circular(width * .061)),
                        labelText: 'Street name',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(width * .061)),
                      ),
                    ),
                    /*if(sp.stName == null || sp.stName!.trim().isEmpty)*/ SizedBox(
                      height: height * .01,
                    ),
                    /*if(sp.buildingNumber == null)*/ TextFormField(
                      controller: buldingController,
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
                            borderRadius: BorderRadius.circular(width * .061)),
                        labelText: 'Building number',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(width * .061)),
                      ),
                    ),
                    /*if(sp.buildingNumber == null)*/ SizedBox(
                      height: height * .03,
                    ),
                    /*if(sp.postalCode == null || sp.postalCode!.trim().isEmpty)*/ TextFormField(
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
                            borderRadius: BorderRadius.circular(width * .061)),
                        labelText: 'Postal code',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(width * .061)),
                      ),
                    ),
                    /*if(sp.postalCode == null || sp.postalCode!.trim().isEmpty)*/ SizedBox(
                      height: height * .03,
                    ),
                    /*if(sp.birthDate == null)*/ GestureDetector(
                      onTap: () {
                        showDateDialoge();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: width * .025),
                        height: height * .065,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey, width: width * .003),
                            borderRadius: BorderRadius.circular(width * .061)),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
        controller: saveController,
        color: basicColor,
        onPressed: () {},
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
