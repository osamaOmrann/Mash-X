import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {

  String image;
  JobCard(this.image);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .11,
      child: Card(
        margin: EdgeInsets.only(left: width * .03, right: width * .03, bottom: height * .015),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * .05)
        ),
        elevation: 5,
        child: Center(
          child: ListTile(
            dense: false,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: width * .07,
            ),
            title: Padding(
              padding: EdgeInsets.only(bottom: height * .01),
              child: Text('Company name'),
            ),
            subtitle: Text('Here is job title and infos'),
          ),
        ),
      ),
    );
  }
}
