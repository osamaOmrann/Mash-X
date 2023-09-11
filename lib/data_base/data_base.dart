import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mash/data_base/product.dart';

class DataBase {

  static CollectionReference<Product> getProductsCollection() {
    return FirebaseFirestore.instance
        .collection(Product.collectionName)
        .withConverter<Product>(fromFirestore: (snapshot, options) {
      return Product.fromFirestore(snapshot.data()!);
    }, toFirestore: (p, options) {
      return p.toFirestore();
    });
  }

  static Stream<QuerySnapshot<Product>>
  listenForProductsRealTimeUpdates() {
    // Listen for realtime update
    return getProductsCollection()
        .orderBy("date", descending: true)
        .snapshots();
  }
}