import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mash/data_base/data_base.dart';
import 'package:mash/data_base/product.dart';
import 'package:mash/main.dart';
import 'package:mash/widgets/product_widget.dart';

class StoreScreen extends StatefulWidget {

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Product>>(
      builder: (buildContext, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
                'Error loading data try again later'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: width * .05,
              width: width * .05,
                child: CircularProgressIndicator(color: basicColor)),
          );
        }
        var data = snapshot.data?.docs.map((e) => e.data()).toList();
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(height * .045), // here the desired height
              child: AppBar(
                backgroundColor: basicColor,
                title: Text('MashX Store 🔥'),
              )
          ),
          body: RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
            color: basicColor,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .7,
                  crossAxisCount: 2),
              physics: BouncingScrollPhysics(),
              itemBuilder: (buildContext, index) {
                return data.isEmpty
                    ? Center(
                  child: Text(
                    'No products yet',
                    style: TextStyle(
                        color: basicColor, fontSize: 30),
                  ),
                )
                    : InkWell(
                    onTap: () {
                      print(data[index].id);
                      },
                    child: ProductWidget(data[index]));
              },
              itemCount: data!.length,
            ),
          ),
        );
      },
      stream: DataBase.listenForProductsRealTimeUpdates(),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
    return null;
  }
}