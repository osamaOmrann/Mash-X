import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mash/models/product.dart';
import 'package:mash/main.dart';

class ProductWidget extends StatelessWidget {
  Product product;
  ProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(width * .01),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(width * .015),
            child: product.image == null
                ? ClipRRect(
                    /*borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .1),*/
                    child: Image.asset(
                      'assets/images/product.webp',
                      width: width * .43,
                      height: width * .43,
                      // height: MediaQuery.of(context).size.height * .2,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    /*borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .1),*/
                    child: CachedNetworkImage(
                      width: width * .43,
                      height: width * .43,
                      // height: height * .45,
                      fit: BoxFit.cover,
                      imageUrl: product.image ?? '',
                      placeholder: (context, url) => SizedBox(
                          height: width * .05,
                          width: width * .05,
                          child: CircularProgressIndicator(
                            color: basicColor,
                          )),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.info_circle_fill)),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .03),
            child: Column(
              children: [
                Text(
                  product.description ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(width),
                      child: product.publisher_image == null
                          ? ClipRRect(
                              /*borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * .1),*/
                              child: Image.asset(
                                'assets/images/person.png',
                                width: width * .05,
                                height: width * .05,
                                // height: MediaQuery.of(context).size.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              /*borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * .1),*/
                              child: CachedNetworkImage(
                                width: width * .05,
                                height: width * .05,
                                // height: height * .45,
                                fit: BoxFit.cover,
                                imageUrl: product.publisher_image ?? '',
                                placeholder: (context, url) => SizedBox(
                                    height: width * .05,
                                    width: width * .05,
                                    child: CircularProgressIndicator(
                                      color: basicColor,
                                    )),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(
                                            CupertinoIcons.info_circle_fill)),
                              ),
                            ),
                    ),
                    SizedBox(
                      width: width * .025,
                    ),
                    Text(
                      '${product.publisher_name ?? ''} ${product.date?.day ?? ''}/${product.date?.month ?? ''}/${product.date?.year ?? ''}',
                      style:
                          TextStyle(color: Colors.grey, fontSize: width * .025),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * .01, vertical: height * .005),
                  decoration: BoxDecoration(
                    color: Color(0xffeeeeee),
                    borderRadius: BorderRadius.circular(width * .05)
                  ),
                  child: Row(
                    children: [
                      Text('${product.price ?? ''}€', style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * .041),),
                      SizedBox(width: width * .01,),
                      Text('${((product.times_sold??0) / 1000).toStringAsFixed(0)}K+ sold', style: TextStyle(fontSize: width * .029, color: Colors.grey),),
                      Spacer(),
                      Icon(Icons.add_shopping_cart)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
