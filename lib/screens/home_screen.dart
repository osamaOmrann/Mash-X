import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/calculate_distance.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/main.dart';
import 'package:mash/models/company.dart';
import 'package:mash/models/job.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:mash/screens/complete_user_date.dart';
import 'package:mash/screens/profile_screen.dart';
import 'package:mash/screens/settings_screen.dart';
import 'package:mash/screens/store_screen.dart';
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
        .doc(DataBase.user?.uid)
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
    if (FirebaseAuth.instance.currentUser == null)
      nextScreenReplace(context, LoginScreen());
    _getValues();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(DataBase.user?.uid)
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
                              'Mash ',
                              style: TextStyle(
                                  color: Color(0xff98a6f3),
                                  fontSize: width * .061,
                                  fontFamily: 'foxescookies',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'X',
                              style: TextStyle(
                                  fontSize: width * .085,
                                  color: Colors.red,
                                  fontFamily: 'denala',
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  showStickyFlexibleBottomSheet(
                                    bottomSheetColor: Colors.white,
                                    minHeight: 0,
                                    initHeight: 0.7,
                                    maxHeight: 1,
                                    headerHeight: 200,
                                    context: context,
                                    headerBuilder:
                                        (BuildContext context, double offset) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: width * .039,
                                            right: width * .039,
                                            top: height * .021),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * .03,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    nextScreen(
                                                        context,
                                                        UserProfilePage(
                                                            DataBase.user!.uid));
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage:
                                                        NetworkImage(userImage),
                                                    radius: width * .061,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: width * 0.09,
                                                  width: width * .05,
                                                ),
                                                Container(
                                                  height: width * 0.09,
                                                  width: width * .003,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(height: width * 0.09),
                                                SizedBox(
                                                  width: width * .065,
                                                ),
                                                Image.asset(
                                                  'assets/images/cs.png',
                                                  width: width * .081,
                                                ),
                                                SizedBox(
                                                  width: width * .065,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      nextScreen(
                                                          context, StoreScreen());
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/bag.png',
                                                      width: width * .081,
                                                    )),
                                                SizedBox(
                                                  width: width * .061,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      nextScreen(context,
                                                          Settings_Screen());
                                                    },
                                                    child: Icon(
                                                      Icons.settings,
                                                      color: Color(0xff3392ee),
                                                      size: width * .09,
                                                    )),
                                                SizedBox(
                                                  width: width * .06,
                                                ),
                                                Image.asset(
                                                  'assets/images/telegram.png',
                                                  width: width * .081,
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(
                                                      CupertinoIcons.chevron_down,
                                                      color: Color(0xff96a8f1),
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * .035,
                                            ),
                                            Text('    Wählen Sie Lhre Stadt'),
                                            SizedBox(
                                              height: height * .005,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * .05,
                                                  vertical: height * .01),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * .07)),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/location.png',
                                                    width: width * .065,
                                                  ),
                                                  Text(
                                                    'Adresse',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    bodyBuilder:
                                        (BuildContext context, double offset) {
                                      return SliverChildListDelegate(
                                        <Widget>[
                                          Text(
                                            'Menü:',
                                            style:
                                                TextStyle(fontSize: width * .055),
                                          ),
                                          SizedBox(
                                            height: height * .019,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: width * .039,
                                                right: width * .039,
                                                top: height * .021),
                                            child:
                                                StreamBuilder<QuerySnapshot<Job>>(
                                              builder: (buildContext, snapshot) {
                                                if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        'Error loading date try again later'),
                                                  );
                                                } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: basicColor),
                                                  );
                                                }
                                                var data = snapshot.data?.docs
                                                    .map((e) => e.data())
                                                    .toList();

                                                return SizedBox(
                                                  height: height * .75,
                                                  child: ListView(
                                                    children: [
                                                      for (int i = 0;
                                                          i < data!.length;
                                                          i++)
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: height *
                                                                      .017),
                                                          child: calculateDistance(
                                                          double.parse(data[i].lat ?? ''),
                                                double.parse(data[i].lng ?? ''),
                                                double.parse(userData['lat']),
                                                double.parse(userData['lng'])) <= 15?JobOfferWidget(
                                                              data[i]): Container(),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              stream: DataBase
                                                  .listenForJobsRealTimeUpdatesStream(),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                    anchors: [0, 0.5, 1],
                                  );
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
                                    borderRadius:
                                        BorderRadius.circular(width * .07))),
                          ),
                          SizedBox(
                            height: height * .015,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * .05,
                                    vertical: height * .01),
                                decoration: BoxDecoration(
                                    color: basicColor,
                                    borderRadius:
                                        BorderRadius.circular(width * .05)),
                                child: Text(
                                  'AI-Search',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * .05,
                                    vertical: height * .01),
                                decoration: BoxDecoration(
                                    color: basicColor,
                                    borderRadius:
                                        BorderRadius.circular(width * .05)),
                                child: Text(
                                  'Fähigkeit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * .05,
                                    vertical: height * .01),
                                decoration: BoxDecoration(
                                    color: basicColor,
                                    borderRadius:
                                        BorderRadius.circular(width * .05)),
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
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.down,
                          color: Colors.white,
                          child: ListView(
                            children: [
                              SizedBox(
                                height: height * .19,
                                child: StreamBuilder<QuerySnapshot<Company>>(
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
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * .05),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * .05),
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            data[index].image ??
                                                                ''),
                                                  ),
                                                );
                                        },
                                        itemCount: data!.length,
                                      ),
                                    );
                                  },
                                  stream: DataBase
                                      .listenForCompaniesRealTimeUpdatesStream(),
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
                                child: StreamBuilder<QuerySnapshot<Job>>(
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

                                    return SizedBox(
                                      height: height * .19,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (buildContext, index) {
                                          double jobDistance = calculateDistance(
                                              double.parse(data[index].lat ?? ''),
                                              double.parse(data[index].lng ?? ''),
                                              double.parse(userData['lat']),
                                              double.parse(userData['lng']));
                                          print(jobDistance);

                                          return data.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    'No jobs',
                                                    style: TextStyle(
                                                        color: basicColor,
                                                        fontSize: 30),
                                                  ),
                                                )
                                              : jobDistance <= 15.0? JobOfferWidget(data[index]): Container();
                                        },
                                        itemCount: data!.length,
                                      ),
                                    );
                                  },
                                  stream: DataBase
                                      .listenForJobsRealTimeUpdatesStream(),
                                ),
                              ),
                              SizedBox(
                                height: height * .025,
                              ),
                              Text(
                                'eine Woche Arbeit:',
                                style: TextStyle(fontSize: width * .05),
                              ),
                              SizedBox(
                                height: height * .015,
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(DataBase.user?.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                        'Error loading data try again later');
                                  }

                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: basicColor,
                                    ));
                                  }

                                  var userData = snapshot.data?.data()
                                      as Map<String, dynamic>;
                                  return Column(
                                    children: [
                                      for (int i = 0; i < 21; i++)
                                        JobCard(userData['image_url']),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
