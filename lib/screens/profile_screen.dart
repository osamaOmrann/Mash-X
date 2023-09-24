import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/helpers/validation_utils.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage(this.userId);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? _picked_image;
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  bool userInfo = true, experience = false, review = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffcfcfcf),
      appBar: AppBar(
        backgroundColor: Color(0xff0c2954),
        elevation: 0,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(flip: true),
            child: Container(
              height: height * .23,
              color: Color(0xff0c2954),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error loading data try again later');
              }

              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String age = '';

              void computeAge() {
                age = (DateTime.now().year -
                        DateTime.fromMillisecondsSinceEpoch(
                                userData['birth_date'])
                            .year)
                    .toString();
                if (DateTime.now().month <
                        DateTime.fromMillisecondsSinceEpoch(
                                userData['birth_date'])
                            .month ||
                    (DateTime.now().month ==
                            DateTime.fromMillisecondsSinceEpoch(
                                    userData['birth_date'])
                                .month &&
                        DateTime.now().day <
                            DateTime.fromMillisecondsSinceEpoch(
                                    userData['birth_date'])
                                .day)) {
                  age = (int.parse(age) - 1).toString();
                }
              }

              computeAge();

              return Padding(
                padding: EdgeInsets.only(left: width * .07, right: width * .07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: height * .03,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * .023),
                          color: Colors.white),
                      padding: EdgeInsets.symmetric(vertical: height * .03),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * .3),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(width),
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: userData['image_url']),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .015,
                                  )
                                ],
                              ),
                              Positioned(
                                top: height * .07,
                                right: width * .285,
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * .021,
                                      vertical: height * .007),
                                  minWidth: 0,
                                  height: height * .03,
                                  shape: CircleBorder(),
                                  onPressed: () {
                                    _showBottomSheet(context);
                                  },
                                  child: Icon(
                                    CupertinoIcons.pen,
                                    color: Colors.white,
                                  ),
                                  color: Color(0xff0c2954),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Text(
                            userData['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * .05),
                          ),
                          Text(userData['job_title']),
                          SizedBox(
                            height: height * .03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(width * .021),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * .041),
                                    color: Color(0xffcfcfcf)),
                                child: ImageIcon(
                                  AssetImage('assets/images/check.png'),
                                  color: Color(0xff0c2954),
                                ),
                              ),
                              SizedBox(
                                width: width * .021,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${userData['job_success'] ?? ''}%'),
                                  Text(
                                    'Job Success',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: width * .03),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: width * .05,
                              ),
                              Container(
                                padding: EdgeInsets.all(width * .021),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width * .041),
                                    color: Color(0xffcfcfcf)),
                                child: Center(
                                    child: Icon(
                                  CupertinoIcons.star,
                                  color: Color(0xff0c2954),
                                )),
                              ),
                              SizedBox(
                                width: width * .021,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${userData['stars'] ?? ''}/5'),
                                  Text(
                                    'Star Ratings',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: width * .03),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .013,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              userInfo = true;
                              experience = false;
                              review = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * .053,
                                vertical: height * .01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * .023),
                                  bottomLeft: Radius.circular(width * .023)),
                              color: Colors.white,
                            ),
                            child: Text(
                              'USER INFO',
                              style: TextStyle(
                                  color: userInfo == true
                                      ? Color(0xff0c2954)
                                      : Color(0xffcfcfcf)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * .0015,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              userInfo = false;
                              experience = true;
                              review = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * .053,
                                vertical: height * .01),
                            color: Colors.white,
                            child: Text(
                              'EXPERIENCE',
                              style: TextStyle(
                                  color: experience == true
                                      ? Color(0xff0c2954)
                                      : Color(0xffcfcfcf)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * .0015,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              userInfo = false;
                              experience = false;
                              review = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * .053,
                                vertical: height * .01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(width * .023),
                                  bottomRight: Radius.circular(width * .023)),
                              color: Colors.white,
                            ),
                            child: Text(
                              'REVIEW',
                              style: TextStyle(
                                  color: review == true
                                      ? Color(0xff0c2954)
                                      : Color(0xffcfcfcf)),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * .013,
                    ),
                    if (userInfo == true)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * .023),
                            color: Colors.white),
                        padding: EdgeInsets.symmetric(
                            vertical: height * .03, horizontal: width * .03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Gehalt:',
                                  style: TextStyle(
                                      color: Color(0xff0c2954),
                                      fontSize: width * .043),
                                ),
                                Spacer(),
                                Text(
                                  '${userData['salary']} €',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * .03,
                            ),
                            Row(
                              children: [
                                Text(
                                  'About Me',
                                  style: TextStyle(
                                      color: Color(0xff0c2954),
                                      fontSize: width * .043),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    showDialog(context: context, builder: (_) {
                                      aboutController = TextEditingController(text: userData['about']);                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                DataBase.updateUserData(DataBase.user!.uid, 'about', aboutController.text.trim());
                                                Navigator.pop(context);
                                              },
                                              child: Text('Confirm'))
                                        ],
                                        content: TextFormField(
                                          controller: aboutController,
                                          decoration: InputDecoration(
                                            labelText: 'About yourself'
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: Text(
                                    'Edit',
                                    style:
                                        TextStyle(color: Colors.yellow.shade700),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * .025,
                            ),
                            Text(
                              '${userData['about']}',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    if (userInfo == true)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * .023),
                            color: Colors.white),
                        padding: EdgeInsets.symmetric(
                            vertical: height * .03, horizontal: width * .03),
                        margin: EdgeInsets.only(top: height * .013),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Contact:',
                                  style: TextStyle(
                                      color: Color(0xff0c2954),
                                      fontSize: width * .043),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context, builder: (_) {
                                          phoneController = TextEditingController(text: userData['phone_number']);
                                          emailController = TextEditingController(text: userData['email']);
                                          cityController = TextEditingController(text: userData['city']);
                                          stController = TextEditingController(text: userData['st_name']);
                                          buildingController = TextEditingController(text: userData['building_number'].toString());
                                      return Form(
                                        key: _formKey,
                                        child: AlertDialog(
                                          actions: [
                                            TextButton(onPressed: () async {
                                              if (_formKey.currentState!.validate()) {
                                                DataBase.updateUserData(DataBase.user!.uid, 'phone_number', phoneController.text.trim());
                                                DataBase.updateUserData(DataBase.user!.uid, 'email', emailController.text.trim());
                                                DataBase.updateUserData(DataBase.user!.uid, 'city', cityController.text.trim());
                                                DataBase.updateUserData(DataBase.user!.uid, 'st_name', stController.text.trim());
                                                List<Location> location = await locationFromAddress('Germany, ${cityController.text.trim()}, ${stController.text.trim()}');
                                                DataBase.updateUserData(DataBase.user!.uid, 'lat', location.last.latitude.toString());
                                                DataBase.updateUserData(DataBase.user!.uid, 'lng', location.last.longitude.toString());
                                                DataBase.updateUserData(DataBase.user!.uid, 'building_number', buildingController.text.trim());
                                                Navigator.pop(context);
                                              } else {
                                                return;
                                              }
                                            }, child: Text('Save'))
                                          ],
                                          content: Container(
                                            height: height * .5,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextFormField(
                                                  controller: phoneController,
                                                  keyboardType: TextInputType.phone,
                                                validator: (text) {
                                                  if (text == null || text.trim().isEmpty) {
                                                    return 'Please enter your phone number';
                                                  }
                                                  if (text.trim().length < 5) {
                                                    return 'Please enter a valid phone number';
                                                  }
                                                  return null;
                                                },
                                                  decoration: InputDecoration(
                                                    labelText: 'Phone number'
                                                  ),
                                                ),
                                                TextFormField(
                                                  keyboardType: TextInputType.emailAddress,
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
                                                    labelText: 'Email adress'
                                                  ),
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
                                                      counterText: "",
                                                    labelText: 'City'
                                                  ),
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
                                                      counterText: "",
                                                    labelText: 'Street name'
                                                  ),
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
                                                    labelText: 'Building number',
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: Text(
                                    'Edit',
                                    style:
                                        TextStyle(color: Colors.yellow.shade700),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * .019,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * .021),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * .041),
                                      color: Color(0xffcfcfcf)),
                                  child: Center(
                                      child: Icon(
                                    Icons.phone,
                                    color: Color(0xff0c2954),
                                  )),
                                ),
                                SizedBox(
                                  width: width * .05,
                                ),
                                Text(userData['phone_number'])
                              ],
                            ),
                            SizedBox(
                              height: height * .01,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * .021),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * .041),
                                      color: Color(0xffcfcfcf)),
                                  child: Center(
                                      child: Icon(
                                    Icons.mail,
                                    color: Color(0xff0c2954),
                                  )),
                                ),
                                SizedBox(
                                  width: width * .05,
                                ),
                                Text(userData['email'])
                              ],
                            ),
                            SizedBox(
                              height: height * .01,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * .021),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(width * .041),
                                      color: Color(0xffcfcfcf)),
                                  child: Center(
                                      child: Icon(
                                    Icons.location_on,
                                    color: Color(0xff0c2954),
                                  )),
                                ),
                                SizedBox(
                                  width: width * .05,
                                ),
                                Text(
                                    '${userData['building_number']} ${userData['st_name']} st, ${userData['city']}')
                              ],
                            )
                          ],
                        ),
                      ),
                    if (experience == true) Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            for (int i = 0; i < userData['work_history'].length; i++)
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('jobs')
                                      .doc(userData['work_history'][i])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'Error loading data try again later');
                                    }

                                    if (!snapshot.hasData) {
                                      return Center(child: CircularProgressIndicator());
                                    }

                                    var jobData =
                                    snapshot.data!.data() as Map<String, dynamic>;
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(width * .023),
                                          color: Colors.white),
                                      padding: EdgeInsets.only(top: height * .03, bottom: height * .03, right: width * .03, left: width * .055),
                                      margin: EdgeInsets.only(bottom: height * .01),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(imageUrl: jobData['company_image'], width: width * .1,),
                                          SizedBox(width: width * .03,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(jobData['job_title'].split(" ")[0], style: TextStyle(fontSize: width * .041), overflow: TextOverflow.ellipsis,),
                                              if(jobData['job_title'].split(" ").last != jobData['job_title'].split(" ")[0])Text(jobData['job_title'].split(" ").last ?? '', style: TextStyle(fontSize: width * .041), overflow: TextOverflow.ellipsis),
                                              Text('at ${jobData['company_name']}', style: TextStyle(color: Colors.grey),)
                                            ],
                                          ),
                                          SizedBox(width: width * .035,),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.yellow,
                                                        borderRadius: BorderRadius.circular(width)
                                                    ),
                                                    width: width * .021,
                                                    height: width * .021,
                                                  ),
                                                  Text(' ${jobData['period']}')
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * .03,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  })
                          ],
                        ),
                      ),
                    if (review == true) Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            for (int i = 0; i < userData['rates'].length; i++)
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('rates')
                                      .doc(userData['rates'][i])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'Error loading data try again later');
                                    }

                                    if (!snapshot.hasData) {
                                      return Center(child: CircularProgressIndicator());
                                    }

                                    var rateData =
                                    snapshot.data!.data() as Map<String, dynamic>;
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(width * .023),
                                          color: Colors.white),
                                      padding: EdgeInsets.only(top: height * .03, bottom: height * .03, right: width * .03, left: width * .055),
                                      margin: EdgeInsets.only(bottom: height * .01),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(width * .015),
                                              child: CachedNetworkImage(imageUrl: rateData['image'], width: width * .15, height: width * .15, fit: BoxFit.cover,)),
                                          SizedBox(width: width * .03,),
                                          SizedBox(
                                              width: width * .55,
                                              child: Text(rateData['comment'], softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis,))
                                        ],
                                      ),
                                    );
                                  })
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
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
}