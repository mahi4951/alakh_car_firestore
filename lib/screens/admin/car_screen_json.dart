import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:alakh_car/models/admin/car.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class JsonCarScreen extends StatefulWidget {
  @override
  _JsonCarScreenState createState() => _JsonCarScreenState();
}

class _JsonCarScreenState extends State<JsonCarScreen> {
  final CarController _carController = CarController();

  String? selectedCarId;
  // File? _image;
  List<String> imagesUrl = [];
  final focusNode = FocusNode();
  final focusNodefile = FocusNode();
  String? selectedSubBrandId;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add car from json'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _uploadJson,
            label: const Text("Upload Via Json"),
            icon: const Icon(Icons.file_upload),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Future<void> _uploadJson() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.single.path!;
      String jsonString = File(filePath).readAsStringSync();

      try {
        List<dynamic> jsonData = json.decode(jsonString);

        if (jsonData.isNotEmpty) {
          await _addCarFromJson(jsonData);
        } else {}
      } catch (e) {}
    } else {}
  }

  Future<List<String>> _uploadImages(List<String> imageUrls, id) async {
    List<String> uploadedUrls = [];

    for (String imageUrl in imageUrls) {
      try {
        Uri uri = Uri.parse(imageUrl);
        http.Response response = await http.get(uri);

        if (response.statusCode == 200) {
          // Compress the image using FlutterImageCompress
          Uint8List compressedImage =
              await testComporessList(response.bodyBytes);

          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;

          String fileName = randomAlphaNumeric(10);
          String filePath = '$tempPath/$fileName.webp';
          File compressedImageFile = File(filePath);
          await compressedImageFile.writeAsBytes(compressedImage);

          // Upload the compressed image to Firebase Storage
          Reference ref =
              FirebaseStorage.instance.ref().child('Cars/$id/$fileName');
          await ref.putFile(
            compressedImageFile,
            SettableMetadata(
                contentType: 'image/webp'), // Update content type to WebP
          );
          String downloadURL = await ref.getDownloadURL();
          uploadedUrls.add(downloadURL);
          // return downloadURL;
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return uploadedUrls;
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    final result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 800,
      minWidth: 800,
      quality: 96,
      rotate: 0,
      format: CompressFormat.webp,
    );
    print('Original size: ${list.length}');
    print('Compressed size: ${result.length}');
    return result;
  }

  Future<void> _addCarFromJson(List<dynamic> jsonData) async {
    for (final dynamic carData in jsonData) {
      String id = randomAlphaNumeric(10);

      final scaffoldContext = ScaffoldMessenger.of(context);

      // Check if carData is a Map<String, dynamic>
      if (carData is! Map<String, dynamic>) {
        const SnackBar snackBar =
            SnackBar(content: Text('Invalid JSON format'));
        scaffoldContext.showSnackBar(snackBar);
        continue; // Skip invalid data and move to the next iteration
      }

      Map<String, dynamic> carDataMap = carData;
      List<String> filePaths = List<String>.from(carDataMap['file_path'] ?? []);
      // Extract car details from JSON
      String brandName = carDataMap['BrandName'] ?? '';
      String carName = carDataMap['CarName'] ?? '';
      String regNo = carDataMap['RegNo'] ?? '';
      String carPrice = carDataMap['CarPrice'] ?? '';
      String fuelName = carDataMap['FuelName'] ?? '';
      String year = carDataMap['Year'] ?? '';
      String version = carDataMap['Version'] ?? '';
      String insurance = carDataMap['Insurance'] ?? '';
      String km = carDataMap['Km'] ?? '';
      String colorName = carDataMap['ColorName'] ?? '';
      String owners = carDataMap['Owners'] ?? '';
      String gear = carDataMap['Gear'] ?? '';
      String status = carDataMap['Status'] ?? '';
      String subBrandName = carDataMap['SubBrandName'] ?? '';
      String location = carDataMap['Location'] ?? '';
      List<String> uploadedUrls = await _uploadImages(filePaths, id);

      if (carName.isNotEmpty) {
        CarModel newCar = CarModel(
          id: id,
          brandName: brandName,
          name: carName,
          regNo: regNo,
          carPrice: carPrice,
          fuelName: fuelName,
          year: year,
          version: version,
          insurance: insurance,
          km: km,
          colorName: colorName,
          owners: owners,
          gear: gear,
          status: status,
          subBrandName: subBrandName,
          location: location,
          imagesUrls: uploadedUrls,
        );

        await _carController.addNewCar(newCar, id);
      } else {
        const SnackBar snackBar = SnackBar(content: Text('Invalid car data'));
        scaffoldContext.showSnackBar(snackBar);
      }
    }
  }
}
