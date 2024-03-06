import 'dart:io';
import 'package:alakh_car/controller/admin/brand_controller.dart';
import 'package:alakh_car/controller/admin/color_controller.dart';
import 'package:alakh_car/controller/admin/fuel_controller.dart';
import 'package:alakh_car/controller/admin/owner_controller.dart';
import 'package:alakh_car/controller/admin/sub_brand_controller.dart';
import 'package:alakh_car/models/admin/brand.dart';
import 'package:alakh_car/models/admin/color.dart';
import 'package:alakh_car/models/admin/fuel.dart';
import 'package:alakh_car/models/admin/owner.dart';
import 'package:alakh_car/models/admin/subbrand.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:alakh_car/controller/admin/car_controller.dart';
import 'package:alakh_car/models/admin/car.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateDeleteCarScreen extends StatefulWidget {
  final CarModel car;

  UpdateDeleteCarScreen({required this.car});

  @override
  _UpdateDeleteCarScreenState createState() => _UpdateDeleteCarScreenState();
}

class _UpdateDeleteCarScreenState extends State<UpdateDeleteCarScreen> {
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

  BrandModel? selectedBrand;
  SubBrandModel? selectedSubBrand;
  ColorModel? selectedColor;
  FuelModel? selectedFuel;
  OwnerModel? selectedOwner;
  // BrandModel? selectedBrand;
  // SubBrandModel? selectedSubBrand;
  List<BrandModel> _brands = [];
  List<SubBrandModel> _subBrands = [];
  List<ColorModel> _colors = [];
  List<FuelModel> _fuels = [];
  List<OwnerModel> _owners = [];

  String? selectedGearType;
  String? selectedStatus;
  String? selectedLocation;

  List<File> _images = [];
  final focusNodefile = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Future<void> initializeData() async {
    await _loadBrands();
    // await _loadSubBrands();
    await _loadColors();
    await _loadFuels();
    await _loadOwners();
    _carNameController.text = widget.car.name;
    _regNoController.text = widget.car.regNo!;
    _versionController.text = widget.car.version!;
    _insuranceController.text = widget.car.insurance!;
    _kmController.text = widget.car.km!;
    _yearsController.text = widget.car.year!;
    _priceController.text = widget.car.carPrice!;
    selectedGearType = widget.car.gear;
    selectedStatus = widget.car.status;
    selectedLocation = widget.car.location;
    selectedBrand = _brands.firstWhere(
      (brand) => brand.name == widget.car.brandName,
      orElse: () => _brands.isNotEmpty ? _brands[0] : null as BrandModel,
    );
    Future.delayed(Duration.zero, () async {
      await _loadSubBrands();
      selectedSubBrand = _subBrands.firstWhere(
        (subbrand) => subbrand.name == widget.car.subBrandName,
        orElse: () =>
            _subBrands.isNotEmpty ? _subBrands[0] : null as SubBrandModel,
      );
      selectedFuel = _fuels.firstWhere(
        (fuel) =>
            fuel.name ==
            widget.car.fuelName, // Assuming fuelName is the correct property
        orElse: () => _fuels.isNotEmpty
            ? _fuels[0]
            : null as FuelModel, // Assuming FuelModel is the correct type
      );

      // Set other initializations if needed
    });
    // selectedSubBrand = _subBrands
    //     .firstWhere((subbrand) => subbrand.name == widget.car.subBrandName);
    selectedColor = _colors.firstWhere(
      (color) => color.name == widget.car.colorName,
      orElse: () => _colors.isNotEmpty ? _colors[0] : null as ColorModel,
    );

    selectedOwner = _owners.firstWhere(
      (owner) => owner.name == widget.car.owners,
      orElse: () => _owners.isNotEmpty ? _owners[0] : null as OwnerModel,
    );
  }

  @override
  Future<void> _loadBrands() async {
    List<BrandModel> brands = await _brandController.loadBrands();
    setState(() {
      _brands = brands;
    });
  }

  Future<void> _loadSubBrands() async {
    List<SubBrandModel> subbrands =
        await _subBrandController.loadSubBrands(selectedBrand?.name as String?);
    setState(() {
      _subBrands = subbrands;
    });
  }

  Future<void> _loadColors() async {
    List<ColorModel> colors = await _colorController.loadColors();
    setState(() {
      _colors = colors;
    });
  }

  Future<void> _loadFuels() async {
    List<FuelModel> fuels = await _fuelController.loadFuels();
    setState(() {
      _fuels = fuels;
    });
  }

  Future<void> _loadOwners() async {
    List<OwnerModel> owners = await _ownerController.loadOwners();
    setState(() {
      _owners = owners;
    });
  }

  Widget build(BuildContext context) {
    // selectedSubBrand = _subBrands
    //     .firstWhere((subbrand) => subbrand.name == widget.car.subBrandName);

    return Scaffold(
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Update or Delete Car',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onSearch: (String) {},
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<BrandModel>(
                value: selectedBrand,
                items: _brands.map((BrandModel brand) {
                  return DropdownMenuItem<BrandModel>(
                    value: brand,
                    child: Text(brand.name),
                  );
                }).toList(),
                onChanged: (BrandModel? value) {
                  setState(() {
                    selectedBrand = value!;
                  }); // Load subbrands when brand changes
                },
                decoration: const InputDecoration(labelText: 'Select Brand'),
              ),
              DropdownButtonFormField<SubBrandModel>(
                value: selectedSubBrand,
                items: _subBrands.map((SubBrandModel subband) {
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
                decoration:
                    const InputDecoration(labelText: 'Select Sub Brand'),
              ),
              TextField(
                controller: _carNameController,
                decoration: const InputDecoration(labelText: 'Car Name'),
              ),
              TextField(
                controller: _regNoController,
                decoration:
                    const InputDecoration(labelText: 'Registration Number'),
              ),
              TextField(
                controller: _versionController,
                decoration: const InputDecoration(labelText: 'Version'),
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
                decoration: const InputDecoration(labelText: 'Select Color'),
              ),
              TextField(
                controller: _insuranceController,
                decoration: const InputDecoration(labelText: 'Insurance'),
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
                decoration: const InputDecoration(labelText: 'Select Fuel'),
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
                decoration: const InputDecoration(labelText: 'Select Owners'),
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
                decoration:
                    const InputDecoration(labelText: 'Select Gear Type'),
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
                decoration: const InputDecoration(labelText: 'Car Status'),
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
                decoration: const InputDecoration(labelText: 'Car Location'),
              ),
              const SizedBox(
                height: 20,
              ),
              // FloatingActionButton.extended(
              //   focusNode: focusNodefile,
              //   onPressed: _pickImages,
              //   icon: Icon(Icons.upload),
              //   label: Text('Pick Image'),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              await _updateCar();
            },
            label: Text("Update"),
            icon: Icon(Icons.update),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              _deleteCar();
            },
            label: Text("Delete"),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCar() async {
    List<String>? imagesUrls;

    // Await the result of the stream to get the list of image URLs
    List<String>? existingImages =
        await _carController.getCarImages(widget.car.id).first;

    // If there are existing images, assign them to imagesUrls
    if (existingImages != null) {
      imagesUrls = List<String>.from(existingImages);
    } else {
      // If there are no existing images, initialize imagesUrls to an empty list
      imagesUrls = [];
    }

    // If there are no existing images, initialize imagesUrls to an empty list
    if (imagesUrls == null) {
      imagesUrls = [];
    }

    CarModel updatedCar = CarModel(
      id: widget.car.id,
      brandName: selectedBrand!.name,
      subBrandName: selectedSubBrand!.name,
      name: _carNameController.text,
      regNo: _regNoController.text,
      carPrice: _priceController.text,
      fuelName: selectedFuel!.name,
      year: _yearsController.text,
      version: _versionController.text,
      insurance: _insuranceController.text,
      km: _kmController.text,
      colorName: selectedColor!.name,
      owners: selectedOwner!.name,
      gear: selectedGearType,
      status: selectedStatus,
      location: selectedLocation,
      imagesUrls: imagesUrls,
    );

    await _carController.updateCar(updatedCar, widget.car.id);
    _images.clear();
    Navigator.pop(context); // Close the current screen after updating
  }

  void _deleteCar() {
    _carController.deleteCar(widget.car.id);
    _carController.deleteCarImages(widget.car.id);
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
