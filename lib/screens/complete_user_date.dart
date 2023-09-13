import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/main.dart';
import 'package:provider/provider.dart';

class CompleteUserData extends StatefulWidget {
  @override
  State<CompleteUserData> createState() => _CompleteUserDataState();
}

class _CompleteUserDataState extends State<CompleteUserData> {
  String? _picked_image;
  String image = '';

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
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    SizedBox(height: height * .1,)
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: height * .3,
                  color: basicColor.withOpacity(.5),
                ),
                Positioned(
                  top: height * .25,
                    left: width * .321,
                    child: _picked_image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(height * .1),
                  child: Image.file(
                    File(_picked_image!),
                    width: height * .15,
                    height: height * .15,
                    fit: BoxFit.cover,
                  ),
                )
                    : ClipRRect(
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
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
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
            )
          ],
        ),
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
