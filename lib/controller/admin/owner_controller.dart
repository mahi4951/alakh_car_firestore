// lib/controller/owner_controller.dart
import 'package:alakh_car/models/admin/owner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerController {
  final CollectionReference ownerCollection =
      FirebaseFirestore.instance.collection('Owners');

  Future<void> addOwner(OwnerModel newOwner, String id) async {
    // Convert OwnerModel to Map
    Map<String, dynamic> ownerMap = newOwner.toMap();
    // Add or update owner in Firestore
    await ownerCollection.doc(id).set(ownerMap);
  }

  // Read all owner
  Stream<List<OwnerModel>> getOwners() {
    return ownerCollection
        .orderBy('Owners', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              OwnerModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<OwnerModel>> loadOwners() async {
    try {
      Stream<List<OwnerModel>> ownersStream = getOwners();

      return await ownersStream.first;
    } catch (e) {
      print('Error loading brands: $e');
      return [];
    }
  }

  Future<void> updateOwner(OwnerModel owner, id) async {
    Map<String, dynamic> ownerMap = owner.toMap();
    await ownerCollection.doc(id).update(ownerMap);
  }

  // Delete a owner
  Future<void> deleteOwner(String ownerId) async {
    await ownerCollection.doc(ownerId).delete();
  }
}
