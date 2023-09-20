import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/main.dart';
import 'package:mash/models/company.dart';
import 'package:mash/models/rate.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage(this.userId);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? _picked_image;
  TextEditingController skillController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> _jobFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
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
                    DateTime.fromMillisecondsSinceEpoch(userData['birth_date'])
                        .year)
                .toString();
            if (DateTime.now().month <
                    DateTime.fromMillisecondsSinceEpoch(userData['birth_date'])
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

          return Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          CachedNetworkImage(
                              height: height * .45,
                              width: width,
                              fit: BoxFit.cover,
                              imageUrl: userData['image_url']),
                          SizedBox(
                            height: height * .05,
                          ),
                        ],
                      ),
                      Positioned(
                          right: width * .05,
                          top: height * .419,
                          child: FloatingActionButton(
                            backgroundColor: basicColor,
                            onPressed: () {
                              _showBottomSheet(context);
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .065),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${userData['name']}, $age',
                              style: TextStyle(fontSize: width * .061),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              userData['city'],
                              style: TextStyle(
                                  color: basicColor, fontSize: width * .039),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: Colors.grey,
                                child: Text('Rates: ')),
                          ],
                        ),
                        FutureBuilder<QuerySnapshot<Rate>>(
                          builder: (buildContext, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child:
                                    Text('Error loading date try again later'),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                    color: basicColor),
                              );
                            }
                            var data = snapshot.data?.docs
                                .map((e) => e.data())
                                .toList();
                            return SizedBox(
                              height: height * userData['rates'].length / 40,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (buildContext, index) {
                                  return data.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No rates yet',
                                            style: TextStyle(
                                                color: basicColor,
                                                fontSize: 30),
                                          ),
                                        )
                                      : userData['rates'][index]
                                              .contains(data[index].id)
                                          ? Row(
                                              children: [
                                                Text(
                                                  '${data[index].companyName}:' ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(' ${data[index].comment}')
                                              ],
                                            )
                                          : null;
                                },
                                itemCount: data!.length,
                              ),
                            );
                          },
                          future: DataBase.listenForRatesRealTimeUpdates(),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: Colors.grey,
                                child: Text('Previously worked in:')),
                          ],
                        ),
                        FutureBuilder<QuerySnapshot<Company>>(
                          builder: (buildContext, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child:
                                    Text('Error loading date try again later'),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                    color: basicColor),
                              );
                            }
                            var data = snapshot.data?.docs
                                .map((e) => e.data())
                                .toList();
                            return SizedBox(
                              height:
                                  height * userData['work_history'].length / 50,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (buildContext, index) {
                                  return data.isEmpty
                                      ? Center(
                                          child: Text(
                                            'No work yet',
                                            style: TextStyle(
                                                color: basicColor,
                                                fontSize: 30),
                                          ),
                                        )
                                      : userData['work_history'][index]
                                              .contains(data[index].id)
                                          ? Text(
                                              '-${data[index].name}' ?? '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : null;
                                },
                                itemCount: data!.length,
                              ),
                            );
                          },
                          future: DataBase.listenForCompaniesRealTimeUpdates(),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * .015,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * .005),
                                    color: Colors.grey,
                                    child: Text('Skills:')),
                                for (int i = 0;
                                    i < userData['skills']?.length;
                                    i++)
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: width * .041,
                                          top: height * .01,
                                          bottom: height * .01,
                                          right: width * .015),
                                      margin:
                                          EdgeInsets.only(top: height * .01),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.41),
                                          borderRadius: BorderRadius.circular(
                                              width * .05)),
                                      child: Row(
                                        children: [
                                          Text('${userData['skills'][i]}'),
                                          SizedBox(
                                            width: width * .03,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              List newSkills =
                                                  userData['skills'];
                                              newSkills.remove(
                                                  userData['skills'][i]);
                                              DataBase.updateUserData(
                                                  DataBase.user.uid,
                                                  'skills',
                                                  newSkills);
                                            },
                                            child: Icon(CupertinoIcons
                                                .xmark_circle_fill),
                                          )
                                        ],
                                      )),
                                SizedBox(
                                  height: height * .01,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: basicColor),
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      List newSkills =
                                                          userData['skills'];
                                                      newSkills.add(
                                                          skillController.text);
                                                      DataBase.updateUserData(
                                                          DataBase.user.uid,
                                                          'skills',
                                                          newSkills);
                                                      Navigator.pop(context);
                                                      skillController.clear();
                                                    } else {
                                                      return;
                                                    }
                                                  },
                                                  child: Text('Add'))
                                            ],
                                            content: Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                controller: skillController,
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.trim().isEmpty) {
                                                    return 'Can\'t add an empty skill';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: basicColor),
                                                  focusColor: basicColor,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  basicColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      width *
                                                                          .061)),
                                                  labelText: 'Skill',
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              width * .061)),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width * .3,
                                      ),
                                      Text('Add skill'),
                                      Icon(CupertinoIcons.add)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * .015,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    color: Colors.grey,
                                    child: Text('Intended jobs:')),
                                for (int i = 0;
                                    i < userData['intended_jobs']?.length;
                                    i++)
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: width * .041,
                                        top: height * .01,
                                        bottom: height * .01,
                                        right: width * .015),
                                    margin: EdgeInsets.only(top: height * .01),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.41),
                                        borderRadius:
                                            BorderRadius.circular(width * .05)),
                                    child: Row(
                                      children: [
                                        Text(
                                            '${userData['intended_jobs'][i]}'),
                                        SizedBox(
                                          width: width * .03,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            List newIntendedJobs =
                                                userData['intended_jobs'];
                                            newIntendedJobs.remove(
                                                userData['intended_jobs'][i]);
                                            DataBase.updateUserData(
                                                DataBase.user.uid,
                                                'intended_jobs',
                                                newIntendedJobs);
                                          },
                                          child: Icon(
                                              CupertinoIcons.xmark_circle_fill),
                                        )
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  height: height * .01,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: basicColor),
                                                  onPressed: () {
                                                    if (_jobFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      List newIntendedJobs =
                                                          userData[
                                                              'intended_jobs'];
                                                      newIntendedJobs.add(
                                                          jobController.text);
                                                      DataBase.updateUserData(
                                                          DataBase.user.uid,
                                                          'intended_jobs',
                                                          newIntendedJobs);
                                                      Navigator.pop(context);
                                                      jobController.clear();
                                                    } else {
                                                      return;
                                                    }
                                                  },
                                                  child: Text('Add'))
                                            ],
                                            content: Form(
                                              key: _jobFormKey,
                                              child: TextFormField(
                                                controller: jobController,
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.trim().isEmpty) {
                                                    return 'Can\'t add an empty job';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      color: basicColor),
                                                  focusColor: basicColor,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  basicColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      width *
                                                                          .061)),
                                                  labelText: 'Job',
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              width * .061)),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width * .3,
                                      ),
                                      Text('Add job'),
                                      Icon(CupertinoIcons.add)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .015,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .065),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              userData['email'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Row(
                          children: [
                            Text(
                              'Birth date',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              '${DateTime.fromMillisecondsSinceEpoch(userData['birth_date']).day}/${DateTime.fromMillisecondsSinceEpoch(userData['birth_date']).month}/${DateTime.fromMillisecondsSinceEpoch(userData['birth_date']).year}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Row(
                          children: [
                            Text(
                              'Phone number',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              userData['phone_number'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Row(
                          children: [
                            Text(
                              'City',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              userData['city'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Row(
                          children: [
                            Text(
                              'Street name',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              userData['st_name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Row(
                          children: [
                            Text(
                              'Building number',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              userData['building_number'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Row(
                          children: [
                            Text(
                              'Postal code',
                              style: TextStyle(color: basicColor),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          children: [
                            Text(
                              userData['postal_code'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Container(
                          width: double.infinity,
                          height: height * .0005,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: height * .05,
                left: width * .05,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    color: basicColor,
                    shadows: [Shadow(color: Colors.white, blurRadius: 3)],
                    size: width * .07,
                  ),
                ),
              ),
            ],
          );
        },
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
