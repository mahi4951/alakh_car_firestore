// lib/controller/color_controller.dart
import 'package:alakh_car/models/admin/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ColorController {
  final CollectionReference colorsCollection =
      FirebaseFirestore.instance.collection('Colors');

  Future<void> addColor(ColorModel newColor, String id) async {
    // Convert ColorModel to Map
    Map<String, dynamic> colorMap = newColor.toMap();
    // Add or update color in Firestore
    await colorsCollection.doc(id).set(colorMap);
  }

  // Read all colors
  Stream<List<ColorModel>> getColors() {
    return colorsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ColorModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<ColorModel>> loadColors() async {
    try {
      Stream<List<ColorModel>> colorsStream = getColors();

      return await colorsStream.first;
    } catch (e) {
      print('Error loading brands: $e');
      return [];
    }
  }

  Future<void> updateColor(ColorModel color, id) async {
    Map<String, dynamic> colorMap = color.toMap();
    await colorsCollection.doc(id).update(colorMap);
  }

  // Delete a color
  Future<void> deleteColor(String colorId) async {
    await colorsCollection.doc(colorId).delete();
  }
}
