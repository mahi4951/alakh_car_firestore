import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:alakh_car/gallery.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class CarDetailPage extends StatefulWidget {
  final String id;
  final String title;
  final List<String> imageUrls;
  const CarDetailPage({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrls,
  }) : super(key: key);

  @override
  _CarDetailPageState createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  final GlobalKey _globalKey = GlobalKey();
  final CarController _carController = CarController();
  bool _isLoading = false;
  Map<String, Uint8List> _cachedImages = {};
  // late Map<String, Uint8List> _cachedImages;
  late List<String> imageUrls = [];
  @override
  void initState() {
    super.initState();
    _loadCarData(); // Load car data and cache images
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
          // If image bytes not cached, fetch and cache them
          Uint8List bytes = await _getImageBytesFromUrl(imageUrl);
          files['image_$i.png'] = bytes;
          _cachedImages[imageUrl] = bytes; // Cache the downloaded image bytes
        }
      }
      // Share the images
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
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    var byteData = await file.readAsBytes();
    return byteData;
  }

  void _cacheImages(List<String> imageUrls) async {
    for (String imageUrl in imageUrls) {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      var byteData = await file.readAsBytes();
      _cachedImages[imageUrl] = byteData; // Cache the downloaded image bytes
    }
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
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(15, 103, 180, 1),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                )),
            // onSearch: (value) {},
          ),
          // appBar: AppBar(title: Text(widget.title)),
          body: SingleChildScrollView(
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                color: Colors.white,
                child: Builder(builder: (context) {
                  return FutureBuilder<CarModel>(
                    future: _carController.fetchCar(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show error message
                      } else if (snapshot.data == null) {
                        return const Text(
                            'No data available'); // Show message when no data available
                      } else {
                        // Data is available, you can use it to build your UI
                        CarModel car = snapshot.data!;
                        imageUrls = car.imagesUrls!;
                        return SingleChildScrollView(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0,
                                        bottom: 10,
                                        left: 15,
                                        right: 15),
                                    child: CarouselSlider.builder(
                                      itemCount: car.imagesUrls!.length,
                                      options: CarouselOptions(
                                        aspectRatio: 16 / 11,
                                        viewportFraction: 1,
                                        enlargeCenterPage: false,
                                        enableInfiniteScroll: false,
                                        initialPage: 0,
                                        autoPlay: false,
                                        onPageChanged: (index, reason) {
                                          // Do something when page changes
                                        },
                                      ),
                                      itemBuilder: (context, index, realIndex) {
                                        String imageUrl =
                                            car.imagesUrls![index];
                                        return InkWell(
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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.low,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              // height: 100,
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              cacheManager:
                                                  DefaultCacheManager(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                15, 103, 180, 1),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.1),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 3),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_sharp,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                Text(
                                                  car.carPrice!,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _isLoading
                                              ? null
                                              : () =>
                                                  _shareImages(car.imagesUrls!),
                                          child: _isLoading
                                              ? const CircularProgressIndicator()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        15, 103, 180, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 0.1),
                                                    ),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(7.0),
                                                    child: Icon(
                                                      Icons.share,
                                                      size: 20,
                                                      color: Colors
                                                          .white, // Change the color as per your requirement
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  207, 225, 240, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      148, 195, 253, 1)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_month,
                                                    color: Color.fromRGBO(
                                                        15, 103, 180, 1),
                                                    size: 28,
                                                  ),
                                                  Text(
                                                    car.year!,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          51, 51, 51, 1),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  207, 225, 240, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      148, 195, 253, 1)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    Icons.speed,
                                                    color: Color.fromRGBO(
                                                        15, 103, 180, 1),
                                                    size: 28,
                                                  ),
                                                  Text(
                                                    car.km!,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          51, 51, 51, 1),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  207, 225, 240, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      148, 195, 253, 1)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Column(
                                                children: [
                                                  const Icon(
                                                    Icons.local_gas_station,
                                                    color: Color.fromRGBO(
                                                        15, 103, 180, 1),
                                                    size: 28,
                                                  ),
                                                  Text(
                                                    car.fuelName!,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          51, 51, 51, 1),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Table(
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(),
                                      2: FixedColumnWidth(100),
                                    },
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: <TableRow>[
                                      TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 4),
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Reg No : ',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromRGBO(
                                                      153, 153, 153, 1),
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: car.regNo.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          15, 15, 15, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Text.rich(TextSpan(
                                                  text: "Owners : ",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        153, 153, 153, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          car.owners.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromRGBO(
                                                            15, 15, 15, 1),
                                                      ),
                                                    ),
                                                  ])),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 4),
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Brand : ',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromRGBO(
                                                      153, 153, 153, 1),
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: car.brandName
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          15, 15, 15, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Text.rich(TextSpan(
                                                  text: "Model : ",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        153, 153, 153, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: car.subBrandName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromRGBO(
                                                            15, 15, 15, 1),
                                                      ),
                                                    ),
                                                  ])),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 4),
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Version : ',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromRGBO(
                                                      153, 153, 153, 1),
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        car.version.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          15, 15, 15, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Text.rich(TextSpan(
                                                  text: "Color : ",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        153, 153, 153, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: car.colorName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromRGBO(
                                                            15, 15, 15, 1),
                                                      ),
                                                    ),
                                                  ])),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 4),
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Gear : ',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromRGBO(
                                                      153, 153, 153, 1),
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: car.gear.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          15, 15, 15, 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 4),
                                              child: Text.rich(TextSpan(
                                                  text: "Insurances : ",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        153, 153, 153, 1),
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: car.insurance
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromRGBO(
                                                            15, 15, 15, 1),
                                                      ),
                                                    ),
                                                  ])),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.1),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 8),
                                        child: Text(
                                          '👍 OFFER ACCEPTABLE 🙏',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Positioned(
                              //   bottom: 80,
                              //   right: 20,
                              //   child: SizedBox(
                              //     height: 100,
                              //     width: 100,
                              //     child:
                              //         Image.asset('assets/images/applogo.jpeg'),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () => _captureAndShare(context),
                label: const Text("Share Detail"),
                icon: const Icon(Icons.share),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _shareImages(imageUrls) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     Map<String, Uint8List> files = {};
  //     for (int i = 0; i < imageUrls.length; i++) {
  //       String imageUrl = imageUrls[i];
  //       if (_cachedImages.containsKey(imageUrl)) {
  //         // Use cached image bytes if available
  //         files['image_$i.png'] = _cachedImages[imageUrl]!;
  //       } else {
  //         Uint8List bytes = await _getImageBytesFromUrl(imageUrl);
  //         files['image_$i.png'] = bytes;
  //         _cachedImages[imageUrl] = bytes; // Cache the downloaded image bytes
  //       }
  //     }
  //     await Share.files(widget.title, files, {'*/*'}, text: '');
  //   } catch (e) {
  //     print('Error sharing images: $e');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Future<Uint8List> _getImageBytesFromUrl(String imageUrl) async {
  //   try {
  //     http.Response response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       Uint8List bytes = Uint8List.fromList(response.bodyBytes);
  //       return bytes;
  //     } else {
  //       print('Error fetching image: Status code ${response.statusCode}');
  //       return Uint8List(0);
  //     }
  //   } catch (e) {
  //     print('Error fetching image: $e');
  //     return Uint8List(0);
  //   }
  // }

  // void _cacheImages(imageUrls) async {
  //   for (String imageUrl in imageUrls) {
  //     if (!_cachedImages.containsKey(imageUrl)) {
  //       Uint8List bytes = await _getImageBytesFromUrl(imageUrl);
  //       _cachedImages[imageUrl] = bytes; // Cache the downloaded image bytes
  //     }
  //   }
  // }

  Future<void> _captureAndShare(BuildContext context) async {
    try {
      // Capture the area of the screen
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      boundary.debugNeedsPaint;
      ui.Image image = await boundary.toImage(
          pixelRatio: 3.0); // You can adjust the pixelRatio as needed
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imageBytes = byteData!.buffer.asUint8List();

      // Get the temporary directory
      Directory tempDir = await getTemporaryDirectory();
      // Create a file in the temporary directory
      File imageFile = File('${tempDir.path}/screenshot.png');
      // Write the image bytes to the file
      await imageFile.writeAsBytes(imageBytes);
      // Share the file
      // Share.file(imageFile.path, text: 'Sharing Dynamic Page Data');
      Share.file('Alakhcar', 'Alakhcar.png', imageBytes, 'image/png',
          text: widget.title);
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }
}
