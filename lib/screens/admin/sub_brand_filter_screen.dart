import 'package:alakh_car/controller/admin/brand_controller.dart';
import 'package:alakh_car/controller/admin/sub_brand_controller.dart';
import 'package:alakh_car/models/admin/brand.dart';
import 'package:alakh_car/models/admin/subbrand.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SubBrandFilterScreen extends StatefulWidget {
  @override
  _SubBrandFilterScreenState createState() => _SubBrandFilterScreenState();
}

class _SubBrandFilterScreenState extends State<SubBrandFilterScreen> {
  final SubBrandController _subBrandCollection = SubBrandController();
  final BrandController _brandController = BrandController();
  final TextEditingController _subBrandNameController = TextEditingController();
  String? selectedSubBrandId;
  BrandModel? selectedBrand;
  List<BrandModel> _brands = [];
  List<SubBrandModel> _allSubBrands = [];
  List<SubBrandModel> _filteredSubBrands = [];

  @override
  void initState() {
    super.initState();
    _loadBrands();
    // _loadSubBrands();
  }

  Future<void> _loadBrands() async {
    List<BrandModel> brands = await _brandController.loadBrands();
    setState(() {
      _brands = brands;
    });
  }

  Future<void> _loadSubBrands() async {
    List<SubBrandModel> subbrands =
        await _subBrandCollection.loadSubBrands(selectedBrand!.name);
    setState(() {
      _allSubBrands = subbrands;
      _filteredSubBrands = _allSubBrands; // Initially, display all sub-brands
    });
  }

  void _filterSubBrandsByBrand() {
    setState(() {
      if (selectedBrand != null) {
        _filteredSubBrands = _allSubBrands
            .where((subBrand) => subBrand.mainBrand == selectedBrand!.name)
            .toList();
      } else {
        _filteredSubBrands =
            _allSubBrands; // Show all sub-brands if no brand is selected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Sub brand'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<BrandModel>(
              value: selectedBrand,
              items: _brands.map((BrandModel brand) {
                return DropdownMenuItem<BrandModel>(
                  value: brand,
                  child: Text(brand.name),
                );
              }).toList(),
              onChanged: (BrandModel? value) {
                setState(() {
                  selectedBrand = value;
                  _filterSubBrandsByBrand(); // Update the filtered sub-brands
                });
                _loadSubBrands();
              },
              decoration: const InputDecoration(labelText: 'Select Main Brand'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSubBrands.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    shape: const Border(
                        bottom: BorderSide(width: 1, color: Colors.lightBlue)),
                    title: Text(_filteredSubBrands[index].name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
