import 'dart:io';
import 'package:alakh_car/models/admin/brand.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/brand_controller.dart';
import 'package:random_string/random_string.dart';
import 'package:image_picker/image_picker.dart';

class BrandScreen extends StatefulWidget {
  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final BrandController _brandController = BrandController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandOrderController = TextEditingController();
  String? selectedBrandId;
  File? _image;
  final focusNode = FocusNode();
  final filefocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Brand List'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _brandController.getBrand(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            final brands = snapshot.data!.docs
                .map((doc) =>
                    BrandModel.fromSnapshot(doc.data() as Map<String, dynamic>))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 1.35,
                  // maxCrossAxisExtent: 250,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: Orientation.portrait == orientation ? 4 : 6,
                ),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  BrandModel brand = brands[index];
                  String imageUrl = brand.imageUrl ?? '';

                  return InkWell(
                    onTap: () {
                      _showUpdateDeleteDialog(brand);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(207, 225, 240, 1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromRGBO(148, 195, 235, 1),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  brand.name,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog();
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  Future<void> _showAddDialog() async {
    _brandNameController.text = '';
    _brandOrderController.text = '';
    _image = null;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Brand'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _brandNameController,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: 'Brand Name'),
              ),
              TextField(
                controller: _brandOrderController,
                decoration: const InputDecoration(labelText: 'Brand Order'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                focusNode: filefocusNode,
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_brandNameController.text.trim().isNotEmpty &&
                    _image != null) {
                  Navigator.of(context).pop();
                  await _addBrand();
                } else {
                  FocusScope.of(context).requestFocus(focusNode);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateDeleteDialog(BrandModel brand) async {
    _brandNameController.text = brand.name;
    _brandOrderController.text = brand.order.toString();
    selectedBrandId = brand.id;
    _image = _image;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update or Delete Brand'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _brandNameController,
                decoration: const InputDecoration(labelText: 'Brand Name'),
              ),
              TextField(
                controller: _brandOrderController,
                decoration: const InputDecoration(labelText: 'Brand Order'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateBrand();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBrand();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 168,
      imageQuality: 100,
    );

    setState(() {
      _image = file != null ? File(file.path) : null;
    });
  }

  Future<void> _addBrand() async {
    String id = randomAlphaNumeric(10);
    final scaffoldContext = ScaffoldMessenger.of(context);
    if (_image != null) {
      String? imageUrl = await _brandController.uploadImage(_image!, id);
      BrandModel newBrand = BrandModel(
        id: id,
        name: _brandNameController.text,
        order: int.parse(_brandOrderController.text),
        imageUrl: imageUrl,
      );
      await _brandController.addBrand(newBrand, id, imageUrl);
    } else {
      FocusScope.of(context).requestFocus(focusNode);

      // Dismiss the SnackBar after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        scaffoldContext.removeCurrentSnackBar();
      });
    }
  }

  Future<void> _updateBrand() async {
    String? imageUrl;

    if (selectedBrandId != null) {
      // Check if a new image is selected
      if (_image != null) {
        // If a new image is selected, upload the new image and get the new URL
        imageUrl =
            await _brandController.uploadImage(_image!, selectedBrandId!);
      }

      // Use the new image URL if a new image is selected, otherwise use the existing one
      imageUrl ??= await _brandController.getBrandImageUrl(selectedBrandId!);

      // Create an updated BrandModel with the new or existing image URL
      BrandModel updatedBrand = BrandModel(
        id: selectedBrandId!,
        name: _brandNameController.text,
        order: int.parse(_brandOrderController.text),
        imageUrl: imageUrl,
      );

      // Update the brand in Firestore
      await _brandController.updateBrand(
          updatedBrand, selectedBrandId!, imageUrl);
    }
  }

  void _deleteBrand() {
    if (selectedBrandId != null) {
      _brandController.deleteBrand(selectedBrandId!);
      _brandController.deleteBrandImg(selectedBrandId!);
    }
  }
}
