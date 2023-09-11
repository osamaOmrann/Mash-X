import 'package:flutter/material.dart';

class JobOfferWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(right: width * .05),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(width * .021),
            child: Container(
              width: height * .05,
                height: height * .05,
                child: Image.asset('assets/images/company.jpg', fit: BoxFit.cover,)),
          ),
          SizedBox(width: width * .025,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company name'),
              SizedBox(height: height * .01,),
              Text('Job title ...', style: TextStyle(color: Colors.grey),),
            ],
          )
        ],
      ),
    );
  }
}
