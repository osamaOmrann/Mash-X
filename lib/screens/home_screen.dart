import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/helpers/next_screen.dart';
import 'package:mash/main.dart';
import 'package:mash/widgets/home_bottom_sheet.dart';
import 'package:mash/screens/auth/login_screen.dart';
import 'package:mash/widgets/job_card.dart';
import 'package:mash/widgets/job_offer_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
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
                    Text('Mash', style: TextStyle(color: Color(0xff98a6f3), fontSize: width * .061, fontFamily: 'backHome', fontWeight: FontWeight.bold),),
                    Text(' X', style: TextStyle(fontSize: width * .0661, color: Colors.red),),
                    Spacer(),
                    IconButton(onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                          context: context, builder: (_) => HomeBottomSheet());
                    }, icon: Icon(Icons.menu, color: Color(0xff98a6f3), size: width * .09,))
                  ],
                ),
              ),
            ),
            SizedBox(height: height * .03,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .02),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(),
                      hintText: 'Search Here',
                      prefixIcon: Icon(Icons.search, color: Colors.black,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(width * .07)
                      )
                    ),
                  ),
                  SizedBox(height: height * .015,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * .05, vertical: height * .01),
                        decoration: BoxDecoration(
                          color: basicColor,
                          borderRadius: BorderRadius.circular(width * .05)
                        ),
                        child: Text('Kl-Suche', style: TextStyle(color: Colors.white),),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * .05, vertical: height * .01),
                        decoration: BoxDecoration(
                          color: basicColor,
                          borderRadius: BorderRadius.circular(width * .05)
                        ),
                        child: Text('Fähigkeit', style: TextStyle(color: Colors.white),),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * .05, vertical: height * .01),
                        decoration: BoxDecoration(
                          color: basicColor,
                          borderRadius: BorderRadius.circular(width * .05)
                        ),
                        child: Text('Kategorie', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: height * .025,),
            SizedBox(
              height: height * .19,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 21,
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: width * .03),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(width * .05),
                        child: Image.asset('assets/images/company.jpg', width: width * .41, fit: BoxFit.cover )),
                  );
                  }),
            ),
            SizedBox(height: height * .025,),
            Text('Neue Angebote:', style: TextStyle(fontSize: width * .05),),
            SizedBox(height: height * .025,),
            SizedBox(height: height * .05,
              child: ListView.builder(
                padding: EdgeInsets.only(left: width * .045),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                return JobOfferWidget();
              }, itemCount: 21,),
            ),
            SizedBox(height: height * .025,),
            Text('eine Woche Arbeit:', style: TextStyle(fontSize: width * .05),),
            Expanded(child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 21,
                itemBuilder: (context, index) {
              return JobCard(sp.imageUrl ?? '');
            }))
          ],
        ),
      ),
    );
  }
}
