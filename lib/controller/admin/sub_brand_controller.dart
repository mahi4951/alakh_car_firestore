// lib/controller/color_controller.dart
import 'package:alakh_car/models/admin/subbrand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubBrandController {
  final CollectionReference subBrandCollection =
      FirebaseFirestore.instance.collection('SubBrands');

  Future<void> addSubBrand(SubBrandModel newSubBrand, String id) async {
    Map<String, dynamic> subBrandMap = newSubBrand.toMap();

    // Add or update brand in Firestore
    await subBrandCollection.doc(id).set(subBrandMap);
  }

  Stream<List<SubBrandModel>> getSubBrands() {
    return subBrandCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              SubBrandModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<SubBrandModel>> getSubBrand(String mainBrandName) {
    return subBrandCollection
        .where("MainBrand", isEqualTo: mainBrandName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              SubBrandModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<SubBrandModel>> loadSubBrands(String? mainBrandName) async {
    try {
      Stream<List<SubBrandModel>> subBrandsStream = getSubBrand(mainBrandName!);

      return await subBrandsStream.first;
    } catch (e) {
      print('Error loading brands: $e');
      return [];
    }
  }

  Future<void> updateSubBrand(SubBrandModel newSubBrand, String id) async {
    Map<String, dynamic> subBrandMap = newSubBrand.toMap();
    await subBrandCollection.doc(id).update(subBrandMap);
  }

  // Delete a color
  Future<void> deleteSubBrand(String id) async {
    await subBrandCollection.doc(id).delete();
  }
}
