import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/main.dart';
import 'package:mash/models/company.dart';
import 'package:mash/screens/complete_user_date.dart';
import 'package:mash/widgets/home_bottom_sheet.dart';
import 'package:mash/widgets/job_card.dart';
import 'package:mash/widgets/job_offer_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userImage = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  Future<void> _getValues() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(DataBase.user.uid)
        .get();
    var data = documentSnapshot.data();
    userImage = await data!['image_url'];
    bool completeData = data['phone_number'] != null &&
        data['phone_number'] != 'null' &&
        data['phone_number'] != '' &&
        data['image_url'] !=
            'https://cdn-icons-png.flaticon.com/512/149/149071.png' &&
        data['birth_date'] != null &&
        data['city'] != null &&
        data['city'] != 'null' &&
        data['city'] != '' &&
        data['st_name'] != null &&
        data['st_name'] != 'null' &&
        data['st_name'] != '' &&
        data['building_number'] != null &&
        data['building_number'] != 0 &&
        data['postal_code'] != null &&
        data['postal_code'] != 'null' &&
        data['postal_code'] != '';
    if (completeData == false) nextScreenReplace(context, CompleteUserData());
  }

  @override
  void initState() {
    super.initState();
    _getValues();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: height * .11,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .02),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Mash',
                      style: TextStyle(
                          color: Color(0xff98a6f3),
                          fontSize: width * .061,
                          fontFamily: 'backHome',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' X',
                      style:
                          TextStyle(fontSize: width * .0661, color: Colors.red),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) => HomeBottomSheet(userImage));
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Color(0xff98a6f3),
                          size: width * .09,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .02),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(),
                        hintText: 'Search Here',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(width * .07))),
                  ),
                  SizedBox(
                    height: height * .015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          log(sp.firebaseAuth.currentUser!.phoneNumber ?? '');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * .05, vertical: height * .01),
                          decoration: BoxDecoration(
                              color: basicColor,
                              borderRadius: BorderRadius.circular(width * .05)),
                          child: Text(
                            'Kl-Suche',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * .05, vertical: height * .01),
                        decoration: BoxDecoration(
                            color: basicColor,
                            borderRadius: BorderRadius.circular(width * .05)),
                        child: Text(
                          'Fähigkeit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * .05, vertical: height * .01),
                        decoration: BoxDecoration(
                            color: basicColor,
                            borderRadius: BorderRadius.circular(width * .05)),
                        child: Text(
                          'Kategorie',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * .025,
            ),
            SizedBox(
              height: height * .19,
              child: StreamBuilder<QuerySnapshot<Company>>(
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
                    height: height * .19,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (buildContext, index) {
                        return data.isEmpty
                            ? Center(
                          child: Text(
                            'No companies',
                            style: TextStyle(
                                color: basicColor,
                                fontSize: 30),
                          ),
                        )
                            : CachedNetworkImage(imageUrl: data[index].image?? '');
                      },
                      itemCount: data!.length,
                    ),
                  );
                },
                stream: DataBase.listenForCompaniesRealTimeUpdatesStream(),
              ),
            ),
            SizedBox(
              height: height * .025,
            ),
            Text(
              'Neue Angebote:',
              style: TextStyle(fontSize: width * .05),
            ),
            SizedBox(
              height: height * .025,
            ),
            SizedBox(
              height: height * .07,
              child: StreamBuilder<QuerySnapshot<Company>>(
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
                    height: height * .19,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (buildContext, index) {
                        return data.isEmpty
                            ? Center(
                          child: Text(
                            'No companies',
                            style: TextStyle(
                                color: basicColor,
                                fontSize: 30),
                          ),
                        )
                            : JobOfferWidget(Company());
                      },
                      itemCount: data!.length,
                    ),
                  );
                },
                stream: DataBase.listenForCompaniesRealTimeUpdatesStream(),
              ),
            ),
            SizedBox(
              height: height * .025,
            ),
            Text(
              'eine Woche Arbeit:',
              style: TextStyle(fontSize: width * .05),
            ),
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(DataBase.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error loading data try again later');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 21,
                    itemBuilder: (context, index) {
                      return JobCard(userData['image_url']);
                    });
              },
            ))
          ],
        ),
      ),
    );
  }
}
