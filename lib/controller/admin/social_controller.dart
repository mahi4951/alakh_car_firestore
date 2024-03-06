// lib/controller/social_controller.dart
import 'package:alakh_car/models/admin/social.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialController {
  final CollectionReference socialCollection =
      FirebaseFirestore.instance.collection('Social');

  Future<void> addSocial(SocialModel newSocial, String id) async {
    Map<String, dynamic> socialMap = newSocial.toMap();
    // Add or update banner in Firestore
    await socialCollection.doc(id).set(socialMap);
  }

  // Read all socials

  Stream<List<SocialModel>> getSocials() {
    return socialCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              SocialModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<SocialModel>> getFutureSocials() async {
    try {
      final snapshot = await socialCollection.get();

      return snapshot.docs
          .map((doc) =>
              SocialModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Handle any errors, such as network errors or Firestore exceptions
      print('Error fetching banners: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<SocialModel>> loadSocials() async {
    try {
      Stream<List<SocialModel>> socialsStream = getSocials();

      return await socialsStream.first;
    } catch (e) {
      print('Error loading brands: $e');
      return [];
    }
  }

  Future<void> updateSocial(SocialModel social, String id) async {
    Map<String, dynamic> socialMap = social.toMap();
    await socialCollection.doc(id).update(socialMap);
  }
}
