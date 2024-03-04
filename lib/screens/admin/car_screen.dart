import 'dart:convert';
import 'dart:io';
import 'package:alakh_car/models/admin/car.dart';
import 'package:alakh_car/screens/admin/add_car_screen.dart';
import 'package:alakh_car/screens/admin/update_delete_car_image_screen.dart';
import 'package:alakh_car/screens/admin/update_delete_car_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:random_string/random_string.dart';
import 'package:file_picker/file_picker.dart';

class CarScreen extends StatefulWidget {
  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
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
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Car List',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onSearch: (value) {
          // setState(() {
          //   _filteredData = _apiDataCar.where((element) {
          //     final titleMatch = element.serviceTitle!
          //         .toLowerCase()
          //         .contains(value.toLowerCase());
          //     final regNoMatch =
          //         element.regNo!.toLowerCase().contains(value.toLowerCase());
          //     final yearMatch =
          //         element.year!.toLowerCase().contains(value.toLowerCase());
          //     return titleMatch || regNoMatch || yearMatch;
          //   }).toList();
          // });
        },
      ),
      // appBar: AppBar(
      //   title: const Text('Car List'),
      // ),
      body: StreamBuilder<List<CarModel>>(
        stream: _carController.getCars(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          List<CarModel> cars = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: cars.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Update Delete Car',
                                style: TextStyle(fontSize: 18)),
                            actions: <Widget>[
                              Row(
                                children: [
                                  FloatingActionButton.extended(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateDeleteCarScreen(
                                                  car: cars[index]),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    label: const Text("Edit"),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  FloatingActionButton.extended(
                                    onPressed: () {
                                      _deleteCar(cars[index].id);
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
                    // onTap: () async {
                    //   await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           UpdateDeleteCarScreen(car: cars[index]),
                    //     ),
                    //   );
                    // },
                    child: Card(
                      shadowColor: Colors.white,
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.09),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateDeleteCarImageScreen(
                                                    car: cars[index]),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl: cars[index]
                                                    .imagesUrls!
                                                    .isNotEmpty
                                                ? cars[index].imagesUrls![0]
                                                : '',
                                            maxHeightDiskCache: 100,
                                            maxWidthDiskCache: 100,
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
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cars[index].name,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _updateLocation(
                                                cars[index].location,
                                                cars[index].name,
                                                cars[index].id);
                                          },
                                          child: Text(
                                              'Location:${cars[index].location}'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Year : ${cars[index].year} . Price : ${cars[index].carPrice}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Reg No : ${cars[index].regNo}',
                                          style: const TextStyle(
                                              color: Colors.deepPurple),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'KM : ${cars[index].km}',
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    //border: Border.all(width: 1.0)),
                                    border: Border.all(
                                        width: 0.5,
                                        color: const Color.fromRGBO(
                                            0, 0, 0, 0.09))),
                                child: const SizedBox(
                                  width: 500.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Fuel : ${cars[index].fuelName}'),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: 5.0,
                                        width: 5.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 0.09))),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Owners : ${cars[index].owners}',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: 5.0,
                                        width: 5.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 0.09))),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Policy : ${cars[index].insurance}',
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton.extended(
          //   onPressed: _uploadJson,
          //   label: Text("Upload Via Json"),
          //   icon: const Icon(Icons.file_upload),
          // ),
          // const SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCarScreen()),
              );
            },
            label: const Text("Add New Car"),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _updateLocation(String? location, name, id) async {
    String? selectedLocation = location; // Declare selectedLocation variable

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Location'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButtonFormField<String>(
                value: selectedLocation,
                items: [
                  DropdownMenuItem(child: Text('A'), value: 'A'),
                  DropdownMenuItem(child: Text('A1'), value: 'A1'),
                  DropdownMenuItem(child: Text('A2'), value: 'A2'),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Car Location'),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Update location here
                await _carController.updateLocation(selectedLocation!, id);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateImages(String id) async {
    String? selectedLocation; // Declare selectedLocation variable

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: StreamBuilder<List<String>>(
                stream: _carController.getCarImages(id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
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
                          onTap: () {
                            // Handle tap event, e.g., open a larger view of the image
                            print('Tapped on image with URL: $imageUrl');
                            // You can add your custom logic here, e.g., opening a larger view of the image
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 137, 149, 216)),
                            ),
                            child: CachedNetworkImage(
                              width: 20,
                              height: 20,
                              imageUrl: imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
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
        } else {
          // Handle an empty or invalid JSON array
          // You might want to show a snackbar or handle it as appropriate
        }
      } catch (e) {
        // Handle JSON decoding error
        // You might want to show a snackbar or handle it as appropriate
      }
    } else {
      // Handle no file selected or an invalid file type
    }
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

      List<String> imagesUrls = List<String>.from(carDataMap['ImageUrl'] ?? []);

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
          imagesUrls: imagesUrls,
        );

        await _carController.addCar(newCar, id, imagesUrls);
      } else {
        const SnackBar snackBar = SnackBar(content: Text('Invalid car data'));
        scaffoldContext.showSnackBar(snackBar);
      }
    }
  }

  void _deleteCar(String id) {
    _carController.deleteCar(id);
    _carController.deleteCarImages(id);
    Navigator.pop(context); // Close the current screen after deleting
  }
}

class DropdownUtils {
  static DropdownMenuItem<String> buildDropdownItem(String text) {
    return DropdownMenuItem<String>(
      value: text,
      child: Text(text),
    );
  }
}
