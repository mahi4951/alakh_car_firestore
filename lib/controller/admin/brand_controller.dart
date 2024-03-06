// lib/controller/brand_controller.dart
import 'dart:io';

import 'package:alakh_car/models/admin/brand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BrandController {
  final CollectionReference brandsCollection =
      FirebaseFirestore.instance.collection('Brands');

  Future<void> addBrand(
      BrandModel newBrand, String id, String? imageUrl) async {
    Map<String, dynamic> brandMap = newBrand.toMap();

    // Include image URL in the map
    if (imageUrl != null) {
      brandMap['ImageUrl'] = imageUrl;
    }

    // Add or update brand in Firestore
    await brandsCollection.doc(id).set(brandMap);
  }

  // Read all brands

  Stream<List<BrandModel>> getBrands() {
    return brandsCollection
        .orderBy("BrandOrder", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              BrandModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<QuerySnapshot> getBrand() {
    return brandsCollection
        .orderBy("BrandOrder", descending: false)
        .snapshots();
  }

  Future<List<BrandModel>> loadBrands() async {
    try {
      Stream<List<BrandModel>> brandsStream = getBrands();

      return await brandsStream.first;
    } catch (e) {
      print('Error loading brands: $e');
      return [];
    }
  }

  Future<BrandModel?> getBrandById(String id) async {
    try {
      // Assuming 'brands' is the name of your Firestore collection
      var brandDoc =
          await FirebaseFirestore.instance.collection('brands').doc(id).get();

      if (brandDoc.exists) {
        // Convert the data from the document to a BrandModel object
        return BrandModel.fromSnapshot(brandDoc.data() as Map<String, dynamic>);
      } else {
        // If the document with the specified ID does not exist
        return null;
      }
    } catch (e) {
      // Handle errors, such as Firestore request failure
      print('Error getting brand by ID: $e');
      return null;
    }
  }

  Future<void> updateBrand(
      BrandModel brand, String id, String? imageUrl) async {
    Map<String, dynamic> brandMap = brand.toMap();

    // Include image URL in the map
    if (imageUrl != null) {
      brandMap['ImageUrl'] = imageUrl;
    }

    await brandsCollection.doc(id).update(brandMap);
  }

  Future<String?> uploadImage(File image, String brandId) async {
    try {
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference refDir = refRoot.child('Brands/$brandId');
      Reference refImgToUpload = refDir.child(brandId);

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

  Future<String?> getBrandImageUrl(String brandId) async {
    try {
      DocumentSnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection(
              'Brands/$brandId') // Replace with your actual collection name
          .doc(brandId)
          .get();

      if (brandSnapshot.exists) {
        // Explicitly cast 'data()' to Map<String, dynamic>
        var data = brandSnapshot.data() as Map<String, dynamic>?;

        // Check if the 'imageUrl' field is present and not null in the document
        var imageUrl = data?['imageUrl'] as String?;
        return imageUrl;
      }
      return null;
    } catch (error) {
      print('Error getting brand image URL: $error');
      return null;
    }
  }

  Future<void> deleteBrandImg(String brandId) async {
    Reference storageRefs =
        FirebaseStorage.instance.ref('Brands/$brandId').child(brandId);
    await storageRefs.delete();
  }

  // Delete a brand
  Future<void> deleteBrand(String brandId) async {
    await brandsCollection.doc(brandId).delete();
  }
}
