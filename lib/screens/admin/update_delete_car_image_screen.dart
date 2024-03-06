import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDeleteCarImageScreen extends StatefulWidget {
  final CarModel car;

  UpdateDeleteCarImageScreen({required this.car});

  @override
  _UpdateDeleteCarImageScreenState createState() =>
      _UpdateDeleteCarImageScreenState();
}

class _UpdateDeleteCarImageScreenState
    extends State<UpdateDeleteCarImageScreen> {
  final CarController _carController = CarController();

  List<File> _images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Update or Delete Images',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onSearch: (String) {},
      ),
      body: StreamBuilder<List<String>>(
        stream: _carController.getCarImages(widget.car.id),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images available'));
          }

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 4 / 3.1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 3,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String imageUrl = snapshot.data![index];
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Image !',
                              style: TextStyle(fontSize: 18)),
                          actions: <Widget>[
                            Row(
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () {
                                    _carController.deleteCarImg(
                                        widget.car.id, imageUrl);
                                    Navigator.of(context).pop();
                                  },
                                  label: const Text("Delete"),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: const Color.fromARGB(255, 137, 149, 216)),
                    ),
                    child: InkWell(
                      child: CachedNetworkImage(
                        width: 20,
                        height: 20,
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const Center(
                          child: Icon(
                            Icons.car_crash_sharp,
                            size: 80,
                            fill: 1.0,
                            color: Colors.black38,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _pickImages();
        },
        label: Text('Upload Image'),
        icon: Icon(Icons.upload),
      ),
    );
  }

  Future<void> _pickImages() async {
    ImagePicker imagePicker = ImagePicker();
    List<XFile>? files = await imagePicker.pickMultiImage();

    setState(() {
      _images =
          files != null ? files.map((file) => File(file.path)).toList() : [];
    });

    // Call _updateImagesToCar to handle the uploading and updating of images
    await _updateImagesToCar();
  }

  Future<void> _updateImagesToCar() async {
    if (_images.isNotEmpty) {
      List<String>? imagesUrls =
          await _carController.uploadImages(_images, widget.car.id);

      await _carController.updateImageUrls(imagesUrls, widget.car.id);
      _images.clear(); // Clear the list after successful upload
    } else {
      // Handle case when there are no images to update
    }
  }
}
