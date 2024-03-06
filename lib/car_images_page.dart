import 'dart:async';
import 'dart:typed_data';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:alakh_car/gallery.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarImagesPage extends StatefulWidget {
  final String id;
  final String title;

  const CarImagesPage({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  _CarImagesPageState createState() => _CarImagesPageState();
}

class _CarImagesPageState extends State<CarImagesPage> {
  final CarController _carController = CarController();
  bool _isLoading = false;
  late Map<String, Uint8List> _cachedImages;

  @override
  void initState() {
    super.initState();
    _cachedImages = {}; // Initialize the cached images map
    _loadCarData(); // Load car data and cache images
  }

  Future<void> _loadCarData() async {
    try {
      CarModel car = await _carController.fetchCars(widget.id).first;
      // Cache the images when the car data is loaded successfully
      _cacheImages(car.imagesUrls!);
    } catch (e) {
      print('Error loading car data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: SafeArea(
            child: Column(
              children: [
                Builder(builder: (context) {
                  return StreamBuilder<CarModel>(
                    stream: _carController.fetchCars(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show error message
                      } else if (snapshot.data == null) {
                        return const Text(
                            'No data available'); // Show message when no data available
                      } else {
                        // Data is available, you can use it to build your UI
                        CarModel car = snapshot.data!;

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: GridView.builder(
                                  shrinkWrap:
                                      true, // Added to allow GridView to scroll inside SingleChildScrollView
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 4 / 3.1,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: car.imagesUrls?.length,
                                  itemBuilder: (context, index) {
                                    String imageUrl = car.imagesUrls![index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                51, 51, 51, 0.2)),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Gallery(
                                                urlImages: car.imagesUrls!,
                                                index: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          width: 20,
                                          height: 20,
                                          imageUrl: imageUrl,
                                          placeholder: (context, url) =>
                                              const Center(
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
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => _shareImages(car.imagesUrls!),
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text('Share Images'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareImages(List<String> imageUrls) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, Uint8List> files = {};
      for (int i = 0; i < imageUrls.length; i++) {
        String imageUrl = imageUrls[i];
        if (_cachedImages.containsKey(imageUrl)) {
          // Use cached image bytes if available
          files['image_$i.png'] = _cachedImages[imageUrl]!;
        } else {
          Uint8List bytes = await _getImageBytesFromUrl(imageUrl);
          files['image_$i.png'] = bytes;
          _cachedImages[imageUrl] = bytes; // Cache the downloaded image bytes
        }
      }
      await Share.files(widget.title, files, {'*/*'}, text: '');
    } catch (e) {
      print('Error sharing images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _getImageBytesFromUrl(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = Uint8List.fromList(response.bodyBytes);
        return bytes;
      } else {
        print('Error fetching image: Status code ${response.statusCode}');
        return Uint8List(0);
      }
    } catch (e) {
      print('Error fetching image: $e');
      return Uint8List(0);
    }
  }

  void _cacheImages(List<String> imageUrls) async {
    for (String imageUrl in imageUrls) {
      if (!_cachedImages.containsKey(imageUrl)) {
        Uint8List bytes = await _getImageBytesFromUrl(imageUrl);
        _cachedImages[imageUrl] = bytes; // Cache the downloaded image bytes
      }
    }
  }
}
