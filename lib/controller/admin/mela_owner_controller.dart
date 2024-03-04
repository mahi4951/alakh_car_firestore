// lib/controller/melaOwner_controller.dart
import 'package:alakh_car/models/admin/melaowner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MelaOwnerController {
  final CollectionReference melaOwnerCollection =
      FirebaseFirestore.instance.collection('MelaOwners');

  Future<void> addMelaOwner(MelaOwnerModel newMelaOwner, String id) async {
    Map<String, dynamic> melaOwnerMap = newMelaOwner.toMap();
    await melaOwnerCollection.doc(id).set(melaOwnerMap);
  }

  Stream<List<MelaOwnerModel>> getMelaOwner() {
    return melaOwnerCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              MelaOwnerModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<MelaOwnerModel>> getFutureMelaOwner() async {
    try {
      final snapshot = await melaOwnerCollection
          .orderBy("location", descending: false)
          .get();

      return snapshot.docs
          .map((doc) =>
              MelaOwnerModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Handle any errors, such as network errors or Firestore exceptions
      print('Error fetching banners: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> updateMelaOwner(MelaOwnerModel melaOwner, String id) async {
    Map<String, dynamic> melaOwnerMap = melaOwner.toMap();
    await melaOwnerCollection.doc(id).update(melaOwnerMap);
  }
}
