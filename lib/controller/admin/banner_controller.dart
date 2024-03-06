// lib/controller/banner_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:alakh_car/models/admin/banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BannerController {
  final CollectionReference bannersCollection =
      FirebaseFirestore.instance.collection('Banners');

  Future<void> addBanner(
      BannerModel newBanner, String id, String? imageUrl) async {
    Map<String, dynamic> bannerMap = newBanner.toMap();

    // Include image URL in the map
    if (imageUrl != null) {
      bannerMap['ImageUrl'] = imageUrl;
    }

    // Add or update banner in Firestore
    await bannersCollection.doc(id).set(bannerMap);
  }

  // Read all banners

  Stream<List<BannerModel>> getBanners() {
    return bannersCollection
        .orderBy("BannerName", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              BannerModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<BannerModel>> getFutureBanners() {
    return bannersCollection
        .orderBy("BannerName", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              BannerModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<QuerySnapshot> getBanner() {
    return bannersCollection
        .orderBy("BannerName", descending: false)
        .snapshots();
  }
  // Future<List<BannerModel>> getFutureBanners() async {
  //   try {
  //     final snapshot = await bannersCollection
  //         .orderBy("BannerName", descending: false)
  //         .get();

  //     return snapshot.docs
  //         .map((doc) =>
  //             BannerModel.fromSnapshot(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     // Handle any errors, such as network errors or Firestore exceptions
  //     print('Error fetching banners: $e');
  //     return []; // Return an empty list in case of an error
  //   }
  // }

  // Future<List<BannerModel>> getBannersAsFuture() async {
  //   // Create a Completer to wait for the stream to emit its first value
  //   final completer = Completer<List<BannerModel>>();

  //   late StreamSubscription<List<BannerModel>> subscription;

  //   // Subscribe to the stream
  //   subscription = getBanners().listen(
  //     (List<BannerModel> banners) {
  //       completer.complete(banners);
  //       // Cancel the subscription after receiving the first result
  //       subscription.cancel();
  //     },
  //     onError: (error) {
  //       completer.completeError(error);
  //       // Cancel the subscription if an error occurs
  //       subscription.cancel();
  //     },
  //   );

  //   return completer.future;
  // }

  Future<void> updateBanner(
      BannerModel banner, String id, String? imageUrl) async {
    Map<String, dynamic> bannerMap = banner.toMap();

    // Include image URL in the map
    if (imageUrl != null) {
      bannerMap['ImageUrl'] = imageUrl;
    }

    await bannersCollection.doc(id).update(bannerMap);
  }

  Future<String?> uploadImage(File image, String bannerId) async {
    try {
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference refDir = refRoot.child('Banners/$bannerId');
      Reference refImgToUpload = refDir.child(bannerId);

      await refImgToUpload.putFile(
          image, SettableMetadata(contentType: 'image/jpeg'));
      // Retrieve the download URL for the uploaded file
      String downloadURL = await refImgToUpload.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteBannerImg(String bannerId) async {
    Reference storageRefs =
        FirebaseStorage.instance.ref('Banners/$bannerId').child(bannerId);
    await storageRefs.delete();
  }

  // Delete a banner
  Future<void> deleteBanner(String bannerId) async {
    await bannersCollection.doc(bannerId).delete();
  }
}
