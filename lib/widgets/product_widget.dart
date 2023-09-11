import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/product.dart';

class ProductWidget extends StatelessWidget {
  Product product;
  ProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ClipRRect(
          /*borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .1),*/
          child: product.image == null
              ? ClipRRect(
            /*borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * .1),*/
            child: Image.asset(
              'assets/images/product.webp',
              width: width * .45,
              // height: MediaQuery.of(context).size.height * .2,
              fit: BoxFit.cover,
            ),
          )
              : ClipRRect(
            /*borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * .1),*/
            child: CachedNetworkImage(
              width: width * .45,
              height: width * .45,
              // height: height * .45,
              fit: BoxFit.cover,
              imageUrl: product.image ?? '',
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const CircleAvatar(
                  child: Icon(CupertinoIcons.info_circle_fill)),
            ),
          ),
        ),
      ],
    );
  }
}
