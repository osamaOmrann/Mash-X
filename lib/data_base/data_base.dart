import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mash/data_base/product.dart';
import 'package:mash/models/my_user.dart';
import 'package:mash/models/rate.dart';

class DataBase {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => FirebaseAuth.instance.currentUser!;

  static CollectionReference<Product> getProductsCollection() {
    return FirebaseFirestore.instance
        .collection(Product.collectionName)
        .withConverter<Product>(fromFirestore: (snapshot, options) {
      return Product.fromFirestore(snapshot.data()!);
    }, toFirestore: (p, options) {
      return p.toFirestore();
    });
  }

  static Stream<QuerySnapshot<Product>> listenForProductsRealTimeUpdates() {
    // Listen for realtime update
    return getProductsCollection()
        .orderBy("date", descending: true)
        .snapshots();
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extensions: $ext');
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    String image = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'image_url': image});
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return firestore.collection('users').withConverter<MyUser>(
        fromFirestore: ((snapshot, options) {
      return MyUser.fromFireStore(snapshot.data()!);
    }), toFirestore: (user, options) {
      return user.toFireStore();
    });
  }

  static updateUserData(String userId, String field, var value) async {
    CollectionReference mashXRef = getUsersCollection();
    mashXRef.doc(userId).update({field: value});
  }

  static CollectionReference<Rate> getRatesCollection() {
    return FirebaseFirestore.instance
        .collection(Rate.collectionName)
        .withConverter<Rate>(fromFirestore: (snapshot, options) {
      return Rate.fromFireStore(snapshot.data()!);
    }, toFirestore: (rate, options) {
          log(rate.toString());
      return rate.toFireStore();
    });
  }

  static Stream<QuerySnapshot<Rate>> listenForRatesRealTimeUpdates(ratesIds) {
    // Listen for realtime update
    return getRatesCollection()/*.where("id", whereIn: ratesIds)*/.snapshots();
  }
}
