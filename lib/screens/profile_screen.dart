import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/main.dart';
import 'package:mash/models/rate.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage(this.userId);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  String? _picked_image;

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
              if (snapshot.hasError) {
                return Text('error loading data try again later');
              }

              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
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

              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                                height: height * .45,
                                width: width,
                                fit: BoxFit.cover,
                                imageUrl: userData['image_url']),
                            SizedBox(
                              height: height * .05,
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
                                            color: basicColor,
                                            fontSize: width * .039),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * .05,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: width * .85,
                                        padding: EdgeInsets.symmetric(vertical: 5),
                                          color: Colors.grey,
                                          child: Text('rates: ${userData['rates']}', overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  StreamBuilder<QuerySnapshot<Rate>>(
                                    builder: (buildContext, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                              'Error loading date try again later'),
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
                                      return ListView.builder(
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
                                              : Center(
                                                  child: Text(
                                                  data[index].comment ?? 'null',
                                                  style: TextStyle(
                                                      fontSize: 100,
                                                      color: Colors.black),
                                                ));
                                        },
                                        itemCount: data!.length,
                                      );
                                    },
                                    // future: MyDataBase.getAllMissingPersons(),
                                    stream: DataBase.listenForRatesRealTimeUpdates(
                                        userData['rates']),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: width * .065),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Email', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(userData['email'], style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                  SizedBox(height: height * .021,),
                                  Row(
                                    children: [
                                      Text('Birth date', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(
                                    '${DateTime.fromMillisecondsSinceEpoch(userData['birth_date']).day}/${DateTime.fromMillisecondsSinceEpoch(userData['birth_date']).month}/${DateTime.fromMillisecondsSinceEpoch(userData['birth_date']).year}', style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                  SizedBox(height: height * .021,),
                                  Row(
                                    children: [
                                      Text('Phone number', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(userData['phone_number'], style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                  SizedBox(height: height * .021,),
                                  Row(
                                    children: [
                                      Text('City', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(userData['city'], style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                  SizedBox(height: height * .021,),
                                  Row(
                                    children: [
                                      Text('Street name', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(userData['st_name'], style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                  SizedBox(height: height * .021,),
                                  Row(
                                    children: [
                                      Text('Building number', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(userData['building_number'].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                  SizedBox(height: height * .021,),
                                  Row(
                                    children: [
                                      Text('Postal code', style: TextStyle(color: basicColor),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Row(
                                    children: [
                                      Text(userData['postal_code'], style: TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: height * .01,),
                                  Container(width: double.infinity, height: height * .0005, color: Colors.grey,),
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                            right: width * .05,
                            top: height * .419,
                            child: FloatingActionButton(
                              backgroundColor: basicColor,
                              onPressed: () {_showBottomSheet(context);},
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
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