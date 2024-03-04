import 'dart:io';
import 'package:alakh_car/models/admin/banner.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/banner_controller.dart';
import 'package:random_string/random_string.dart';
import 'package:image_picker/image_picker.dart';

class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final BannerController _bannerController = BannerController();
  final TextEditingController _bannerNameController = TextEditingController();
  String? selectedBannerId;
  File? _image;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner List'),
      ),
      body: StreamBuilder<List<BannerModel>>(
        stream: _bannerController.getBanners(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<BannerModel> banners = snapshot.data!;

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              BannerModel banner = snapshot.data![index];
              String imageUrl = banner.imageUrl ??
                  ''; // Get the image URL or an empty string if it's null

              return ListTile(
                title: Text(banners[index].name),
                leading: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 50,
                        width: 50,
                      ) // Display the image if the URL is available
                    : const Placeholder(
                        fallbackHeight: 20,
                        fallbackWidth: 20,
                        child: Text("data"),
                      ),
                onTap: () {
                  _showUpdateDeleteDialog(banners[index]);
                },
              );
            },
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
  }

  Future<void> _showAddDialog() async {
    _bannerNameController.text = '';
    _image = null;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Banner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _bannerNameController,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: 'Banner Name'),
              ),
              ElevatedButton(
                onPressed: _pickImage,
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
                if (_bannerNameController.text.trim().isNotEmpty &&
                    _image != null) {
                  Navigator.of(context).pop();
                  await _addBanner();
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

  Future<void> _showUpdateDeleteDialog(BannerModel banner) async {
    _bannerNameController.text = banner.name;
    selectedBannerId = banner.id;
    _image = null;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update or Delete Banner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _bannerNameController,
                decoration: const InputDecoration(labelText: 'Banner Name'),
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
                await _updateBanner();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBanner();
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
      maxWidth: 780,
      maxHeight: 329,
      imageQuality: 100,
      // maxHeight: 100,
      // imageQuality: 50,
    );

    setState(() {
      _image = file != null ? File(file.path) : null;
    });
  }

  Future<void> _addBanner() async {
    String id = randomAlphaNumeric(10);
    final scaffoldContext = ScaffoldMessenger.of(context);
    if (_image != null) {
      String? imageUrl = await _bannerController.uploadImage(_image!, id);
      BannerModel newBanner = BannerModel(
        id: id,
        name: _bannerNameController.text,
        imageUrl: imageUrl,
      );
      await _bannerController.addBanner(newBanner, id, imageUrl);
    } else {
      FocusScope.of(context).requestFocus(focusNode);

      // Dismiss the SnackBar after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        scaffoldContext.removeCurrentSnackBar();
      });
    }
  }

  Future<void> _updateBanner() async {
    if (selectedBannerId != null) {
      String? imageUrl =
          await _bannerController.uploadImage(_image!, selectedBannerId!);
      BannerModel updatedBanner = BannerModel(
        id: selectedBannerId!,
        name: _bannerNameController.text,
        imageUrl: imageUrl,
      );
      await _bannerController.updateBanner(
          updatedBanner, selectedBannerId!, imageUrl);
    }
  }

  void _deleteBanner() {
    if (selectedBannerId != null) {
      _bannerController.deleteBanner(selectedBannerId!);
      _bannerController.deleteBannerImg(selectedBannerId!);
    }
  }
}
