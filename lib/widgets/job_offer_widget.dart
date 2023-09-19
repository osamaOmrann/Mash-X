import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mash/models/job.dart';

class JobOfferWidget extends StatelessWidget {
  Job job;
  JobOfferWidget(this.job);

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
                child: CachedNetworkImage(
                  imageUrl: job.companyImage ?? '',
                  fit: BoxFit.contain,
                )),
          ),
          SizedBox(width: width * .025,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.companyName ?? ''),
              Text(job.jobTitle ?? '', style: TextStyle(color: Colors.grey),),
            ],
          )
        ],
      ),
    );
  }
}
