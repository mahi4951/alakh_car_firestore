// lib/controller/car_controller.dart
import 'dart:io';
import 'package:alakh_car/models/admin/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class CarController {
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('Cars');

  Future<void> addCar(
      CarModel newCar, String id, List<String>? imagesUrls) async {
    Map<String, dynamic> carMap = newCar.toMap();
    // Add or update car in Firestore
    await carsCollection.doc(id).set(carMap);
  }

  // Read all cars
  Stream<List<CarModel>> getCars() {
    return carsCollection
        .orderBy("CarName", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              CarModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<CarModel>> getFiltredCars(String filterKey) {
    return carsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              CarModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .where((car) {
        final carPrice =
            int.tryParse(car.carPrice?.replaceAll(',', '') ?? '0') ?? 0;
        final filterPrice = int.tryParse(filterKey.replaceAll(',', '')) ?? 0;

        if (filterKey == '200000') {
          return (carPrice < filterPrice && car.status != 'Coming Soon');
        } else if (filterKey == '200001') {
          return (carPrice >= filterPrice &&
              carPrice < 300001 &&
              car.status != 'Coming Soon');
        } else if (filterKey == '300001') {
          return (carPrice >= filterPrice &&
              carPrice < 400001 &&
              car.status != 'Coming Soon');
        } else if (filterKey == '400001') {
          return (carPrice >= 400001 && car.status != 'Coming Soon');
        } else {
          return (car.status == filterKey) ||
              (car.gear == filterKey && car.status != 'Coming Soon') ||
              (car.subBrandName == filterKey && car.status != 'Coming Soon') ||
              (car.fuelName == filterKey && car.status != 'Coming Soon') ||
              (car.brandName == filterKey && car.status != 'Coming Soon');
        }
      }).toList();
    });
  }

  Future<List<CarModel>> getFeaturedFilteredCars(String filterKey) async {
    final snapshot = await carsCollection.snapshots().first;
    return snapshot.docs
        .map((doc) => CarModel.fromSnapshot(doc.data() as Map<String, dynamic>))
        .where((car) =>
            (car.brandName == filterKey && car.status != 'Coming Soon') ||
            (car.fuelName == filterKey && car.status != 'Coming Soon'))
        .toList();
  }

  Future<CarModel> fetchCar(String id) async {
    try {
      // Query Firestore to get the document with the provided ID
      DocumentSnapshot carSnapshot = await carsCollection.doc(id).get();

      // If the document exists, create a CarModel instance from the data
      if (carSnapshot.exists) {
        return CarModel.fromSnapshot(
            carSnapshot.data() as Map<String, dynamic>);
      } else {
        // If the document doesn't exist, throw an exception
        throw Exception('Car not found with id: $id');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print('Error fetching car: $e');
      rethrow; // Rethrow the error to be handled by the caller if necessary
    }
  }

  Stream<CarModel> fetchCars(String id) {
    return carsCollection.snapshots().map((snapshot) {
      final carList = snapshot.docs
          .map((doc) =>
              CarModel.fromSnapshot(doc.data() as Map<String, dynamic>))
          .where((car) => car.id == id)
          .toList();

      // If a car is found with the provided id, return it; otherwise, return null
      if (carList.isNotEmpty) {
        return carList.first;
      } else {
        // If car with the provided id is not found, return null
        throw Exception('Car not found with id: $id');
      }
    });
  }

  Future<void> updateCar(CarModel car, String id) async {
    Map<String, dynamic> carMap = car.toMap();
    await carsCollection.doc(id).update(carMap);
  }

  Future<List<String>?> uploadImages(List<File> images, String carId) async {
    List<String>? imagesUrls;

    // Await the result of the stream to get the list of image URLs
    List<String>? existingImages = await getCarImages(carId).first;

    // If there are existing images, assign them to imagesUrls
    imagesUrls = List<String>.from(existingImages);

    // If there are no existing images, initialize imagesUrls to an empty list

    for (File image in images) {
      try {
        Reference refRoot = FirebaseStorage.instance.ref();
        Reference refDir = refRoot.child('Cars/$carId');
        String imageName = randomAlphaNumeric(10);
        Reference refImgToUpload = refDir.child(imageName);
        await refImgToUpload.putFile(
          image,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        // Retrieve the download URL for the uploaded file
        String downloadURL = await refImgToUpload.getDownloadURL();
        imagesUrls.add(downloadURL);
      } catch (e) {
        print('Error uploading image: $e');
        imagesUrls.add('');
      }
    }

    return imagesUrls;
  }

  Future<List<String>?> getCarImageUrl(String carId) async {
    try {
      DocumentSnapshot carSnapshot = await FirebaseFirestore.instance
          .collection('Cars/$carId') // Replace with your actual collection name
          .doc(carId)
          .get();

      if (carSnapshot.exists) {
        // Explicitly cast 'data()' to Map<String, dynamic>
        var data = carSnapshot.data() as Map<String, dynamic>?;

        // Check if the 'imageUrl' field is present and not null in the document
        var imagesUrls = data?['imageUrl'] as List<String>?;
        return imagesUrls;
      }
      return null;
    } catch (error) {
      print('Error getting car image URL: $error');
      return null;
    }
  }

  Stream<List<String>> getCarImages(String id) {
    return carsCollection.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return []; // Return an empty list if the document doesn't exist
      }
      var data = snapshot.data() as Map<String, dynamic>;
      if (!data.containsKey('ImagesUrls')) {
        return []; // Return an empty list if the 'images' field doesn't exist
      }
      var imagesData = data['ImagesUrls'] as List<dynamic>;
      return imagesData.cast<String>().toList(); // Cast to List<String>
    });
  }

//  Future<List<Uint8List>> getImageBytes(String carId) async {
//   List<Uint8List> imageBytesList = [];

//   try {
//     // Get a reference to the car's folder in Firebase Storage
//     Reference storageRef = FirebaseStorage.instance.ref('Cars/$carId');

//     // List all items (images) in the folder
//     ListResult result = await storageRef.listAll();

//     // Iterate over each item in the result
//     for (Reference ref in result.items) {
//       // Get the download URL for the image
//       String downloadUrl = await ref.getDownloadURL();

//       // Download the image bytes
//       Uint8List imageBytes = await _downloadImageBytes(downloadUrl);

//       // Add the image bytes to the list
//       imageBytesList.add(imageBytes);
//     }

//     print('All images for car $carId downloaded successfully');
//   } catch (e) {
//     print('Error downloading car images: $e');
//   }

//   return imageBytesList;
// }

// // Helper function to download image bytes from URL
// Future<Uint8List> _downloadImageBytes(String imageUrl) async {
//   try {
//     // Create a HttpClient
//     final HttpClient httpClient = HttpClient();

//     // Open a URL
//     final HttpClientRequest request = await httpClient.getUrl(Uri.parse(imageUrl));

//     // Close the request
//     final HttpClientResponse response = await request.close();

//     // Read the bytes from the response
//     final Uint8List bytes = await consolidateHttpClientResponseBytes(response);

//     // Close the HttpClient
//     httpClient.close();

//     return bytes;
//   } catch (e) {
//     print('Error downloading image: $e');
//     return Uint8List(0);
//   }
// }

  Future<void> deleteCarImages(String carId) async {
    try {
      // Get a reference to the car's folder in Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref('Cars/$carId');

      // List all items (images) in the folder
      ListResult result = await storageRef.listAll();

      // Delete each item (image) in the folder
      for (Reference ref in result.items) {
        await ref.delete();
      }

      // Optionally, you can also delete the car's folder itself
      // await storageRef.delete();

      print('All images for car $carId deleted successfully');
    } catch (e) {
      print('Error deleting car images: $e');
    }
  }

  Future<void> deleteCarImg(String carId, String imgUrl) async {
    try {
      // Get a reference to the car's folder in Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref('Cars/$carId');

      // List all items (images) in the folder
      ListResult result = await storageRef.listAll();

      // Delete each item (image) in the folder
      for (Reference ref in result.items) {
        String imgurl = await ref.getDownloadURL();

        if (imgurl == imgUrl) {
          await ref.delete();
        }
      }

      DocumentReference carDocRef = carsCollection.doc(carId);
      DocumentSnapshot carDoc = await carDocRef.get();
      // Optionally, you can also delete the car's folder itself
      // await storageRef.delete();
      Map<String, dynamic>? carData = carDoc.data() as Map<String, dynamic>?;
      if (carData != null) {
        // Update the array of ImageUrl to remove imgUrl
        List<String> imagesUrls =
            List<String>.from(carData['ImagesUrls'] ?? []);
        imagesUrls.remove(imgUrl);

        // Update the document with the modified array
        await carDocRef.update({'ImagesUrls': imagesUrls});

        print('All images for car $carId deleted successfully');
      } else {
        print('Car data is null');
      }

      // Update the document with the modified array
      //await carDocRef.update({'ImageUrls': imagesUrls});

      print('All images for car $carId deleted successfully');
    } catch (e) {
      print('Error deleting car images: $e');
    }
  }

  // Delete a car
  Future<void> deleteCar(String carId) async {
    await carsCollection.doc(carId).delete();
  }

  Future<void> updateLocation(String location, String id) async {
    try {
      // Update the document in Firestore
      await FirebaseFirestore.instance
          .collection('Cars')
          .doc(id)
          .update({'Location': location});
      print('Location updated successfully.');
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> updateImageUrls(List<String>? imagesUrls, String id) async {
    try {
      // Update the document in Firestore
      await FirebaseFirestore.instance
          .collection('Cars')
          .doc(id)
          .update({'ImagesUrls': imagesUrls});
      print('Image URLs updated successfully.');
    } catch (e) {
      print('Error updating image URLs: $e');
    }
  }

  final CollectionReference newcarsCollection =
      FirebaseFirestore.instance.collection('Cars');
  Future<void> addNewCar(CarModel newCar, String id) async {
    Map<String, dynamic> carMap = newCar.toMap();
    // Add or update car in Firestore
    await newcarsCollection.doc(id).set(carMap);
  }
}
