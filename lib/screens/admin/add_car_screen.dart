import 'dart:io';
import 'package:alakh_car/controller/admin/brand_controller.dart';
import 'package:alakh_car/controller/admin/color_controller.dart';
import 'package:alakh_car/controller/admin/fuel_controller.dart';
import 'package:alakh_car/controller/admin/owner_controller.dart';
import 'package:alakh_car/controller/admin/sub_brand_controller.dart';
import 'package:alakh_car/models/admin/brand.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:alakh_car/models/admin/color.dart';
import 'package:alakh_car/models/admin/fuel.dart';
import 'package:alakh_car/models/admin/owner.dart';
import 'package:alakh_car/models/admin/subbrand.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();

  static pickImages() {}
}

class _AddCarScreenState extends State<AddCarScreen> {
  final CarController _carController = CarController();
  final _carNameController = TextEditingController(),
      _regNoController = TextEditingController(),
      _versionController = TextEditingController(),
      _insuranceController = TextEditingController(),
      _kmController = TextEditingController(),
      _yearsController = TextEditingController(),
      _priceController = TextEditingController();

  final BrandController _brandController = BrandController();
  final SubBrandController _subBrandController = SubBrandController();
  final ColorController _colorController = ColorController();
  final FuelController _fuelController = FuelController();
  final OwnerController _ownerController = OwnerController();

  String? selectedCarId;
  // File? _image;
  List<File> _images = [];
  List<String> imagesUrl = [];
  final focusNode = FocusNode();
  final focusNodefile = FocusNode();
  String? selectedSubBrandId;
  BrandModel? selectedBrand;
  List<BrandModel> _brands = [];
  SubBrandModel? selectedSubBrand;
  List<SubBrandModel> _subbrands = [];
  ColorModel? selectedColor;
  List<ColorModel> _colors = [];
  FuelModel? selectedFuel;
  List<FuelModel> _fuels = [];
  OwnerModel? selectedOwner;
  List<OwnerModel> _owners = [];
  String? selectedGearType;
  String? selectedStatus;
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _loadColors();
    _loadFuels();
    _loadOwners();
    // Call a function to load brands when the screen initializes
  }

  Future<void> _loadBrands() async {
    List<BrandModel> brands = await _brandController.loadBrands();
    setState(() {
      _brands = brands;
    });
  }

  Future<void> _loadSubBrands() async {
    try {
      if (selectedBrand == null) {
        // If no brand is selected, clear the subbrands list
        setState(() {
          _subbrands = [];
        });
        return;
      }

      Stream<List<SubBrandModel>> subBrandsStream =
          _subBrandController.getSubBrand(selectedBrand!.name);

      setState(() {
        _subbrands = [];
      });

      await for (List<SubBrandModel> subbrands in subBrandsStream) {
        setState(() {
          _subbrands = subbrands;
        });
      }
    } catch (e) {
      print('Error loading sub-brands: $e');
    }
  }

  Future<void> _loadColors() async {
    try {
      Stream<List<ColorModel>> colorsStream = _colorController.getColors();

      setState(() {
        _colors = [];
      });

      await for (List<ColorModel> colors in colorsStream) {
        setState(() {
          _colors = colors;
        });
      }
    } catch (e) {
      print('Error loading colors: $e');
    }
  }

  Future<void> _loadFuels() async {
    try {
      Stream<List<FuelModel>> fuelsStream = _fuelController.getFuels();

      setState(() {
        _fuels = [];
      });

      await for (List<FuelModel> fuels in fuelsStream) {
        setState(() {
          _fuels = fuels;
        });
      }
    } catch (e) {
      print('Error loading colors: $e');
    }
  }

  Future<void> _loadOwners() async {
    try {
      Stream<List<OwnerModel>> ownersStream = _ownerController.getOwners();

      setState(() {
        _owners = [];
      });

      await for (List<OwnerModel> owners in ownersStream) {
        setState(() {
          _owners = owners;
        });
      }
    } catch (e) {
      print('Error loading colors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Add Car',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onSearch: (String) {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<BrandModel>(
                          value: selectedBrand ?? selectedBrand,
                          items: _brands.map((BrandModel brand) {
                            return DropdownMenuItem<BrandModel>(
                              alignment: Alignment.centerLeft,
                              value: brand,
                              child: Text(brand.name),
                            );
                          }).toList(),
                          onChanged: (BrandModel? value) {
                            setState(() {
                              selectedBrand = value!;
                            });
                            _loadSubBrands(); // Load subbrands when brand changes
                          },
                          decoration:
                              const InputDecoration(labelText: 'Select Brand'),
                        ),
                        DropdownButtonFormField<SubBrandModel>(
                          value: selectedSubBrand ?? selectedSubBrand,
                          items: _subbrands.map((SubBrandModel subband) {
                            return DropdownMenuItem<SubBrandModel>(
                              value: subband,
                              child: Text(subband.name),
                            );
                          }).toList(),
                          onChanged: (SubBrandModel? value) {
                            setState(() {
                              selectedSubBrand = value!;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Select SubBrand'),
                        ),
                        TextField(
                          controller: _carNameController,
                          focusNode: focusNode,
                          decoration:
                              const InputDecoration(labelText: 'Car Name'),
                        ),
                        TextField(
                          controller: _regNoController,
                          decoration: const InputDecoration(
                              labelText: 'Registration Number'),
                        ),
                        TextField(
                          controller: _versionController,
                          decoration:
                              const InputDecoration(labelText: 'Version'),
                        ),
                        DropdownButtonFormField<ColorModel>(
                          value: selectedColor,
                          items: _colors.map((ColorModel color) {
                            return DropdownMenuItem<ColorModel>(
                              value: color,
                              child: Text(color.name),
                            );
                          }).toList(),
                          onChanged: (ColorModel? value) {
                            setState(() {
                              selectedColor = value;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Select Color'),
                        ),
                        TextField(
                          controller: _insuranceController,
                          decoration:
                              const InputDecoration(labelText: 'Insurance'),
                        ),
                        TextField(
                          controller: _kmController,
                          decoration: const InputDecoration(labelText: 'KM'),
                        ),
                        TextField(
                          controller: _yearsController,
                          decoration: const InputDecoration(labelText: 'Years'),
                        ),
                        TextField(
                          controller: _priceController,
                          inputFormatters: [NumberInputFormatter()],
                          decoration: const InputDecoration(labelText: 'Price'),
                        ),
                        DropdownButtonFormField<FuelModel>(
                          value: selectedFuel,
                          items: _fuels.map((FuelModel fuel) {
                            return DropdownMenuItem<FuelModel>(
                              value: fuel,
                              child: Text(fuel.name),
                            );
                          }).toList(),
                          onChanged: (FuelModel? value) {
                            setState(() {
                              selectedFuel = value;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Select Fuel'),
                        ),
                        DropdownButtonFormField<OwnerModel>(
                          value: selectedOwner,
                          items: _owners.map((OwnerModel owner) {
                            return DropdownMenuItem<OwnerModel>(
                              value: owner,
                              child: Text(owner.name),
                            );
                          }).toList(),
                          onChanged: (OwnerModel? value) {
                            setState(() {
                              selectedOwner = value;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Select Owners'),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedGearType,
                          items: [
                            DropdownUtils.buildDropdownItem('Auto'),
                            DropdownUtils.buildDropdownItem('Manual'),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedGearType = value;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Select Gear Type'),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          items: [
                            DropdownUtils.buildDropdownItem('Ready'),
                            DropdownUtils.buildDropdownItem('Coming Soon'),
                            DropdownUtils.buildDropdownItem('Sould'),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Car Status'),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedLocation,
                          items: [
                            DropdownUtils.buildDropdownItem('A'),
                            DropdownUtils.buildDropdownItem('A1'),
                            DropdownUtils.buildDropdownItem('A2'),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              selectedLocation = value;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Select Location'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FloatingActionButton.extended(
                          focusNode: focusNodefile,
                          onPressed: _pickImages,
                          icon: const Icon(Icons.upload),
                          label: const Text('Pick Image'),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              if (_carNameController.text.trim().isNotEmpty && _images != []) {
                Navigator.of(context).pop();
                await _addCar();
              } else {
                FocusScope.of(context).requestFocus(focusNode);
              }
            },
            label: const Text("Add"),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    ImagePicker imagePicker = ImagePicker();
    List<XFile>? files = await imagePicker.pickMultiImage(
      maxHeight: 800,
      maxWidth: 800,
      // source: ImageSource.gallery,
      // Set max width, height, and quality as needed
    );

    setState(() {
      _images =
          files != [] ? files.map((file) => File(file.path)).toList() : [];
    });
  }

  Future<void> _addCar() async {
    String id = randomAlphaNumeric(10);
    final scaffoldContext = ScaffoldMessenger.of(context);
    if (_images.isNotEmpty) {
      List<String>? imagesUrls = await _carController.uploadImages(_images, id);
      CarModel newCar = CarModel(
        id: id,
        imagesUrls: imagesUrls,
        brandName: selectedBrand!.name,
        subBrandName: selectedSubBrand!.name,
        name: _carNameController.text,
        regNo: _regNoController.text,
        carPrice: _priceController.text,
        fuelName: selectedFuel!.name,
        year: _yearsController.text,
        version: _versionController.text,
        insurance: _versionController.text,
        km: _kmController.text,
        colorName: selectedColor!.name,
        owners: selectedOwner!.name,
        gear: selectedGearType,
        status: selectedStatus,
        location: selectedLocation,
      );
      await _carController.addCar(newCar, id, imagesUrls);
      _images.clear(); // Clear the list after successful upload
    } else {
      // FocusScope.of(context).requestFocus(focusNodefile);
      const ScaffoldMessenger(child: Text('Please select image'));
      // Dismiss the SnackBar after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        scaffoldContext.removeCurrentSnackBar();
      });
    }
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

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final numberFormat = NumberFormat('#,##,###');
    final oldValueText = oldValue.text.replaceAll(',', '');
    final newValueText = newValue.text.replaceAll(',', '');

    try {
      final newValueNumber = int.parse(newValueText);
      final formattedValue = numberFormat.format(newValueNumber);
      return newValue.copyWith(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    } catch (e) {
      // If parsing fails, return the old value
      return oldValue;
    }
  }
}
