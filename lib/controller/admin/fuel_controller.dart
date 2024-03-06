// lib/controller/fual_controller.dart
import 'package:alakh_car/models/admin/fuel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuelController {
  final CollectionReference fuelCollection =
      FirebaseFirestore.instance.collection('Fuels');

  Future<void> addFuel(FuelModel newFuel, String id) async {
    // Convert FuelModel to Map
    Map<String, dynamic> fualMap = newFuel.toMap();
    // Add or update fual in Firestore
    await fuelCollection.doc(id).set(fualMap);
  }

  // Read all fuel
  Stream<List<FuelModel>> getFuels() {
    return fuelCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              FuelModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<FuelModel>> loadFuels() async {
    try {
      Stream<List<FuelModel>> fuelsStream = getFuels();

      return await fuelsStream.first;
    } catch (e) {
      print('Error loading brands: $e');
      return [];
    }
  }

  Future<void> updateFuel(FuelModel fual, id) async {
    Map<String, dynamic> fualMap = fual.toMap();
    await fuelCollection.doc(id).update(fualMap);
  }

  // Delete a fual
  Future<void> deleteFuel(String fualId) async {
    await fuelCollection.doc(fualId).delete();
  }
}
